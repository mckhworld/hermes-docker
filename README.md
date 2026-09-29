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

# Hermes Dashboard (Web UI)

- The dashboard auto-starts with the container (supervised by s6 via the
  image's built-in `/init` entrypoint) and the gateway is crash-restarted
  automatically — do not override the entrypoint (see Dockerfile note)
- Open `http://127.0.0.1:9119` in a host browser; log in with the basic auth
  credentials from `.env` (username / scrypt password hash)
- The port is published to `127.0.0.1` only. To access from another machine,
  use an SSH tunnel: `ssh -L 9119:localhost:9119 <host>`
- To restart the gateway: `docker restart hermes_agent_sandbox`


