import argparse
import hashlib
import hmac
import json
import os
import re
import secrets
import sqlite3
import threading
import uuid
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse


MAX_BODY = 32 * 1024 * 1024


def now():
    return datetime.now(timezone.utc).isoformat()


def identifier():
    return str(uuid.uuid4())


def encode(value):
    return json.dumps(value, ensure_ascii=False, separators=(",", ":"))


class ApiError(Exception):
    def __init__(self, status, code, message):
        super().__init__(message)
        self.status = status
        self.code = code
        self.message = message


class DatabaseConnection(sqlite3.Connection):
    def __exit__(self, exception_type, exception, traceback):
        try:
            return super().__exit__(exception_type, exception, traceback)
        finally:
            self.close()


class CampusLifeService:
    def __init__(self, data_dir):
        self.data_dir = Path(data_dir).resolve()
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.media_dir = self.data_dir / "media"
        self.media_dir.mkdir(parents=True, exist_ok=True)
        self.db_path = self.data_dir / "campuslife.sqlite3"
        self.lock = threading.RLock()
        self.initialize()

    def connect(self):
        connection = sqlite3.connect(self.db_path, timeout=30, factory=DatabaseConnection)
        connection.row_factory = sqlite3.Row
        connection.execute("PRAGMA foreign_keys = ON")
        return connection

    def initialize(self):
        with self.connect() as db:
            db.executescript("""
                PRAGMA journal_mode = WAL;
                CREATE TABLE IF NOT EXISTS users (
                    id TEXT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL UNIQUE,
                    phone TEXT NOT NULL DEFAULT '', password_hash TEXT NOT NULL,
                    role TEXT NOT NULL DEFAULT 'participant', created_at TEXT NOT NULL
                );
                CREATE TABLE IF NOT EXISTS sessions (
                    token_hash TEXT PRIMARY KEY, user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                    created_at TEXT NOT NULL
                );
                CREATE TABLE IF NOT EXISTS organizations (
                    id TEXT PRIMARY KEY, name TEXT NOT NULL, type TEXT NOT NULL, city TEXT NOT NULL,
                    owner_id TEXT NOT NULL REFERENCES users(id), phone TEXT NOT NULL DEFAULT '',
                    email TEXT NOT NULL DEFAULT '', created_at TEXT NOT NULL
                );
                CREATE TABLE IF NOT EXISTS memberships (
                    org_id TEXT NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
                    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                    role TEXT NOT NULL DEFAULT 'member', status TEXT NOT NULL DEFAULT 'pending',
                    requested_at TEXT NOT NULL, PRIMARY KEY(org_id, user_id)
                );
                CREATE TABLE IF NOT EXISTS events (
                    id TEXT PRIMARY KEY, org_id TEXT NOT NULL REFERENCES organizations(id),
                    title TEXT NOT NULL, description TEXT NOT NULL DEFAULT '', category TEXT NOT NULL,
                    start_at TEXT NOT NULL, place TEXT NOT NULL, capacity INTEGER NOT NULL DEFAULT -1,
                    status TEXT NOT NULL DEFAULT 'published', created_at TEXT NOT NULL
                );
                CREATE TABLE IF NOT EXISTS fields (
                    id TEXT PRIMARY KEY, event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
                    label TEXT NOT NULL, type TEXT NOT NULL DEFAULT 'text', required INTEGER NOT NULL DEFAULT 0,
                    options_json TEXT NOT NULL DEFAULT '[]', position INTEGER NOT NULL DEFAULT 0
                );
                CREATE TABLE IF NOT EXISTS media (
                    id TEXT PRIMARY KEY, event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
                    filename TEXT NOT NULL, content_type TEXT NOT NULL, size INTEGER NOT NULL,
                    kind TEXT NOT NULL, position INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL
                );
                CREATE TABLE IF NOT EXISTS applications (
                    id TEXT PRIMARY KEY, event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
                    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                    answers_json TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending',
                    created_at TEXT NOT NULL, updated_at TEXT NOT NULL,
                    UNIQUE(event_id, user_id)
                );
                CREATE TABLE IF NOT EXISTS notifications (
                    id TEXT PRIMARY KEY, user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                    type TEXT NOT NULL, payload_json TEXT NOT NULL,
                    created_at TEXT NOT NULL, read_at TEXT
                );
                CREATE INDEX IF NOT EXISTS applications_event_status ON applications(event_id, status);
                CREATE INDEX IF NOT EXISTS notifications_user_created ON notifications(user_id, created_at);
            """)
            media_columns = {row["name"] for row in db.execute("PRAGMA table_info(media)")}
            if "position" not in media_columns:
                db.execute("ALTER TABLE media ADD COLUMN position INTEGER NOT NULL DEFAULT 0")
            event_columns = {row["name"] for row in db.execute("PRAGMA table_info(events)")}
            if "auto_approve" not in event_columns:
                db.execute("ALTER TABLE events ADD COLUMN auto_approve INTEGER NOT NULL DEFAULT 0")
            if "moderation_note" not in event_columns:
                db.execute("ALTER TABLE events ADD COLUMN moderation_note TEXT NOT NULL DEFAULT ''")
            membership_columns = {row["name"] for row in db.execute("PRAGMA table_info(memberships)")}
            if "note" not in membership_columns:
                db.execute("ALTER TABLE memberships ADD COLUMN note TEXT NOT NULL DEFAULT ''")

            db.executescript('''
                CREATE TABLE IF NOT EXISTS favorites (
                    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                    event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
                    created_at TEXT NOT NULL,
                    PRIMARY KEY(user_id, event_id)
                );
                CREATE TABLE IF NOT EXISTS reminders (
                    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                    event_id TEXT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
                    offset TEXT NOT NULL,
                    created_at TEXT NOT NULL,
                    PRIMARY KEY(user_id, event_id)
                );
                CREATE TABLE IF NOT EXISTS invite_keys (
                    code TEXT PRIMARY KEY,
                    created_at TEXT NOT NULL,
                    used INTEGER NOT NULL DEFAULT 0
                );
            ''')
            for k in ["CL-CAMP-2026", "CL-DEMO-ORGS", "CL-HACK-2026"]:
                db.execute("INSERT OR IGNORE INTO invite_keys(code, created_at) VALUES(?, ?)", (k, now()))

            demo_users = [
                ("usr_student", "Студент Аня", "student@campus.ru", "+79991234567", "participant"),
                ("usr_organizer", "Организатор IT-Клуба", "organizer@campus.ru", "+79997654321", "organizer"),
                ("usr_admin", "Администратор", "admin@campus.ru", "+79990000000", "admin"),
            ]
            for uid, uname, uemail, uphone, urole in demo_users:
                existing = db.execute("SELECT id FROM users WHERE email=?", (uemail,)).fetchone()
                if not existing:
                    db.execute(
                        "INSERT INTO users(id,name,email,phone,password_hash,role,created_at) VALUES(?,?,?,?,?,?,?)",
                        (uid, uname, uemail, uphone, self.password_hash("password123"), urole, now()),
                    )

    def password_hash(self, password, salt=None):
        salt = salt or secrets.token_hex(16)
        digest = hashlib.pbkdf2_hmac("sha256", password.encode(), bytes.fromhex(salt), 240000)
        return salt + "$" + digest.hex()

    def verify_password(self, password, stored):
        try:
            salt, digest = stored.split("$", 1)
            return hmac.compare_digest(self.password_hash(password, salt).split("$", 1)[1], digest)
        except (ValueError, TypeError):
            return False

    def user_for_token(self, token):
        if not token:
            raise ApiError(401, "unauthorized", "Sign in is required")
        token_hash = hashlib.sha256(token.encode()).hexdigest()
        with self.connect() as db:
            row = db.execute("SELECT u.* FROM sessions s JOIN users u ON u.id=s.user_id WHERE s.token_hash=?", (token_hash,)).fetchone()
        if row is None:
            raise ApiError(401, "unauthorized", "Session is invalid or expired")
        return dict(row)

    def require_organizer(self, user, org_id):
        if user and user.get("role") == "admin":
            return
        with self.connect() as db:
            row = db.execute("SELECT o.owner_id,m.role,m.status FROM organizations o LEFT JOIN memberships m ON m.org_id=o.id AND m.user_id=? WHERE o.id=?", (user["id"], org_id)).fetchone()
        if row is None:
            raise ApiError(404, "not_found", "Organization not found")
        if row["owner_id"] != user["id"] and not (row["status"] == "approved" and row["role"] in ("owner", "manager")):
            raise ApiError(403, "forbidden", "Organizer access is required")

    def require_admin(self, user):
        if not user or user.get("role") != "admin":
            raise ApiError(403, "forbidden", "Admin access is required")

    def notify(self, db, user_id, kind, payload):
        db.execute("INSERT INTO notifications(id,user_id,type,payload_json,created_at) VALUES(?,?,?,?,?)", (identifier(), user_id, kind, encode(payload), now()))

    def register(self, data):
        name = self.text(data, "name")
        email = self.text(data, "email").lower()
        password = self.text(data, "password")
        if len(password) < 8:
            raise ApiError(400, "invalid_password", "Password must contain at least 8 characters")
        user_id = identifier()
        try:
            with self.connect() as db:
                db.execute("INSERT INTO users(id,name,email,phone,password_hash,created_at) VALUES(?,?,?,?,?,?)", (user_id, name, email, str(data.get("phone", "")), self.password_hash(password), now()))
        except sqlite3.IntegrityError:
            raise ApiError(409, "email_exists", "An account with this email already exists")
        return self.sign_in({"email": email, "password": password})

    def sign_in(self, data):
        email = self.text(data, "email").lower()
        password = self.text(data, "password")
        with self.connect() as db:
            row = db.execute("SELECT * FROM users WHERE email=?", (email,)).fetchone()
            if row is None or not self.verify_password(password, row["password_hash"]):
                raise ApiError(401, "invalid_credentials", "Email or password is incorrect")
            token = secrets.token_urlsafe(36)
            db.execute("INSERT INTO sessions(token_hash,user_id,created_at) VALUES(?,?,?)", (hashlib.sha256(token.encode()).hexdigest(), row["id"], now()))
        return {"token": token, "user": self.public_user(row)}

    def public_user(self, row):
        return {"id": row["id"], "name": row["name"], "email": row["email"], "phone": row["phone"], "role": row["role"]}

    def text(self, data, key):
        value = data.get(key)
        if not isinstance(value, str) or not value.strip():
            raise ApiError(400, "invalid_request", f"{key} is required")
        return value.strip()

    def create_organization(self, user, data):
        name = self.text(data, "name")
        city = self.text(data, "city")
        invite_key = str(data.get("invite_key", "")).strip().upper()
        if not invite_key:
            raise ApiError(400, "invalid_invite_key", "Неверный или уже использованный invite-ключ")
        # Ключ гасим только после валидации полей и в одной транзакции с созданием
        # организации — иначе при ошибке ключ сгорает зря, а параллельные запросы
        # могут создать несколько организаций на один ключ.
        with self.lock:
            with self.connect() as db:
                k_row = db.execute("SELECT code FROM invite_keys WHERE code=? AND used=0", (invite_key,)).fetchone()
                if not k_row:
                    raise ApiError(400, "invalid_invite_key", "Неверный или уже использованный invite-ключ")
                org_id = identifier()
                db.execute("UPDATE invite_keys SET used=1 WHERE code=?", (invite_key,))
                db.execute("INSERT INTO organizations(id,name,type,city,owner_id,phone,email,created_at) VALUES(?,?,?,?,?,?,?,?)", (org_id, name, str(data.get("type", "club")), city, user["id"], str(data.get("phone", "")), str(data.get("email", "")), now()))
                db.execute("INSERT INTO memberships(org_id,user_id,role,status,requested_at) VALUES(?,?,?,'approved',?)", (org_id, user["id"], "owner", now()))
                db.execute("UPDATE users SET role='organizer' WHERE id=?", (user["id"],))
        return {"id": org_id, "name": name, "owner_id": user["id"]}

    def list_organizations(self, user):
        with self.connect() as db:
            rows = db.execute(
                "SELECT DISTINCT o.* FROM organizations o LEFT JOIN memberships m ON m.org_id=o.id WHERE o.owner_id=? OR (m.user_id=? AND m.status='approved') ORDER BY o.created_at DESC",
                (user["id"], user["id"]),
            ).fetchall()
        return [dict(row) for row in rows]

    def list_organization_events(self, user, org_id):
        self.require_organizer(user, org_id)
        with self.connect() as db:
            ids = db.execute(
                "SELECT id FROM events WHERE org_id=? ORDER BY start_at DESC",
                (org_id,),
            ).fetchall()
        return [self.event_details(row["id"], include_unpublished=True) for row in ids]

    def _event_values(self, data):
        title = self.text(data, "title")
        start_at = self.text(data, "start_at")
        place = self.text(data, "place")
        category = str(data.get("category", "contest"))
        try:
            capacity = int(data.get("capacity", -1))
        except (ValueError, TypeError):
            raise ApiError(400, "invalid_request", "capacity must be an integer")
        if capacity < -1:
            raise ApiError(400, "invalid_request", "capacity must be -1 or greater")
        fields = data.get("fields", [])
        media = data.get("media", [])
        if not isinstance(fields, list) or len(fields) > 10:
            raise ApiError(400, "invalid_request", "fields must be an array of at most 10 items")
        if not isinstance(media, list):
            raise ApiError(400, "invalid_request", "media must be an array")
        status = str(data.get("status", "published"))
        if status not in ("draft", "pendingReview", "published", "rejected", "cancelled"):
            raise ApiError(400, "invalid_status", "Invalid event status")
        auto_approve = 1 if data.get("auto_approve") in (True, 1, "1", "true") else 0
        return title, start_at, place, category, capacity, str(data.get("description", "")), status, fields, media, auto_approve

    def create_event(self, user, org_id, data):
        self.require_organizer(user, org_id)
        event_id = str(data.get("id") or identifier())
        title, start_at, place, category, capacity, description, status, fields, media, auto_approve = self._event_values(data)
        # Организатор не может сразу выложить событие в ленту — только в очередь модерации.
        if status in ("published", "rejected") and user.get("role") != "admin":
            status = "pendingReview"
        with self.connect() as db:
            existing = db.execute("SELECT id,org_id FROM events WHERE id=?", (event_id,)).fetchone()
            if existing and existing["org_id"] != org_id:
                raise ApiError(403, "forbidden", "Event belongs to another organization")
            if existing:
                db.execute(
                    "UPDATE events SET org_id=?,title=?,description=?,category=?,start_at=?,place=?,capacity=?,status=?,auto_approve=? WHERE id=?",
                    (org_id, title, description, category, start_at, place, capacity, status, auto_approve, event_id)
                )
                db.execute("DELETE FROM fields WHERE event_id=?", (event_id,))
            else:
                db.execute(
                    "INSERT INTO events(id,org_id,title,description,category,start_at,place,capacity,status,auto_approve,created_at) VALUES(?,?,?,?,?,?,?,?,?,?,?)",
                    (event_id, org_id, title, description, category, start_at, place, capacity, status, auto_approve, now())
                )
            for position, field in enumerate(fields):
                self.insert_field(db, event_id, field, position)
            for position, item in enumerate(media):
                self.attach_existing_media(db, event_id, item, position)
        return self.event_details(event_id, include_unpublished=True)

    def attach_existing_media(self, db, event_id, item, position):
        if not isinstance(item, dict) or not isinstance(item.get("id"), str):
            raise ApiError(400, "invalid_media", "Each media item must have an uploaded media id")
        cursor = db.execute("UPDATE media SET event_id=?,position=? WHERE id=? AND event_id=?", (event_id, position, item["id"], event_id))
        if cursor.rowcount == 0:
            raise ApiError(400, "invalid_media", "Uploaded media does not belong to this event")

    def insert_field(self, db, event_id, field, position):
        if not isinstance(field, dict):
            raise ApiError(400, "invalid_field", "Each field must be an object")
        label = self.text(field, "label")
        options = field.get("options", [])
        if not isinstance(options, list) or any(not isinstance(item, str) for item in options):
            raise ApiError(400, "invalid_field", "Field options must be an array of strings")
        db.execute("INSERT INTO fields(id,event_id,label,type,required,options_json,position) VALUES(?,?,?,?,?,?,?)", (str(field.get("id") or identifier()), event_id, label, str(field.get("type", "text")), 1 if field.get("required", False) else 0, encode(options), int(field.get("position", position))))

    def can_manage_event(self, user, event_id):
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
        if row is None:
            return False
        if user.get("role") == "admin":
            return True
        with self.connect() as db:
            membership = db.execute(
                "SELECT 1 FROM memberships WHERE org_id=? AND user_id=? AND status='approved' AND role IN ('owner','manager')",
                (row["org_id"], user["id"]),
            ).fetchone()
        return membership is not None

    def event_details(self, event_id, include_unpublished=False):
        with self.connect() as db:
            event = db.execute("SELECT e.*,o.name AS organization_name FROM events e JOIN organizations o ON o.id=e.org_id WHERE e.id=?", (event_id,)).fetchone()
            if event is None:
                raise ApiError(404, "not_found", "Event not found")
            if not include_unpublished and event["status"] != "published":
                raise ApiError(404, "not_found", "Event not found")
            result = dict(event)
            result["auto_approve"] = bool(event["auto_approve"]) if "auto_approve" in event.keys() else False
            result["fields"] = [dict(field, required=bool(field["required"]), options=json.loads(field["options_json"])) for field in db.execute("SELECT * FROM fields WHERE event_id=? ORDER BY position", (event_id,))]
            result["media"] = [dict(row, url=f"/media/{row['id']}") for row in db.execute("SELECT * FROM media WHERE event_id=? ORDER BY created_at", (event_id,))]
            return result

    def update_event(self, user, event_id, data):
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
        if row is None:
            raise ApiError(404, "not_found", "Event not found")
        self.require_organizer(user, row["org_id"])
        fields = data.get("fields", [])
        if not isinstance(fields, list):
            raise ApiError(400, "invalid_request", "fields must be an array")
        try:
            capacity = int(data.get("capacity", -1))
        except (ValueError, TypeError):
            raise ApiError(400, "invalid_request", "capacity must be an integer")
        auto_approve = 1 if data.get("auto_approve") in (True, 1, "1", "true") else 0
        with self.connect() as db:
            db.execute(
                "UPDATE events SET title=?,description=?,category=?,start_at=?,place=?,capacity=?,status=?,auto_approve=? WHERE id=?",
                (self.text(data, "title"), str(data.get("description", "")), str(data.get("category", "other")), self.text(data, "start_at"), self.text(data, "place"), capacity, str(data.get("status", "draft")), auto_approve, event_id),
            )
            db.execute("DELETE FROM fields WHERE event_id=?", (event_id,))
            for position, field in enumerate(fields):
                self.insert_field(db, event_id, field, position)
        return self.event_details(event_id, include_unpublished=True)

    def set_event_status(self, user, event_id, status, note=""):
        if status not in ("draft", "pendingReview", "published", "rejected", "cancelled"):
            raise ApiError(400, "invalid_status", "Invalid event status")
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
        if row is None:
            raise ApiError(404, "not_found", "Event not found")
        self.require_organizer(user, row["org_id"])
        # Публикация и отклонение — прерогатива администратора (очередь модерации).
        if status in ("published", "rejected") and user.get("role") != "admin":
            raise ApiError(403, "moderation_required", "Only an administrator can publish or reject events")
        with self.connect() as db:
            if status in ("published", "rejected"):
                db.execute("UPDATE events SET status=?,moderation_note=? WHERE id=?", (status, str(note or "")[:1000], event_id))
            else:
                db.execute("UPDATE events SET status=? WHERE id=?", (status, event_id))
        return self.event_details(event_id, include_unpublished=True)

    def delete_event(self, user, event_id):
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
        if row is None:
            raise ApiError(404, "not_found", "Event not found")
        self.require_organizer(user, row["org_id"])
        with self.connect() as db:
            media = db.execute("SELECT id,filename FROM media WHERE event_id=?", (event_id,)).fetchall()
            db.execute("DELETE FROM events WHERE id=?", (event_id,))
        for item in media:
            (self.media_dir / (item["id"] + Path(item["filename"]).suffix[:16])).unlink(missing_ok=True)
        return {"deleted": True}

    def apply(self, user, event_id, answers):
        if not isinstance(answers, dict):
            raise ApiError(400, "invalid_request", "answers must be an object")
        with self.connect() as db:
            event = db.execute("SELECT * FROM events WHERE id=?", (event_id,)).fetchone()
            if event is None:
                raise ApiError(404, "not_found", "Event not found")
            if event["status"] != "published":
                raise ApiError(409, "event_unavailable", "Applications are not open for this event")
            fields = db.execute("SELECT * FROM fields WHERE event_id=?", (event_id,)).fetchall()
            by_id = {field["id"]: field for field in fields}
            for key, field in by_id.items():
                if field["required"] and (key not in answers or answers[key] is None or str(answers[key]).strip() == ""):
                    raise ApiError(400, "required_field", f"Answer required for: {field['label']}")
            unknown = set(answers) - set(by_id)
            if unknown:
                raise ApiError(400, "unknown_field", "Answers contain unknown custom field IDs")
            for key, value in answers.items():
                if not isinstance(value, (str, int, float, bool, type(None))):
                    raise ApiError(400, "invalid_answer", f"Answer for {key} must be a scalar")
                choices = json.loads(by_id[key]["options_json"])
                if choices and value not in choices:
                    raise ApiError(400, "invalid_answer", f"Answer for {by_id[key]['label']} is not an available option")
            existing = db.execute("SELECT id,status FROM applications WHERE event_id=? AND user_id=?", (event_id, user["id"])).fetchone()
            if existing:
                if existing["status"] != "pending":
                    raise ApiError(409, "application_resolved", "A resolved application cannot be changed")
                db.execute("UPDATE applications SET answers_json=?,updated_at=? WHERE id=?", (encode(answers), now(), existing["id"]))
                return self.application_dict(db, existing["id"])
            if event["capacity"] > 0:
                taken = db.execute(
                    "SELECT count(*) as c FROM applications WHERE event_id=? AND status IN ('approved','checked_in')",
                    (event_id,),
                ).fetchone()["c"]
                if taken >= event["capacity"]:
                    raise ApiError(409, "capacity_full", "Свободных мест не осталось")
            application_id = identifier()
            auto_approve = bool(event["auto_approve"]) if "auto_approve" in event.keys() else False
            initial_status = "approved" if auto_approve else "pending"
            db.execute("INSERT INTO applications(id,event_id,user_id,answers_json,status,created_at,updated_at) VALUES(?,?,?,?,?,?,?)", (application_id, event_id, user["id"], encode(answers), initial_status, now(), now()))
            owner = db.execute("SELECT owner_id FROM organizations WHERE id=?", (event["org_id"],)).fetchone()
            self.notify(db, owner["owner_id"], "application_received", {"application_id": application_id, "event_id": event_id, "event_title": event["title"]})
            return self.application_dict(db, application_id)

    def application_dict(self, db, application_id):
        row = db.execute("SELECT a.*,u.name AS applicant_name,u.email AS applicant_email,u.phone AS applicant_phone FROM applications a JOIN users u ON u.id=a.user_id WHERE a.id=?", (application_id,)).fetchone()
        result = dict(row)
        result["answers"] = json.loads(result.pop("answers_json"))
        return result

    def list_applications(self, user, event_id):
        with self.connect() as db:
            event = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
            if event is None:
                raise ApiError(404, "not_found", "Event not found")
        self.require_organizer(user, event["org_id"])
        with self.connect() as db:
            ids = db.execute("SELECT id FROM applications WHERE event_id=? ORDER BY created_at DESC", (event_id,)).fetchall()
            return [self.application_dict(db, row["id"]) for row in ids]

    def resolve_application(self, user, application_id, status):
        if status not in ("approved", "rejected"):
            raise ApiError(400, "invalid_status", "status must be approved or rejected")
        with self.connect() as db:
            row = db.execute("SELECT a.*,e.org_id,e.title FROM applications a JOIN events e ON e.id=a.event_id WHERE a.id=?", (application_id,)).fetchone()
            if row is None:
                raise ApiError(404, "not_found", "Application not found")
        self.require_organizer(user, row["org_id"])
        with self.connect() as db:
            current = db.execute("SELECT status FROM applications WHERE id=?", (application_id,)).fetchone()
            if current["status"] != "pending":
                raise ApiError(409, "application_resolved", "Application has already been resolved")
            db.execute("UPDATE applications SET status=?,updated_at=? WHERE id=?", (status, now(), application_id))
            self.notify(db, row["user_id"], "application_" + status, {"application_id": application_id, "event_id": row["event_id"], "event_title": row["title"], "status": status})
            return self.application_dict(db, application_id)

    def request_membership(self, user, org_id, note=""):
        with self.connect() as db:
            if db.execute("SELECT 1 FROM organizations WHERE id=?", (org_id,)).fetchone() is None:
                raise ApiError(404, "not_found", "Organization not found")
            db.execute("INSERT INTO memberships(org_id,user_id,role,status,note,requested_at) VALUES(?,?,?,'pending',?,?) ON CONFLICT(org_id,user_id) DO UPDATE SET status='pending',note=excluded.note,requested_at=excluded.requested_at", (org_id, user["id"], "member", note, now()))
        return {"org_id": org_id, "user_id": user["id"], "status": "pending", "note": note}

    def membership_action(self, user, org_id, member_id, approve, role):
        self.require_organizer(user, org_id)
        if role not in ("member", "manager"):
            raise ApiError(400, "invalid_role", "role must be member or manager")
        status = "approved" if approve else "declined"
        with self.connect() as db:
            cursor = db.execute("UPDATE memberships SET status=?,role=? WHERE org_id=? AND user_id=? AND status='pending'", (status, role if approve else "member", org_id, member_id))
            if cursor.rowcount == 0:
                raise ApiError(404, "not_found", "Pending membership request not found")
            if approve:
                db.execute("UPDATE users SET role='organizer' WHERE id=?", (member_id,))
            self.notify(db, member_id, "membership_" + status, {"org_id": org_id, "role": role if approve else "member"})
        return {"org_id": org_id, "user_id": member_id, "status": status, "role": role if approve else "member"}

    def upload(self, user, event_id, body, content_type, query):
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
        if row is None:
            with self.connect() as db:
                org_row = db.execute(
                    "SELECT o.id FROM organizations o JOIN memberships m ON m.org_id=o.id WHERE m.user_id=? AND m.status='approved' AND m.role IN ('organizer', 'owner') LIMIT 1",
                    (user["id"],)
                ).fetchone()
                if org_row is None and user.get("role") == "admin":
                    org_row = db.execute("SELECT id FROM organizations LIMIT 1").fetchone()
            if org_row is None:
                raise ApiError(404, "not_found", "Organization not found for event")
            org_id = org_row["id"]
            with self.connect() as db:
                db.execute(
                    "INSERT INTO events(id, org_id, title, description, category, start_at, place, capacity, status, auto_approve, created_at) "
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    (event_id, org_id, "Черновик", "", "science", now(), "Кампус", -1, "draft", 0, now())
                )
            row = {"org_id": org_id}
        self.require_organizer(user, row["org_id"])
        if not body:
            raise ApiError(400, "empty_upload", "Uploaded file is empty")
        if len(body) > MAX_BODY:
            raise ApiError(413, "upload_too_large", "Media file exceeds the 32 MiB limit")
        requested_name = unquote(query.get("name", [""])[0])
        name = Path(requested_name).name if requested_name else "upload"
        name = re.sub(r"[^A-Za-z0-9._-]", "_", name)[:120] or "upload"
        media_id = identifier()
        extension = Path(name).suffix[:16]
        stored_name = media_id + extension
        path = self.media_dir / stored_name
        path.write_bytes(body)
        kind = query.get("kind", ["photo"])[0]
        if kind not in ("photo", "video"):
            path.unlink(missing_ok=True)
            raise ApiError(400, "invalid_media_kind", "kind must be photo or video")
        with self.connect() as db:
            db.execute("INSERT INTO media(id,event_id,filename,content_type,size,kind,created_at) VALUES(?,?,?,?,?,?,?)", (media_id, event_id, name, content_type or "application/octet-stream", len(body), kind, now()))
        return {"id": media_id, "event_id": event_id, "filename": name, "content_type": content_type or "application/octet-stream", "size": len(body), "kind": kind, "url": f"/media/{media_id}"}

    def media_file(self, media_id):
        with self.connect() as db:
            row = db.execute("SELECT * FROM media WHERE id=?", (media_id,)).fetchone()
        if row is None:
            raise ApiError(404, "not_found", "Media not found")
        path = self.media_dir / (media_id + Path(row["filename"]).suffix[:16])
        if not path.is_file():
            raise ApiError(404, "not_found", "Media file is missing")
        return path, row["content_type"], row["size"]


    def list_my_applications(self, user):
        with self.connect() as db:
            rows = db.execute(
                "SELECT a.id, a.event_id, a.status, a.created_at, a.updated_at, a.answers_json "
                "FROM applications a WHERE a.user_id=? ORDER BY a.created_at DESC",
                (user["id"],)
            ).fetchall()
        result = []
        for row in rows:
            event = self.event_details(row["event_id"], include_unpublished=True)
            item = {
                "id": row["id"],
                "event_id": row["event_id"],
                "event": event,
                "status": row["status"],
                "created_at": row["created_at"],
                "updated_at": row["updated_at"],
                "answers": json.loads(row["answers_json"]) if row["answers_json"] else {},
                "ticket_code": f"CL-{row['id'][:8].upper()}",
                "qr_payload": f"campuslife://ticket/{row['id']}?event={row['event_id']}&user={user['id']}",
            }
            result.append(item)
        return result

    def ensure_event(self, db, event_id):
        if db.execute("SELECT 1 FROM events WHERE id=?", (event_id,)).fetchone() is None:
            raise ApiError(404, "not_found", "Event not found")

    def toggle_favorite(self, user, event_id):
        with self.connect() as db:
            self.ensure_event(db, event_id)
            existing = db.execute("SELECT 1 FROM favorites WHERE user_id=? AND event_id=?", (user["id"], event_id)).fetchone()
            if existing:
                db.execute("DELETE FROM favorites WHERE user_id=? AND event_id=?", (user["id"], event_id))
                return {"favorited": False, "event_id": event_id}
            else:
                db.execute("INSERT INTO favorites(user_id, event_id, created_at) VALUES(?,?,?)", (user["id"], event_id, now()))
                return {"favorited": True, "event_id": event_id}

    def list_my_favorites(self, user):
        with self.connect() as db:
            rows = db.execute("SELECT event_id FROM favorites WHERE user_id=? ORDER BY created_at DESC", (user["id"],)).fetchall()
        return [self.event_details(row["event_id"], include_unpublished=True) for row in rows]

    def set_reminder(self, user, event_id, offset):
        with self.connect() as db:
            self.ensure_event(db, event_id)
            db.execute("INSERT OR REPLACE INTO reminders(user_id, event_id, offset, created_at) VALUES(?,?,?,?)", (user["id"], event_id, str(offset), now()))
        return {"reminded": True, "event_id": event_id, "offset": offset}

    def clear_reminder(self, user, event_id):
        with self.connect() as db:
            db.execute("DELETE FROM reminders WHERE user_id=? AND event_id=?", (user["id"], event_id))
        return {"reminded": False, "event_id": event_id}

    def check_in(self, user, event_id, ticket_id):
        ticket = str(ticket_id or "").strip()
        # QR-код билета имеет вид eventId:userId — поддерживаем оба формата.
        if ":" in ticket:
            parts = ticket.split(":", 2)
            if parts[0] == event_id:
                ticket = parts[1]
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
            if not row:
                raise ApiError(404, "not_found", "Event not found")
            self.require_organizer(user, row["org_id"])
            application = db.execute(
                "SELECT id,status FROM applications WHERE (id=? OR user_id=?) AND event_id=?",
                (ticket, ticket, event_id),
            ).fetchone()
            if application is None:
                raise ApiError(404, "not_found", "Ticket not found for this event")
            if application["status"] == "checked_in":
                raise ApiError(409, "already_checked_in", "Этот билет уже отсканирован")
            if application["status"] != "approved":
                raise ApiError(409, "ticket_not_approved", "Заявка не одобрена")
            db.execute(
                "UPDATE applications SET status='checked_in', updated_at=? WHERE id=?",
                (now(), application["id"]),
            )
        return {"checked_in": True, "ticket_id": ticket, "event_id": event_id}

    def my_reminder(self, user, event_id):
        with self.connect() as db:
            row = db.execute(
                "SELECT offset FROM reminders WHERE user_id=? AND event_id=?",
                (user["id"], event_id),
            ).fetchone()
        if not row:
            return None
        return {"event_id": event_id, "offset": row["offset"], "event": self.event_details(event_id, include_unpublished=True)}

    def event_attendees(self, user, event_id):
        with self.connect() as db:
            row = db.execute("SELECT org_id FROM events WHERE id=?", (event_id,)).fetchone()
            if not row:
                raise ApiError(404, "not_found", "Event not found")
            self.require_organizer(user, row["org_id"])
            rows = db.execute(
                "SELECT a.*, u.name, u.email, u.phone FROM applications a JOIN users u ON u.id=a.user_id WHERE a.event_id=? ORDER BY a.created_at",
                (event_id,)
            ).fetchall()
        return [dict(r, answers=json.loads(r["answers_json"])) for r in rows]

    def list_invite_keys(self, user):
        self.require_admin(user)
        with self.connect() as db:
            rows = db.execute("SELECT code, created_at, used FROM invite_keys ORDER BY created_at DESC").fetchall()
        return [dict(row, used=bool(row["used"])) for row in rows]

    def mint_invite_key(self, user):
        self.require_admin(user)
        chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        part1 = "".join(secrets.choice(chars) for _ in range(4))
        part2 = "".join(secrets.choice(chars) for _ in range(4))
        code = f"CL-{part1}-{part2}"
        created = now()
        with self.connect() as db:
            db.execute("INSERT INTO invite_keys(code, created_at, used) VALUES(?, ?, 0)", (code, created))
        return {"code": code, "created_at": created, "used": False}

    def moderation_queue(self, user):
        self.require_admin(user)
        with self.connect() as db:
            rows = db.execute("SELECT id FROM events WHERE status='pendingReview' ORDER BY created_at DESC").fetchall()
        return [self.event_details(row["id"], include_unpublished=True) for row in rows]

    def admin_counters(self, user):
        self.require_admin(user)
        with self.connect() as db:
            events_count = db.execute("SELECT count(*) as c FROM events").fetchone()["c"]
            orgs_count = db.execute("SELECT count(*) as c FROM organizations").fetchone()["c"]
            users_count = db.execute("SELECT count(*) as c FROM users").fetchone()["c"]
            pending_count = db.execute("SELECT count(*) as c FROM events WHERE status='pendingReview'").fetchone()["c"]
            keys_count = db.execute("SELECT count(*) as c FROM invite_keys WHERE used=0").fetchone()["c"]
        return {
            "events": events_count,
            "orgs": orgs_count,
            "users": users_count,
            "pending_moderation": pending_count,
            "open_reports": 0,
            "active_invite_keys": keys_count,
        }

class Handler(BaseHTTPRequestHandler):
    service = None
    cors_origin = "*"

    def log_message(self, format_string, *args):
        print(f"{self.address_string()} - {format_string % args}")

    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", self.cors_origin)
        self.send_header("Access-Control-Allow-Headers", "Authorization, Content-Type, X-Filename")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        self.send_header("Vary", "Origin")
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(204)
        self.end_headers()

    def do_GET(self):
        self.dispatch()

    def do_POST(self):
        self.dispatch()

    def do_PUT(self):
        self.dispatch()

    def do_PATCH(self):
        self.dispatch()

    def do_DELETE(self):
        self.dispatch()

    def token_user(self, optional=False):
        auth = self.headers.get("Authorization", "")
        token = auth[7:].strip() if auth.lower().startswith("bearer ") else ""
        if optional and not token:
            return None
        return self.service.user_for_token(token)

    def read_body(self):
        try:
            length = int(self.headers.get("Content-Length", "0"))
        except ValueError:
            raise ApiError(400, "invalid_content_length", "Content-Length must be an integer")
        if length > MAX_BODY:
            raise ApiError(413, "body_too_large", "Request body exceeds the 32 MiB limit")
        body = self.rfile.read(length)
        if len(body) != length:
            raise ApiError(400, "incomplete_body", "Request body was incomplete")
        return body

    def read_json(self):
        body = self.read_body()
        try:
            value = json.loads(body.decode("utf-8") or "{}")
        except (UnicodeDecodeError, json.JSONDecodeError):
            raise ApiError(400, "invalid_json", "Request body must be valid UTF-8 JSON")
        if not isinstance(value, dict):
            raise ApiError(400, "invalid_json", "Request JSON must be an object")
        return value

    def send_json(self, status, value):
        body = encode(value).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def dispatch(self):
        try:
            parsed = urlparse(self.path)
            path = [unquote(part) for part in parsed.path.strip("/").split("/") if part]
            query = parse_qs(parsed.query)
            method = self.command
            if path == ["health"] and method == "GET":
                return self.send_json(200, {"status": "ok"})
            if len(path) == 2 and path[0] == "media" and method == "GET":
                media_path, content_type, size = self.service.media_file(path[1])
                base_type = content_type.split(";", 1)[0].strip().lower()
                unsafe = base_type in (
                    "text/html", "text/javascript", "application/javascript",
                    "image/svg+xml", "text/xml", "application/xml",
                )
                if unsafe:
                    content_type = "application/octet-stream"
                self.send_response(200)
                self.send_header("Content-Type", content_type)
                self.send_header("Content-Length", str(size))
                self.send_header("X-Content-Type-Options", "nosniff")
                if unsafe:
                    self.send_header("Content-Disposition", 'attachment; filename="media"')
                self.end_headers()
                with media_path.open("rb") as source:
                    while chunk := source.read(65536):
                        self.wfile.write(chunk)
                return
            if path == ["auth", "register"] and method == "POST":
                return self.send_json(201, self.service.register(self.read_json()))
            if path == ["auth", "sign-in"] and method == "POST":
                return self.send_json(200, self.service.sign_in(self.read_json()))
            if path == ["auth", "me"] and method == "GET":
                return self.send_json(200, self.service.public_user(self.token_user()))
            if path == ["organizations"] and method == "POST":
                return self.send_json(201, self.service.create_organization(self.token_user(), self.read_json()))
            if path == ["organizations"] and method == "GET":
                return self.send_json(200, self.service.list_organizations(self.token_user()))
            if len(path) == 3 and path[0] == "organizations" and path[2] == "membership" and method == "POST":
                payload = self.read_json() if self.headers.get("Content-Length") and int(self.headers["Content-Length"]) > 0 else {}
                note = str(payload.get("note", ""))
                return self.send_json(201, self.service.request_membership(self.token_user(), path[1], note))
            if len(path) == 4 and path[0] == "organizations" and path[2] == "members" and path[3] == "pending" and method == "GET":
                user = self.token_user()
                self.service.require_organizer(user, path[1])
                with self.service.connect() as db:
                    rows = db.execute("SELECT m.*,u.name,u.email,u.phone FROM memberships m JOIN users u ON u.id=m.user_id WHERE m.org_id=? AND m.status='pending' ORDER BY m.requested_at", (path[1],)).fetchall()
                return self.send_json(200, [dict(row) for row in rows])
            if len(path) == 5 and path[0] == "organizations" and path[2] == "members" and path[4] in ("approve", "reject") and method == "POST":
                payload = self.read_json()
                return self.send_json(200, self.service.membership_action(self.token_user(), path[1], path[3], path[4] == "approve", str(payload.get("role", "member"))))
            if len(path) == 3 and path[0] == "organizations" and path[2] == "events" and method == "POST":
                return self.send_json(201, self.service.create_event(self.token_user(), path[1], self.read_json()))
            if len(path) == 3 and path[0] == "organizations" and path[2] == "events" and method == "GET":
                return self.send_json(200, self.service.list_organization_events(self.token_user(), path[1]))
            if path == ["events"] and method == "GET":
                with self.service.connect() as db:
                    rows = db.execute("SELECT id FROM events WHERE status='published' ORDER BY start_at").fetchall()
                return self.send_json(200, [self.service.event_details(row["id"]) for row in rows])
            if len(path) == 2 and path[0] == "events" and method == "GET":
                include = False
                if self.headers.get("Authorization", "").startswith("Bearer "):
                    try:
                        include = self.service.can_manage_event(self.token_user(), path[1])
                    except ApiError:
                        include = False
                return self.send_json(200, self.service.event_details(path[1], include_unpublished=include))
            if len(path) == 3 and path[0] == "events" and path[2] == "applications" and method == "POST":
                return self.send_json(201, self.service.apply(self.token_user(), path[1], self.read_json().get("answers", {})))
            if len(path) == 4 and path[0] == "events" and path[2] == "applications" and path[3] == "":
                raise ApiError(404, "not_found", "Route not found")
            if len(path) == 3 and path[0] == "events" and path[2] == "applications" and method == "GET":
                return self.send_json(200, self.service.list_applications(self.token_user(), path[1]))
            if len(path) == 3 and path[0] == "applications" and path[2] == "status" and method == "PUT":
                status = self.read_json().get("status")
                return self.send_json(200, self.service.resolve_application(self.token_user(), path[1], status))
            if len(path) == 3 and path[0] == "events" and path[2] == "status" and method == "PUT":
                payload = self.read_json()
                return self.send_json(200, self.service.set_event_status(
                    self.token_user(), path[1], payload.get("status"), payload.get("note", ""),
                ))
            if len(path) == 2 and path[0] == "events" and method == "PUT":
                return self.send_json(200, self.service.update_event(self.token_user(), path[1], self.read_json()))
            if len(path) == 2 and path[0] == "events" and method == "DELETE":
                return self.send_json(200, self.service.delete_event(self.token_user(), path[1]))
            if (path == ["my", "tickets"] or path == ["my", "applications"]) and method == "GET":
                return self.send_json(200, self.service.list_my_applications(self.token_user()))
            if path == ["my", "favorites"] and method == "GET":
                return self.send_json(200, self.service.list_my_favorites(self.token_user()))
            if len(path) == 3 and path[0] == "events" and path[2] == "favorite" and method == "POST":
                return self.send_json(200, self.service.toggle_favorite(self.token_user(), path[1]))
            if len(path) == 3 and path[0] == "events" and path[2] == "reminders" and method == "POST":
                offset = self.read_json().get("offset", "1h")
                return self.send_json(200, self.service.set_reminder(self.token_user(), path[1], offset))
            if len(path) == 3 and path[0] == "events" and path[2] == "reminders" and method == "DELETE":
                return self.send_json(200, self.service.clear_reminder(self.token_user(), path[1]))
            if len(path) == 3 and path[0] == "events" and path[2] == "reminders" and method == "GET":
                return self.send_json(200, self.service.my_reminder(self.token_user(), path[1]))
            if len(path) == 3 and path[0] == "events" and path[2] == "attendees" and method == "GET":
                return self.send_json(200, self.service.event_attendees(self.token_user(), path[1]))
            if len(path) == 3 and path[0] == "events" and path[2] == "check-in" and method == "POST":
                ticket_id = self.read_json().get("ticket_id")
                return self.send_json(200, self.service.check_in(self.token_user(), path[1], ticket_id))
            if len(path) == 3 and path[0] == "events" and path[2] == "media" and method == "POST":
                user = self.token_user()
                body = self.read_body()
                content_type = self.headers.get("Content-Type", "application/octet-stream").split(";", 1)[0]
                if self.headers.get("X-Filename") and "name" not in query:
                    query["name"] = [self.headers["X-Filename"]]
                return self.send_json(201, self.service.upload(user, path[1], body, content_type, query))
            if path == ["inbox"] and method == "GET":
                user = self.token_user()
                with self.service.connect() as db:
                    rows = db.execute("SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 100", (user["id"],)).fetchall()
                return self.send_json(200, [dict(row, payload=json.loads(row["payload_json"])) for row in rows])
            if len(path) == 3 and path[0] == "inbox" and path[2] == "read" and method == "POST":
                user = self.token_user()
                with self.service.connect() as db:
                    cursor = db.execute("UPDATE notifications SET read_at=? WHERE id=? AND user_id=? AND read_at IS NULL", (now(), path[1], user["id"]))
                return self.send_json(200, {"updated": cursor.rowcount == 1})
            if path == ["auth", "sign-out"] and method == "POST":
                user = self.token_user()
                token = self.headers["Authorization"][7:].strip()
                with self.service.connect() as db:
                    db.execute("DELETE FROM sessions WHERE token_hash=? AND user_id=?", (hashlib.sha256(token.encode()).hexdigest(), user["id"]))
                return self.send_json(200, {"signed_out": True})
            if len(path) == 2 and path[0] == "admin" and path[1] == "invite-keys" and method == "GET":
                return self.send_json(200, self.service.list_invite_keys(self.token_user()))
            if len(path) == 2 and path[0] == "admin" and path[1] == "invite-keys" and method == "POST":
                return self.send_json(201, self.service.mint_invite_key(self.token_user()))
            if len(path) == 2 and path[0] == "admin" and path[1] == "moderation" and method == "GET":
                return self.send_json(200, self.service.moderation_queue(self.token_user()))
            if len(path) == 2 and path[0] == "admin" and path[1] == "counters" and method == "GET":
                return self.send_json(200, self.service.admin_counters(self.token_user()))
            raise ApiError(404, "not_found", "Route not found")
        except ApiError as error:
            self.send_json(error.status, {"error": {"code": error.code, "message": error.message}})
        except (BrokenPipeError, ConnectionResetError):
            return
        except Exception:
            self.send_json(500, {"error": {"code": "internal_error", "message": "An internal server error occurred"}})


def main():
    parser = argparse.ArgumentParser(description="CampusLife stdlib HTTP API")
    parser.add_argument("--host", default=os.environ.get("CAMPUSLIFE_HOST", "0.0.0.0"))
    parser.add_argument("--port", type=int, default=int(os.environ.get("CAMPUSLIFE_PORT", "8080")))
    parser.add_argument("--data-dir", default=os.environ.get("CAMPUSLIFE_DATA_DIR", "./data"))
    parser.add_argument("--cors-origin", default=os.environ.get("CAMPUSLIFE_CORS_ORIGIN", "*"))
    args = parser.parse_args()
    service = CampusLifeService(args.data_dir)
    handler = type("ConfiguredHandler", (Handler,), {"service": service, "cors_origin": args.cors_origin})
    server = ThreadingHTTPServer((args.host, args.port), handler)
    print(f"CampusLife API listening on http://{args.host}:{args.port}; data: {service.data_dir}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
