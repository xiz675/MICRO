"""Load secrets (OpenAI key, database passwords) from a `.env` file at the repo root.

`.env` is git-ignored; copy `.env.example` to `.env` and fill it in. Variables already set in the
environment take precedence. No third-party dependency (python-dotenv is used if installed).
"""
import os

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def load_env(path: str = None) -> dict:
    path = path or os.path.join(REPO_ROOT, ".env")
    loaded = {}
    if not os.path.exists(path):
        return loaded
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            if line.startswith("export "):
                line = line[len("export "):]
            key, value = line.split("=", 1)
            key, value = key.strip(), value.strip()
            if len(value) >= 2 and value[0] == value[-1] and value[0] in "'\"":
                value = value[1:-1]
            if key and key not in os.environ:
                os.environ[key] = value
                loaded[key] = True
    return loaded
