# Nanos World Server - Docker Setup

This repository contains Docker configurations to run a [Nanos World](https://nanos.world/) dedicated server in a containerized environment.

## 📋 Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- At least 2GB of free disk space

## 🚀 Quick Start

### Using Docker Compose (Recommended)

1. **Clone or download this repository**

2. **Start the server:**
   ```bash
   docker-compose up -d
   ```

3. **View logs:**
   ```bash
   docker-compose logs -f
   ```

4. **Stop the server:**
   ```bash
   docker-compose down
   ```

### Using Docker CLI

1. **Build the image:**
   ```bash
   docker build -t nanos-world-server .
   ```

2. **Run the container:**
   ```bash
   docker run -d \
     --name nanos-world-server \
     -p 7777:7777/udp \
     -p 7777:7777/tcp \
     -v $(pwd):/app \
     nanos-world-server
   ```

## 🔧 Configuration

### Server Parameters

You can pass server parameters by modifying the `command` section in `docker-compose.yml`:

```yaml
command: ["--port", "7777", "--map", "MyMap", "--max-players", "32"]
```

Common parameters:
- `--port <number>` - Server port (default: 7777)
- `--map <name>` - Map to load
- `--max-players <number>` - Maximum number of players
- `--password <password>` - Server password
- `--announce` - Announce server to the master server list
- `--log` - Enable logging

For a full list of parameters, refer to the [Nanos World Server Documentation](https://docs.nanos.world/docs/core-concepts/server-manual/server-installation).

### Port Configuration

The default configuration exposes port 7777 for both UDP and TCP. To use a different port:

1. Update the `ports` section in `docker-compose.yml`:
   ```yaml
   ports:
     - "8888:8888/udp"
     - "8888:8888/tcp"
   ```

2. Update the server command to use the same port:
   ```yaml
   command: ["--port", "8888"]
   ```

### Persistent Data

The docker-compose configuration mounts the current directory to `/app` inside the container. This allows you to:

- Persist server configuration files
- Add custom packages and assets
- Access server logs
- Maintain saved data between container restarts

To use a different directory for persistent data:

```yaml
volumes:
  - ./server-data:/app
```

## 📦 Dockerfile Variants

### Main Dockerfile (Multi-stage Build)

The main `Dockerfile` uses a multi-stage build process:

1. **Builder Stage**: Uses the official SteamCMD Alpine image to download the Nanos World server files from Steam (App ID: 1936830)
2. **Runtime Stage**: Creates a minimal Ubuntu 24.04 image with only the necessary runtime libraries

**Advantages:**
- Always downloads the latest server version
- Smaller final image size
- No need to manually download server files
- Uses the bleeding-edge beta branch

**Build command:**
```bash
docker build -t nanos-world-server .
```

### Alternative Dockerfile (Ubuntu)

Located at `alternatives/Dockerfile.ubuntu`, this variant requires you to manually copy the server files into the build context.

**When to use:**
- You want to use a specific server version
- You prefer manual control over server files
- You have limited bandwidth or want to avoid downloading during build

**Usage:**
1. Download the Nanos World server files
2. Place them in the same directory as the Dockerfile
3. Build:
   ```bash
   docker build -f alternatives/Dockerfile.ubuntu -t nanos-world-server .
   ```

## 🔄 Updating the Server

### With Docker Compose

1. Pull the latest image:
   ```bash
   docker-compose pull
   ```

2. Recreate the container:
   ```bash
   docker-compose up -d
   ```

### With Docker CLI

1. Rebuild the image:
   ```bash
   docker build -t nanos-world-server .
   ```

2. Stop and remove the old container:
   ```bash
   docker stop nanos-world-server
   docker rm nanos-world-server
   ```

3. Start a new container with the updated image

## 🐛 Troubleshooting

### Server won't start

1. Check the logs:
   ```bash
   docker-compose logs
   ```

2. Verify the server files are present:
   ```bash
   docker-compose exec nanos-world-server ls -la /app
   ```

### Port already in use

If port 7777 is already in use, change the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "8888:7777/udp"
  - "8888:7777/tcp"
```

### Permission issues

If you encounter permission issues with mounted volumes:

```bash
sudo chown -R $(id -u):$(id -g) .
```

### Container keeps restarting

Check if the server is crashing:

```bash
docker-compose logs --tail=100
```

Common causes:
- Missing or corrupted server files
- Invalid server parameters
- Insufficient system resources

## 📚 Additional Resources

- [Nanos World Official Website](https://nanos.world/)
- [Nanos World Documentation](https://docs.nanos.world/)
- [Nanos World Server Manual](https://docs.nanos.world/docs/core-concepts/server-manual/server-installation)
- [Nanos World Discord](https://discord.nanos.world/)

## 📝 License

This Docker configuration is provided as-is. Nanos World and its server software are subject to their own licenses.

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this Docker setup!

