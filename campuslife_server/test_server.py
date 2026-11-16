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

    def test_required_answers_approval_and_notifications(self):
        organizer_token, organizer = self.register("Organizer", "organizer@example.test")
        participant_token, _ = self.register("Participant", "participant@example.test")
        status, organization = self.request("POST", "/organizations", {"name": "Campus Club", "city": "City"}, organizer_token)
        self.assertEqual(status, 201)
        status, event = self.request("POST", f"/organizations/{organization['id']}/events", {
            "title": "Welcome Day", "category": "lecture", "start_at": "2030-01-01T10:00:00Z", "place": "Hall",
            "fields": [{"id": "why", "label": "Why attend?", "type": "text", "required": True}],
        }, organizer_token)
        self.assertEqual(status, 201)
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
        _, organization = self.request("POST", "/organizations", {"name": "Media Club", "city": "City"}, organizer_token)
        _, event = self.request("POST", f"/organizations/{organization['id']}/events", {
            "title": "Photo Event", "category": "art", "start_at": "2030-01-01T10:00:00Z", "place": "Room",
        }, organizer_token)
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


if __name__ == "__main__":
    unittest.main()
