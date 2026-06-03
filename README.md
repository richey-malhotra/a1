# boutique_ado_v1

A Django shopping site. Runs locally on SQLite and deploys to Heroku.

## Requirements

Use **Python 3.9 or 3.10**. This project is built on Django 3.2, which does not
support Python 3.11 or newer. Check your version first:

```bash
python --version
```

If it reports 3.11 or higher, install Python 3.10 from <https://www.python.org/downloads/>
before continuing (on Windows you can then create the venv with `py -3.10 -m venv .venv`).

## Running locally (Windows)

Open PowerShell and run:

```powershell
git clone https://github.com/richey-malhotra/a1.git
cd a1
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
copy env.py.example env.py
```

Generate a secret key:

```powershell
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

Open `env.py` and paste that value into `SECRET_KEY`. Then set up the database and run:

```powershell
python manage.py migrate
python manage.py loaddata categories products
python manage.py createsuperuser
python manage.py runserver
```

Open <http://127.0.0.1:8000/> - the product grid is at `/products/`.

If PowerShell blocks `.venv\Scripts\activate` with a "running scripts is disabled"
error, run this once and try again:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Or use Command Prompt instead, where `.venv\Scripts\activate.bat` always works.

## Running locally (macOS / Linux)

```bash
git clone https://github.com/richey-malhotra/a1.git
cd a1
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp env.py.example env.py
```

Generate a secret key, paste it into `SECRET_KEY` in `env.py`, then:

```bash
python -c "import secrets; print(secrets.token_urlsafe(50))"
python manage.py migrate
python manage.py loaddata categories products
python manage.py createsuperuser
python manage.py runserver
```

## Notes

- `createsuperuser` is optional - it just lets you log into `/admin`.
- Do not skip `env.py`. It sets `DEVELOPMENT`, which turns on `DEBUG` for local work.
  Without it the site runs in production mode and the styling will not load under
  `runserver`.
- The product images live in the repo under `media/`, so they appear straight away.
  Only the product data is loaded by `loaddata`.

## Deploying to Heroku

```bash
heroku config:set SECRET_KEY="$(python -c 'import secrets; print(secrets.token_urlsafe(50))')" --app <appname>
git push heroku main
heroku run python manage.py migrate --app <appname>
heroku run python manage.py loaddata categories products --app <appname>
```

`DEBUG` is on locally (set by `env.py`) and off on Heroku. Static files are served by
WhiteNoise and `collectstatic` runs during the build, so no extra setup is needed.
