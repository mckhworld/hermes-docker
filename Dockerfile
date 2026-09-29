FROM nousresearch/hermes-agent:main

# Install Google Cloud CLI
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | tee /usr/share/keyrings/cloud.google.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update -y \
    && apt-get install -y google-cloud-cli

# Install global npm packages once at build time
# Prefix /usr/local is the default for root user in this image
RUN npm install -g @googleworkspace/cli

# NOTE: Do NOT override the image ENTRYPOINT. The base image's /init
# (s6-overlay) supervises the gateway and the dashboard service
# (HERMES_DASHBOARD=1). Overriding it with a custom init script skips the
# s6 supervision tree, so the dashboard never auto-starts and the gateway
# loses crash-restart.
