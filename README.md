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
- Run ./start.sh

You can set MacOS to auto-start it on startup. Google for instruction.

