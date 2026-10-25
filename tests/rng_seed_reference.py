"""Referência independente T3; stdout é a fixture, nunca chama Godot."""
import hashlib
import json

MAX = (1 << 63) - 1
CASES = [
    (0, "arena", 1, 1, "combat"),
    (1314, "arena", 1, 1, "combat"),
    (1314, "arena", 1, 1, "loot"),
    (1314, "arena", 1, 1, "world"),
    (MAX, "act1_fields", 1, 1, "combat"),
    (1, "zone:a,1", 2, 3, "world"),
    (123456789, "act1_fields", MAX, MAX, "loot"),
]


def derive(fields):
    payload = b""
    for field in fields:
        raw = str(field).encode("utf-8")
        payload += str(len(raw)).encode("ascii") + b":" + raw + b","
    digest = hashlib.sha256(payload).digest()
    return int.from_bytes(digest[:8], "big") & MAX


if __name__ == "__main__":
    rows = [[str(v) for v in row] + [str(derive(row))] for row in CASES]
    print("[\n" + ",\n".join("  " + json.dumps(row) for row in rows) + "\n]")
