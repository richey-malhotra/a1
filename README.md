# boutique_ado_v1

A Django shopping site. Runs locally on SQLite and deploys to Heroku.

## Get your own copy (start here)

This repo is a **template**, so you create your own independent copy in one click —
no fork link, no shared history.

1. On the GitHub repo page, click the green **Use this template** button →
   **Create a new repository**.
2. Give it a name, choose your own account as the owner, and click
   **Create repository**.

That new repository is yours. Everything below — Codespaces, local setup, Heroku —
runs from **your** copy.

## Quickest start: GitHub Codespaces (recommended)

No Python install, no version juggling, no permissions hassle — everything
runs in a pre-configured cloud container. Works the same on any computer.

1. On the GitHub repo page, click **Code → Codespaces → Create codespace on main**.
2. Wait ~1 minute for it to build. It automatically installs dependencies,
   creates `env.py` with a fresh secret key, and runs the database migrations.
3. In the terminal, run:

   ```bash
   python manage.py runserver
   ```

4. When VS Code pops up "Open in Browser" for port 8000, click it.

That's it — the site is running. (Free monthly Codespaces hours are included
with every GitHub account, and **GitHub Education** gives students more.)

**If the product images show as blank spaces:** the forwarded port is set to
*Private*, which blocks the image requests. In the **Ports** panel, right-click
port **8000** → *Port Visibility* → **Public**, then reload the page.

---

The rest of this README covers running the project **locally on Windows**, if
you prefer that over Codespaces.

## Requirements

This project is built on Django 3.2, which **only runs on Python 3.9 or 3.10**.
It will **not** work on Python 3.11, 3.12 or newer.

Check what you have:

```powershell
python --version
```

If that shows 3.11 or higher (for example 3.12), install **Python 3.10** before
continuing:

1. Download the Python 3.10 Windows installer from
   <https://www.python.org/downloads/release/python-31011/> (scroll to
   "Windows installer (64-bit)").
2. Run it. You do **not** need to uninstall your existing Python - both versions
   can sit side by side.

You do not type `python3.10` anywhere. Windows installs a launcher called `py`, and you
pick the version with `py -3.10`. The steps below use `py -3.10` to build the virtual
environment, so everything after that automatically runs on Python 3.10.

## Running locally

Open PowerShell and run:

```powershell
git clone https://github.com/richey-malhotra/a1.git
cd a1
py -3.10 -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
copy env.py.example env.py
```

Once the environment is activated, `python --version` should report **3.10.x**. That
confirms the virtual environment is using the right Python (even if your system default
is 3.12). If it still shows 3.12, close the terminal, delete the `.venv` folder, and
redo the `py -3.10 -m venv .venv` step.

Generate a secret key:

```powershell
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

Open `env.py` (for example with `notepad env.py`) and paste that value into
`SECRET_KEY`, then save. Now set up the database and run the site:

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

## Notes

- `createsuperuser` is optional - it just lets you log into `/admin`.
- Do not skip `env.py`. It sets `DEVELOPMENT`, which turns on `DEBUG` for local work.
  Without it the site runs in production mode and the styling will not load under
  `runserver`.
- The product images live in the repo under `media/`, so they appear straight away.
  Only the product data is loaded by `loaddata`.

## Deploying to Heroku

You need a free [Heroku](https://www.heroku.com/) account and the
[Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed, then run
`heroku login` once.

### Step 1: Create your app and pick its name

Everywhere below you see `<appname>`, replace it with **the name of YOUR app** - the
name you choose right now in this step. It is not a fixed value; you invent it.

```powershell
heroku create your-app-name-here
```

Rules for the name:

- It must be **unique across all of Heroku**, because it becomes your website address:
  `https://your-app-name-here.herokuapp.com`. If the name is already taken, Heroku will
  tell you - just try another.
- Use **lowercase letters, numbers and dashes only**, and start with a letter.
  For example `boutique-ado-jane` is fine; `Boutique_Ado!` is not.

If you would rather let Heroku invent a name for you, just run `heroku create` with no
name. It will print the name it chose - use that as your `<appname>` from then on.

Running `heroku create` inside this repo also adds a git remote called `heroku`, which
is what `git push heroku main` below pushes to.

### Step 2: Set the secret key

Generate a key and set it on your app (replace `<appname>` with the name from Step 1):

```powershell
python -c "import secrets; print(secrets.token_urlsafe(50))"
heroku config:set SECRET_KEY="paste-the-key-here" --app <appname>
```

### Step 3: Deploy and set up the database

```powershell
git push heroku main
heroku run python manage.py migrate --app <appname>
heroku run python manage.py loaddata categories products --app <appname>
```

### Step 4: Open it

```powershell
heroku open --app <appname>
```

Or just visit `https://<appname>.herokuapp.com` in your browser.

`DEBUG` is on locally (set by `env.py`) and off on Heroku. Static files are served by
WhiteNoise and `collectstatic` runs during the build, so no extra setup is needed.
