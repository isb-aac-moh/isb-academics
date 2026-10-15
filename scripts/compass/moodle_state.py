#!/usr/bin/env python3
"""Fetch the course structure (sessions, resources, links) for a few Moodle courses.

Read-only. Reuses the browser request you saved as a cURL file; the cookie is read from that
file and never printed. Only the method in ALLOWED is ever sent, one request per course,
1 second apart. Output: one JSON file per course, with no credentials in it.

  python3 scripts/compass/moodle_state.py --dry-run     # parse and plan, no network
  python3 scripts/compass/moodle_state.py               # fetch all six courses
"""
import argparse, json, os, re, shlex, sys, time, urllib.request, urllib.error

CURL = os.path.expanduser("~/Downloads/compass-build/moodle/curl.txt")
OUT = os.path.expanduser("~/Downloads/compass-build/moodle")
ALLOWED = {"core_courseformat_get_state"}          # read-only; nothing else can be sent
KEEP = {"content-type", "x-requested-with", "user-agent", "accept", "origin", "referer"}
COURSES = {"OPMG": 10846, "STRG": 10578, "MKTG": 10845, "SWPM": 10955, "FRNT": 10581, "BANM": 10849}

def parse(path):
    t = open(path).read().replace("\\\n", " ")
    for a, b in (("“", '"'), ("”", '"'), ("‘", "'"), ("’", "'")):
        t = t.replace(a, b)
    a = shlex.split(t)
    url = next(x for x in a if x.startswith("http"))
    headers, cookie, body, i = {}, "", None, 0
    while i < len(a):
        x = a[i]
        if x in ("-H", "--header"):
            k, v = a[i + 1].split(":", 1)
            if k.strip().lower() in KEEP: headers[k.strip()] = v.strip()
            i += 1
        elif x in ("-b", "--cookie"): cookie = a[i + 1]; i += 1
        elif x in ("--data-raw", "--data", "-d", "--data-binary"): body = a[i + 1]; i += 1
        i += 1
    if not cookie:
        m = re.search(r"cookie:\s*([^'\"]+)", t, re.I); cookie = m.group(1) if m else ""
    if not body or "MoodleSession" not in cookie:
        sys.exit("cURL file is missing the request body or the MoodleSession cookie.")
    return url, headers, cookie, json.loads(body)

def redact(s): return re.sub(r"(sesskey=)[^&\s]+", r"\1<redacted>", s)

def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--dry-run", action="store_true"); args = ap.parse_args()
    url, headers, cookie, body = parse(CURL)
    call = body[0]
    if call["methodname"] not in ALLOWED: sys.exit("Refusing: method not on the read-only allowlist.")
    print("Endpoint:", redact(url).split("?")[0], "| method:", call["methodname"], "| cookies:", len(cookie.split(";")))
    for code, cid in COURSES.items():
        payload = [{"index": 0, "methodname": call["methodname"], "args": {"courseid": cid}}]
        out = os.path.join(OUT, f"state_{code}.json")
        if args.dry_run: print(f"  would fetch {code} (id {cid}) -> {out}"); continue
        req = urllib.request.Request(url, data=json.dumps(payload).encode(), method="POST",
                                     headers={**headers, "Cookie": cookie})
        try:
            raw = urllib.request.urlopen(req, timeout=60).read().decode()
            data = json.loads(raw)
        except (urllib.error.HTTPError, urllib.error.URLError, ValueError) as e:
            print(f"  {code}: FAILED ({type(e).__name__}). Is the session still logged in?"); continue
        if isinstance(data, list) and data and data[0].get("error"):
            print(f"  {code}: server error: {str(data[0].get('exception',{}).get('message','unknown'))[:120]}"); continue
        json.dump(data, open(out, "w"), indent=1)
        st = data[0]["data"] if isinstance(data, list) and "data" in data[0] else {}
        st = json.loads(st) if isinstance(st, str) else st
        print(f"  {code}: saved {os.path.getsize(out)//1024} KB | sections {len(st.get('section',[]))} | items {len(st.get('cm',[]))}")
        time.sleep(1)

if __name__ == "__main__": main()
