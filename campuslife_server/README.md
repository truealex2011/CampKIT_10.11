# CampusLife HTTP API

Python 3.10+; standard library only. From the repository root:

```text
python -m campuslife_server.server --host 0.0.0.0 --port 8080 --data-dir ./campuslife-data
python -m unittest campuslife_server.test_server -v
```

`CAMPUSLIFE_HOST`, `CAMPUSLIFE_PORT`, `CAMPUSLIFE_DATA_DIR`, and `CAMPUSLIFE_CORS_ORIGIN` configure the server. Media and SQLite data persist in the data directory. Set an explicit CORS origin for deployment; `*` is the default for development. Use TLS termination and a trusted reverse proxy when exposing this service beyond a private network.

All API requests and responses use JSON except media uploads and downloads. Authenticated routes require `Authorization: Bearer <token>`. Registration and sign-in return `{token, user}`. Passwords use PBKDF2-HMAC-SHA256; session tokens are random and stored hashed.

- `GET /health`
- `POST /auth/register` `{name,email,password,phone?}`; `POST /auth/sign-in` `{email,password}`; `GET /auth/me`; `POST /auth/sign-out`
- `POST /organizations` `{name,city,type?,phone?,email?}` creates an organization owned by the signed-in user
- `POST /organizations/{id}/membership`; `GET /organizations/{id}/members/pending`; `POST /organizations/{id}/members/{user_id}/approve` `{role?}` or `/reject`
- `POST /organizations/{id}/events` `{title,category,start_at,place,description?,capacity?,status?,fields?}`; `GET /events`; `GET /events/{id}`
- Event `fields` have `{id?,label,type?,required?,options?}`. IDs are returned in event details and used as answer object keys.
- `POST /events/{id}/applications` `{answers:{field_id:value}}`; organizer-only `GET /events/{id}/applications`; organizer-only `PUT /applications/{id}/status` `{status:"approved"|"rejected"}`
- Organizer-only `POST /events/{id}/media?name=filename&kind=photo|video`, with raw file bytes and the file `Content-Type`; `GET /media/{media_id}` serves persisted content
- `GET /inbox` polls the current user's notifications; `POST /inbox/{notification_id}/read` marks one read

Errors have `{error:{code,message}}` and an appropriate HTTP status. The server accepts uploads up to 32 MiB. Serve it behind HTTPS for real deployments; the built-in HTTP server is intended for trusted networks or TLS-terminating proxies.
