FROM steamcmd/steamcmd:alpine AS builder

# Create directory for the server
RUN mkdir -p /nanos-world-server

RUN steamcmd \
    +force_install_dir /nanos-world-server \
    +login anonymous \
    +app_update 1936830 validate \
    -beta bleeding-edge \
    +quit

# Verify files were downloaded
RUN ls -la /nanos-world-server/

# Final stage
FROM ubuntu:24.04

# Install required runtime libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libc6 \
    libstdc++6 \
    libgcc-s1 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Copy server files from builder
COPY --from=builder /nanos-world-server/ /app/

# Make executables executable
RUN chmod +x /app/NanosWorldServer.sh /app/NanosWorldServer /app/crashpad_handler 2>/dev/null || true

WORKDIR /app

# Set library path
ENV LD_LIBRARY_PATH=/app:/app/linux64

ENTRYPOINT ["/app/NanosWorldServer.sh"]
CMD []
