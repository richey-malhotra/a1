#!/usr/bin/env bash
# Runs once when the Codespace is created. Installs deps, generates a local
# env.py with a fresh secret key, and prepares the database — so the student
# can immediately run: python manage.py runserver
set -e

echo "==> Installing Python dependencies..."
python -m pip install --upgrade pip
pip install -r requirements.txt

if [ ! -f env.py ]; then
  echo "==> Creating env.py with a generated SECRET_KEY..."
  SECRET=$(python -c "import secrets; print(secrets.token_urlsafe(50))")
  cat > env.py <<EOF
import os

# Local dev settings (gitignored). DEVELOPMENT turns Django's DEBUG on.
os.environ.setdefault('DEVELOPMENT', '1')
os.environ.setdefault('SECRET_KEY', '$SECRET')
EOF
else
  echo "==> env.py already exists, leaving it as-is."
fi

echo "==> Applying database migrations..."
python manage.py migrate --noinput

echo ""
echo "============================================================"
echo " Setup complete. Start the site with:"
echo "     python manage.py runserver"
echo " Then open the forwarded port 8000 when VS Code prompts."
echo "============================================================"
