import json
import tempfile
import threading
import unittest
import urllib.error
import urllib.request
from http.server import ThreadingHTTPServer
from campuslife_server.server import CampusLifeService, Handler


class CampusLifeApiTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        service = CampusLifeService(self.temp_dir.name)
        configured = type("TestHandler", (Handler,), {"service": service, "cors_origin": "*"})
        self.server = ThreadingHTTPServer(("127.0.0.1", 0), configured)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.base_url = f"http://127.0.0.1:{self.server.server_port}"
        self.service = service

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=2)
        self.temp_dir.cleanup()

    def request(self, method, path, payload=None, token=None, body=None, headers=None):
        request_headers = dict(headers or {})
        if token:
            request_headers["Authorization"] = f"Bearer {token}"
        data = body if body is not None else (json.dumps(payload).encode() if payload is not None else None)
        if payload is not None:
            request_headers["Content-Type"] = "application/json"
        request = urllib.request.Request(self.base_url + path, data=data, headers=request_headers, method=method)
        try:
            response = urllib.request.urlopen(request, timeout=5)
        except urllib.error.HTTPError as error:
            response = error
        content = response.read()
        content_type = response.headers.get("Content-Type", "")
        return response.status, json.loads(content) if "json" in content_type else content

    def register(self, name, email):
        status, result = self.request("POST", "/auth/register", {"name": name, "email": email, "password": "password123"})
        self.assertEqual(status, 201)
        return result["token"], result["user"]

    def test_organizer_registration_role_is_organizer_after_me(self):
        token, registered = self.register("NewOrg", "neworg@example.test")
        self.assertEqual(registered["role"], "participant")
        status, org = self.request("POST", "/organizations", {
            "name": "New Org", "city": "City", "invite_key": "CL-CAMP-2026",
        }, token)
        self.assertEqual(status, 201)
        status, me = self.request("GET", "/auth/me", token=token)
        self.assertEqual(status, 200)
        self.assertEqual(me["role"], "organizer")

    def publish_as_admin(self, event_id):
        status, admin = self.request("POST", "/auth/sign-in", {"email": "admin@campus.ru", "password": "password123"})
        self.assertEqual(status, 200)
        status, _ = self.request("PUT", f"/events/{event_id}/status", {"status": "published"}, admin["token"])
        self.assertEqual(status, 200)

    def test_required_answers_approval_and_notifications(self):
        organizer_token, organizer = self.register("Organizer", "organizer@example.test")
        participant_token, _ = self.register("Participant", "participant@example.test")
        status, organization = self.request("POST", "/organizations", {"name": "Campus Club", "city": "City", "invite_key": "CL-CAMP-2026"}, organizer_token)
        self.assertEqual(status, 201)
        status, event = self.request("POST", f"/organizations/{organization['id']}/events", {
            "title": "Welcome Day", "category": "lecture", "start_at": "2030-01-01T10:00:00Z", "place": "Hall",
            "fields": [{"id": "why", "label": "Why attend?", "type": "text", "required": True}],
        }, organizer_token)
        self.assertEqual(status, 201)
        self.publish_as_admin(event["id"])
        field_id = event["fields"][0]["id"]
        status, invalid = self.request("POST", f"/events/{event['id']}/applications", {"answers": {}}, participant_token)
        self.assertEqual(status, 400)
        self.assertEqual(invalid["error"]["code"], "required_field")
        status, application = self.request("POST", f"/events/{event['id']}/applications", {"answers": {field_id: "Meet people"}}, participant_token)
        self.assertEqual(status, 201)
        self.assertEqual(application["status"], "pending")
        self.assertEqual(application["answers"][field_id], "Meet people")
        status, applications = self.request("GET", f"/events/{event['id']}/applications", token=organizer_token)
        self.assertEqual(status, 200)
        self.assertEqual(len(applications), 1)
        status, resolved = self.request("PUT", f"/applications/{application['id']}/status", {"status": "approved"}, organizer_token)
        self.assertEqual(status, 200)
        self.assertEqual(resolved["status"], "approved")
        status, inbox = self.request("GET", "/inbox", token=participant_token)
        self.assertEqual(status, 200)
        self.assertTrue(any(item["type"] == "application_approved" for item in inbox))
        status, organizer_inbox = self.request("GET", "/inbox", token=organizer_token)
        self.assertTrue(any(item["type"] == "application_received" for item in organizer_inbox))

    def test_media_upload_survives_service_restart(self):
        organizer_token, _ = self.register("Organizer", "media@example.test")
        _, organization = self.request("POST", "/organizations", {"name": "Media Club", "city": "City", "invite_key": "CL-DEMO-ORGS"}, organizer_token)
        _, event = self.request("POST", f"/organizations/{organization['id']}/events", {
            "title": "Photo Event", "category": "art", "start_at": "2030-01-01T10:00:00Z", "place": "Room",
        }, organizer_token)
        self.publish_as_admin(event["id"])
        media_bytes = b"persistent media bytes"
        status, media = self.request("POST", f"/events/{event['id']}/media?name=poster.bin&kind=photo", token=organizer_token, body=media_bytes, headers={"Content-Type": "application/octet-stream"})
        self.assertEqual(status, 201)
        self.assertEqual((self.service.media_dir / (media["id"] + ".bin")).read_bytes(), media_bytes)
        restarted = CampusLifeService(self.temp_dir.name)
        handler = type("RestartedHandler", (Handler,), {"service": restarted, "cors_origin": "*"})
        replacement = ThreadingHTTPServer(("127.0.0.1", 0), handler)
        thread = threading.Thread(target=replacement.serve_forever, daemon=True)
        thread.start()
        old_server, old_thread, old_url = self.server, self.thread, self.base_url
        self.server, self.thread = replacement, thread
        self.base_url = f"http://127.0.0.1:{replacement.server_port}"
        try:
            status, downloaded = self.request("GET", media["url"])
            self.assertEqual(status, 200)
            self.assertEqual(downloaded, media_bytes)
            status, details = self.request("GET", f"/events/{event['id']}")
            self.assertEqual(details["media"][0]["id"], media["id"])
        finally:
            replacement.shutdown()
            replacement.server_close()
            thread.join(timeout=2)
            self.server, self.thread, self.base_url = old_server, old_thread, old_url
    def test_publish_favorites_reminders_tickets_and_checkin(self):
        organizer_token, organizer = self.register("Org2", "org2@example.test")
        participant_token, participant = self.register("Part2", "part2@example.test")

        status, error = self.request("POST", "/organizations", {"name": "X", "city": "C", "invite_key": "CL-XXXX-XXXX"}, organizer_token)
        self.assertEqual(status, 400)
        self.assertEqual(error["error"]["code"], "invalid_invite_key")

        status, org = self.request("POST", "/organizations", {"name": "Sync Club", "city": "City", "invite_key": "CL-HACK-2026"}, organizer_token)
        self.assertEqual(status, 201)

        status, error = self.request("POST", "/organizations", {"name": "Y", "city": "C", "invite_key": "CL-HACK-2026"}, organizer_token)
        self.assertEqual(status, 400)

        status, event = self.request("POST", f"/organizations/{org['id']}/events", {
            "title": "Sync Event", "category": "science", "start_at": "2030-02-01T10:00:00Z", "place": "Hall", "status": "draft",
        }, organizer_token)
        self.assertEqual(status, 201)
        self.assertEqual(event["status"], "draft")

        status, admin = self.request("POST", "/auth/sign-in", {"email": "admin@campus.ru", "password": "password123"})
        self.assertEqual(status, 200)
        status, published = self.request("PUT", f"/events/{event['id']}/status", {"status": "published"}, admin["token"])
        self.assertEqual(status, 200)
        self.assertEqual(published["status"], "published")

        status, favorite = self.request("POST", f"/events/{event['id']}/favorite", {}, participant_token)
        self.assertEqual(status, 200)
        self.assertTrue(favorite["favorited"])
        status, favorites = self.request("GET", "/my/favorites", token=participant_token)
        self.assertEqual(status, 200)
        self.assertTrue(any(item["id"] == event["id"] for item in favorites))

        status, _ = self.request("POST", f"/events/{event['id']}/reminders", {"offset": "oneDay"}, participant_token)
        self.assertEqual(status, 200)
        status, reminder = self.request("GET", f"/events/{event['id']}/reminders", token=participant_token)
        self.assertEqual(status, 200)
        self.assertEqual(reminder["offset"], "oneDay")

        status, application = self.request("POST", f"/events/{event['id']}/applications", {"answers": {}}, participant_token)
        self.assertEqual(status, 201)
        status, tickets = self.request("GET", "/my/tickets", token=participant_token)
        self.assertEqual(status, 200)
        self.assertTrue(any(item["event_id"] == event["id"] for item in tickets))

        status, _ = self.request("PUT", f"/applications/{application['id']}/status", {"status": "approved"}, organizer_token)
        self.assertEqual(status, 200)
        status, checked = self.request("POST", f"/events/{event['id']}/check-in", {"ticket_id": participant["id"]}, organizer_token)
        self.assertEqual(status, 200)
        self.assertTrue(checked["checked_in"])
        status, attendees = self.request("GET", f"/events/{event['id']}/attendees", token=organizer_token)
        self.assertEqual(status, 200)
        self.assertTrue(any(item["status"] == "checked_in" for item in attendees))

    def test_admin_invite_keys_moderation_and_counters(self):
        # 1. Sign in as admin
        status, admin_auth = self.request("POST", "/auth/sign-in", {"email": "admin@campus.ru", "password": "password123"})
        self.assertEqual(status, 200)
        admin_token = admin_auth["token"]

        # 2. Check initial keys and mint a new one
        status, keys = self.request("GET", "/admin/invite-keys", token=admin_token)
        self.assertEqual(status, 200)
        self.assertTrue(len(keys) >= 3)
        self.assertTrue(any(k["code"] == "CL-CAMP-2026" for k in keys))

        status, minted = self.request("POST", "/admin/invite-keys", token=admin_token)
        self.assertEqual(status, 201)
        minted_code = minted["code"]
        self.assertTrue(minted_code.startswith("CL-"))
        self.assertFalse(minted["used"])

        # 3. New organizer registers with minted key
        org_token, org_user = self.register("New Org", "neworg@example.test")
        status, new_org = self.request("POST", "/organizations", {
            "name": "Robotics Club", "city": "Tomsk", "invite_key": minted_code,
        }, org_token)
        self.assertEqual(status, 201)

        # 4. Minted key cannot be reused
        status, error = self.request("POST", "/organizations", {
            "name": "Second Club", "city": "Tomsk", "invite_key": minted_code,
        }, org_token)
        self.assertEqual(status, 400)
        self.assertEqual(error["error"]["code"], "invalid_invite_key")

        # 5. Organizer creates event in pendingReview status
        status, event = self.request("POST", f"/organizations/{new_org['id']}/events", {
            "title": "Robo Expo", "category": "science", "start_at": "2030-05-01T12:00:00Z", "place": "Lab", "status": "pendingReview",
        }, org_token)
        self.assertEqual(status, 201)
        self.assertEqual(event["status"], "pendingReview")

        # 6. Admin sees it in moderation queue and approves it
        status, queue = self.request("GET", "/admin/moderation", token=admin_token)
        self.assertEqual(status, 200)
        self.assertTrue(any(item["id"] == event["id"] for item in queue))

        status, approved = self.request("PUT", f"/events/{event['id']}/status", {"status": "published"}, admin_token)
        self.assertEqual(status, 200)
        self.assertEqual(approved["status"], "published")

        # 7. Counters reflect the data
        status, counters = self.request("GET", "/admin/counters", token=admin_token)
        self.assertEqual(status, 200)
        self.assertGreaterEqual(counters["events"], 1)
        self.assertGreaterEqual(counters["orgs"], 1)
        self.assertGreaterEqual(counters["users"], 2)
        self.assertGreaterEqual(counters["active_invite_keys"], 1)
    def test_security_regressions(self):
        org_a_token, _ = self.register("OrgA", "orga@example.test")
        status, org_a = self.request("POST", "/organizations", {"name": "Org A", "city": "City", "invite_key": "CL-CAMP-2026"}, org_a_token)
        self.assertEqual(status, 201)
        org_b_token, _ = self.register("OrgB", "orgb@example.test")
        status, org_b = self.request("POST", "/organizations", {"name": "Org B", "city": "City", "invite_key": "CL-DEMO-ORGS"}, org_b_token)
        self.assertEqual(status, 201)
        p1_token, p1_user = self.register("P1", "p1@example.test")
        p2_token, _ = self.register("P2", "p2@example.test")

        # 1. IDOR: чужой организатор не может перезаписать событие по его id.
        draft_id = "evt-security-draft"
        status, _ = self.request("POST", f"/organizations/{org_a['id']}/events", {
            "id": draft_id, "title": "Draft", "category": "science",
            "start_at": "2030-01-01T10:00:00Z", "place": "Hall", "status": "draft",
        }, org_a_token)
        self.assertEqual(status, 201)
        status, error = self.request("POST", f"/organizations/{org_b['id']}/events", {
            "id": draft_id, "title": "Stolen", "category": "science",
            "start_at": "2030-01-01T10:00:00Z", "place": "Hall", "status": "draft",
        }, org_b_token)
        self.assertEqual(status, 403)
        self.assertEqual(error["error"]["code"], "forbidden")

        # 2. Черновик не виден без токена.
        status, _ = self.request("GET", f"/events/{draft_id}")
        self.assertEqual(status, 404)

        # 3. Организатор не может опубликовать минуя модерацию; админ может + причина сохраняется.
        status, error = self.request("PUT", f"/events/{draft_id}/status", {"status": "published"}, org_a_token)
        self.assertEqual(status, 403)
        self.assertEqual(error["error"]["code"], "moderation_required")
        status, admin = self.request("POST", "/auth/sign-in", {"email": "admin@campus.ru", "password": "password123"})
        self.assertEqual(status, 200)
        status, published = self.request("PUT", f"/events/{draft_id}/status", {"status": "published", "note": "одобрено"}, admin["token"])
        self.assertEqual(status, 200)
        self.assertEqual(published["moderation_note"], "одобрено")

        # 4. Лимит мест.
        cap_id = "evt-capacity"
        status, _ = self.request("POST", f"/organizations/{org_a['id']}/events", {
            "id": cap_id, "title": "Cap", "category": "science",
            "start_at": "2030-02-01T10:00:00Z", "place": "Hall",
            "capacity": 1, "auto_approve": True, "status": "published",
        }, org_a_token)
        self.assertEqual(status, 201)
        self.publish_as_admin(cap_id)
        status, _ = self.request("POST", f"/events/{cap_id}/applications", {"answers": {}}, p1_token)
        self.assertEqual(status, 201)
        status, error = self.request("POST", f"/events/{cap_id}/applications", {"answers": {}}, p2_token)
        self.assertEqual(status, 409)
        self.assertEqual(error["error"]["code"], "capacity_full")

        # 5. Check-in: одобренный билет, повтор и неодобренная заявка.
        status, checked = self.request("POST", f"/events/{cap_id}/check-in", {"ticket_id": p1_user["id"]}, org_a_token)
        self.assertEqual(status, 200)
        status, error = self.request("POST", f"/events/{cap_id}/check-in", {"ticket_id": p1_user["id"]}, org_a_token)
        self.assertEqual(status, 409)
        self.assertEqual(error["error"]["code"], "already_checked_in")
        self.request("POST", f"/events/{cap_id}/applications", {"answers": {}}, p2_token)

        # 6. Избранное/напоминания для несуществующего события -> 404, не 500.
        status, _ = self.request("POST", "/events/missing-event/favorite", {}, p1_token)
        self.assertEqual(status, 404)
        status, _ = self.request("POST", "/events/missing-event/reminders", {"offset": "oneDay"}, p1_token)
        self.assertEqual(status, 404)

        # 7. Ключ не сгорает при невалидном городе и не используется дважды.
        status, _ = self.request("POST", "/organizations", {"name": "NoCity", "invite_key": "CL-HACK-2026"}, org_a_token)
        self.assertEqual(status, 400)
        status, _ = self.request("POST", "/organizations", {"name": "OrgC", "city": "City", "invite_key": "CL-HACK-2026"}, org_a_token)
        self.assertEqual(status, 201)
        status, _ = self.request("POST", "/organizations", {"name": "Reuse", "city": "City", "invite_key": "CL-HACK-2026"}, org_a_token)
        self.assertEqual(status, 400)

        # 8. CORS разрешает DELETE.
        with urllib.request.urlopen(self.base_url + "/health", timeout=5) as response:
            self.assertIn("DELETE", response.headers.get("Access-Control-Allow-Methods", ""))

        # 9. Опасный Content-Type медиа не отдаётся как HTML.
        status, media = self.request("POST", f"/events/{cap_id}/media?name=x.html&kind=photo",
                                     token=org_a_token, body=b"<script>alert(1)</script>",
                                     headers={"Content-Type": "text/html"})
        self.assertEqual(status, 201)
        with urllib.request.urlopen(self.base_url + media["url"], timeout=5) as response:
            self.assertEqual(response.headers.get("Content-Type"), "application/octet-stream")
            self.assertIn("attachment", response.headers.get("Content-Disposition", ""))


if __name__ == "__main__":
    unittest.main()
