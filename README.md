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

Authentication uses a **Snowflake RSA key pair**. Register the public key on the Snowflake user (`ALTER USER … SET RSA_PUBLIC_KEY='…'`), then point dbt at the private key file (PKCS#8 `.p8`).

Export Snowflake env vars (example):

```bash
export SNOWFLAKE_ACCOUNT="xy12345.us-east-1"
export SNOWFLAKE_USER="your_user"
export SNOWFLAKE_PRIVATE_KEY_PATH="/absolute/path/to/rsa_key.p8"
export SNOWFLAKE_ROLE="YOUR_ROLE"   # must exist and be granted to your user
export SNOWFLAKE_DATABASE="ANALYTICS"
export SNOWFLAKE_WAREHOUSE="TRANSFORMING_WH"
export SNOWFLAKE_SCHEMA="DBT_DEV"
```

Use an **absolute** path for `SNOWFLAKE_PRIVATE_KEY_PATH` (tilde `~` is not reliably expanded). If the `.p8` is passphrase-protected, add `private_key_passphrase: "{{ env_var('SNOWFLAKE_PRIVATE_KEY_PASSPHRASE') }}"` under the same `dev` output in `profiles.yml` and export that passphrase in your environment. See the [dbt Snowflake connection profile](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) documentation for key-pair options.

**GitHub Actions:** store the **PEM contents** of the private key in the repository secret `SNOWFLAKE_PRIVATE_KEY`. The workflow writes it to `/tmp/rsa_key.p8` and sets `SNOWFLAKE_PRIVATE_KEY_PATH` for dbt.

Validate and run:

```bash
dbt debug
dbt run
dbt test
```