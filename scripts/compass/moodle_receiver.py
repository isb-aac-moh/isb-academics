#!/usr/bin/env python3
"""Saves course files sent by moodle_pull.js, which runs inside a browser already signed in to Moodle.

No cookie or password ever reaches this script. It listens only on this Mac, accepts requests only
from elearn.isb.edu with the token below, and writes only under moodle/files/<COURSE>/.

  python3 scripts/compass/moodle_receiver.py <token>
"""
import http.server, json, os, re, sys, time, urllib.parse

OUT = os.path.expanduser("~/Downloads/compass-build/moodle/files")
HERE, PORT, ORIGIN, MAX_BYTES = os.path.dirname(os.path.abspath(__file__)), 8765, "https://elearn.isb.edu", 300 * 1024 * 1024
TOKEN = sys.argv[1]

def safe(name): return re.sub(r"[^\w.\- ]+", "_", name).strip(". ")[:150] or "file"

class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a): pass  # File names stay out of logs.
    def reply(self, code, body=b"{}", kind="application/json"):
        self.send_response(code)
        self.send_header("Access-Control-Allow-Origin", ORIGIN); self.send_header("Access-Control-Allow-Private-Network", "true")
        self.send_header("Access-Control-Allow-Headers", "content-type"); self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Content-Type", kind); self.send_header("Content-Length", str(len(body))); self.end_headers(); self.wfile.write(body)
    def do_OPTIONS(self): self.reply(204 if self.headers.get("Origin") == ORIGIN else 403, b"")
    def allowed(self):
        self.url = urllib.parse.urlsplit(self.path); self.q = {k: v[0] for k, v in urllib.parse.parse_qs(self.url.query).items()}
        return self.headers.get("Origin") == ORIGIN and self.q.get("token") == TOKEN and re.fullmatch(r"[A-Z0-9]+", self.q.get("course", "X"))
    def folder(self): path = os.path.join(OUT, self.q["course"]); os.makedirs(path, exist_ok=True); return path
    def do_GET(self):
        if not self.allowed(): return self.reply(403)
        if self.url.path == "/wait": time.sleep(1); return self.reply(200)
        if self.url.path == "/pull.js": return self.reply(200, open(os.path.join(HERE, "moodle_pull.js"), "rb").read(), "text/javascript")
        if self.url.path == "/manifest":
            path = os.path.join(self.folder(), "manifest.json")
            return self.reply(200, open(path, "rb").read() if os.path.exists(path) else b"[]")
        if self.url.path == "/exists": return self.reply(200, json.dumps(os.path.exists(os.path.join(self.folder(), safe(self.q["name"])))).encode())
        self.reply(404)
    def do_POST(self):
        size = int(self.headers.get("Content-Length", 0))
        if not self.allowed() or size > MAX_BYTES: return self.reply(403)
        name = {"/file": safe(self.q.get("name", "")), "/manifest": "manifest.json"}.get(self.url.path)
        if not name: return self.reply(404)
        path = os.path.join(self.folder(), name); left = size
        with open(path + ".part", "wb") as f:
            while left > 0:
                chunk = self.rfile.read(min(left, 1 << 20))
                if not chunk: return self.reply(400)
                f.write(chunk); left -= len(chunk)
        os.replace(path + ".part", path)
        self.reply(200, json.dumps({"path": name, "bytes": size}).encode())

os.makedirs(OUT, exist_ok=True)
print(f"Listening on 127.0.0.1:{PORT}", flush=True)
http.server.ThreadingHTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
