# Set up LM Studio

- Download LM Studio
- In Model Search tab, download qwen/qwen3.6-27b (MLX 8 bit)

- In Developer tab > Local Server, click Load Model
- Enable "Manually choose model load parameters, select a model, set context size to max
- Check "Remember settings for ..." and click "Load Model"

- In Developer tab > Local Server, click Server Settings
- Enable Require Authentication, click Manage Tokens
- Click Create new token, keep default settings, click Create token
- Save the token for later use

# Set up Hermes Agent in Docker container

- Install Docker Desktop
- Copy .env.template to .env
- Input the values in the .env file by following the guideline in the file
- Run `./start.sh`

You can set MacOS to auto-start it on startup. Google for instruction.

# Run Hermes Setup

- Run: `docker compose exec hermes-agent bash`
- Run: `hermes setup`

# Google Workspace (gws) credentials

The container has `gws` installed but **cannot** log in itself: it has no
browser for the OAuth flow, and it can't read the host's macOS-keychain-
encrypted credentials (a Linux container has no keyring). So the host is the
source of truth and you sync its decrypted credentials into the shared volume.

The container reads its gws config from
`/opt/data/home/.config/gws` (set via `GOOGLE_WORKSPACE_CLI_CONFIG_DIR` in
`docker-compose.yml`), which is the host path `./hermes_data/home/.config/gws`.

To sync (run on the **host**):

```bash
gws auth login     # one-time, or whenever the token has expired
./gws-sync.sh      # copies credentials.json + client_secret.json into the volume
```

`gws-sync.sh` needs no container restart — gws re-reads `credentials.json` on
each command, so the next gws call in the container uses the fresh token.

**Why it "always expired" before:** the container's `credentials.json` held a
stale/revoked OAuth `client_id` and its `client_secret.json` pointed at a
different GCP project, so the token refresh failed. `gws-sync.sh` copies the
host's *current* files, fixing both.

**The 7-day expiry:** while your OAuth app's publishing status is **Testing**
(Cloud Console → APIs & Services → OAuth consent screen), Google expires every
refresh token after 7 days, no matter how often you use it. Re-run `gws-sync.sh`
weekly, or set the consent screen to **In production** (unverified is fine for
personal use) so refresh tokens last ~6 months instead.

# Hermes Dashboard (Web UI)

- The dashboard auto-starts with the container (supervised by s6 via the
  image's built-in `/init` entrypoint) and the gateway is crash-restarted
  automatically — do not override the entrypoint (see Dockerfile note)
- Open `http://127.0.0.1:9119` in a host browser; log in with the basic auth
  credentials from `.env` (username / scrypt password hash)
- The port is published to `127.0.0.1` only. To access from another machine,
  use an SSH tunnel: `ssh -L 9119:localhost:9119 <host>`
- To restart the gateway: `docker restart hermes_agent_sandbox`


