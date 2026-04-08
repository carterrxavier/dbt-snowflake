# dbt-snowflake

Minimal dbt Core project wired for Snowflake.

## Quick start

Create a virtualenv and install deps:

```bash
python3 -m venv venv   # or: python3 -m venv .venv
source venv/bin/activate
pip install -r requirements.txt
```

The `python-dotenv[cli]` extra installs the `dotenv` command in this venv. With the venv activated, load `.env` and run dbt in one shot:

```bash
dotenv run -- dbt debug
dotenv run -- dbt run
```

If `dotenv` is not found, confirm the shell prompt shows the venv (or run `./venv/bin/dotenv` with the path you used).

Create your dbt profile (do **not** commit credentials).

**Option A — standard location** (`~/.dbt`):

```bash
mkdir -p ~/.dbt
cp profiles.yml.example ~/.dbt/profiles.yml
```

**Option B — next to the project** (if you use `--profiles-dir .` or `DBT_PROFILES_DIR=.`): copy the example into `profiles.yml` in this folder. An empty `profiles.yml` will make dbt fail with “profiles.yml … is empty”.

Export Snowflake env vars (example):

```bash
export SNOWFLAKE_ACCOUNT="xy12345.us-east-1"
export SNOWFLAKE_USER="your_user"
export SNOWFLAKE_PASSWORD="your_password"
export SNOWFLAKE_ROLE="YOUR_ROLE"   # must exist and be granted to your user
export SNOWFLAKE_DATABASE="ANALYTICS"
export SNOWFLAKE_WAREHOUSE="TRANSFORMING_WH"
export SNOWFLAKE_SCHEMA="DBT_DEV"
```

Validate and run:

```bash
dbt debug
dbt run
dbt test
```