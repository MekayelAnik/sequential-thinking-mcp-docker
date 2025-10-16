# Sequential Thinking MCP Server
### Multi-Architecture Docker Image for Distributed Deployment

<div align="left">

<img alt="sequential-thinking-mcp" src="https://img.shields.io/badge/Sequential_Thinking-MCP-9B59B6?style=for-the-badge&logo=databricks&logoColor=white" width="450">

[![Docker Pulls](https://img.shields.io/docker/pulls/mekayelanik/sequential-thinking-mcp.svg?style=flat-square)](https://hub.docker.com/r/mekayelanik/sequential-thinking-mcp)
[![Docker Stars](https://img.shields.io/docker/stars/mekayelanik/sequential-thinking-mcp.svg?style=flat-square)](https://hub.docker.com/r/mekayelanik/sequential-thinking-mcp)
[![License](https://img.shields.io/badge/license-GPL-blue.svg?style=flat-square)](https://raw.githubusercontent.com/MekayelAnik/sequential-thinking-mcp-docker/refs/heads/main/LICENSE)

**[NPM Package](https://www.npmjs.com/package/@modelcontextprotocol/server-sequential-thinking)** • **[GitHub Repository](https://github.com/mekayelanik/sequential-thinking-mcp-docker)** • **[Docker Hub](https://hub.docker.com/r/mekayelanik/sequential-thinking-mcp)**

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [MCP Client Setup](#mcp-client-setup)
- [Available Tools](#available-tools)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)
- [Resources & Support](#resources--support)

---

## Overview

Sequential Thinking MCP Server empowers AI assistants with advanced reasoning capabilities through structured, step-by-step thinking processes. Enable your AI to break down complex problems, show its work, and arrive at better solutions through deliberate, transparent reasoning. Seamlessly integrates with VS Code, Cursor, Windsurf, Claude Desktop, PyCharm, and any MCP-compatible client.

### Key Features

✨ **Structured Reasoning** - Break complex problems into manageable steps  
🧠 **Transparent Thinking** - See the AI's step-by-step thought process  
🔐 **Secure & Configurable** - Optional API key authentication  
⚡ **High Performance** - Fast, efficient reasoning engine  
🌐 **CORS Ready** - Built-in CORS support for browser-based clients  
🚀 **Multiple Protocols** - HTTP, SSE, and WebSocket transport support  
🎯 **Zero Configuration** - Works out of the box with sensible defaults  
🔧 **Highly Customizable** - Fine-tune every aspect via environment variables  
📊 **Health Monitoring** - Built-in health check endpoint

### Supported Architectures

| Architecture | Status | Notes |
|:-------------|:------:|:------|
| **x86-64** | ✅ Stable | Intel/AMD processors |
| **ARM64** | ✅ Stable | Raspberry Pi, Apple Silicon |

### Available Tags

| Tag | Stability | Use Case |
|:----|:---------:|:---------|
| `stable` | ⭐⭐⭐ | **Production (recommended)** |
| `latest` | ⭐⭐⭐ | Latest stable features |
| `1.x.x` | ⭐⭐⭐ | Version pinning |

---

## Quick Start

### Prerequisites

- Docker Engine 23.0+
- Network access for MCP protocol communication

### Docker Compose (Recommended)

```yaml
services:
  sequential-thinking-mcp:
    image: mekayelanik/sequential-thinking-mcp:stable
    container_name: sequential-thinking-mcp
    restart: unless-stopped
    ports:
      - "8005:8005"
    environment:
      - PORT=8005
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Dhaka
      - PROTOCOL=SHTTP
      - CORS=*
      - API_KEY=your-secure-api-key-here
```

**Deploy:**

```bash
docker compose up -d
docker compose logs -f sequential-thinking-mcp
```

### Docker CLI

```bash
docker run -d \
  --name=sequential-thinking-mcp \
  --restart=unless-stopped \
  -p 8005:8005 \
  -e PORT=8005 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e PROTOCOL=SHTTP \
  -e CORS=* \
  -e API_KEY=your-secure-api-key-here \
  mekayelanik/sequential-thinking-mcp:stable
```

### Access Endpoints

| Protocol | Endpoint | Use Case |
|:---------|:---------|:---------|
| **HTTP** | `http://host-ip:8005/mcp` | **Recommended** |
| **SSE** | `http://host-ip:8005/sse` | Real-time streaming |
| **WebSocket** | `ws://host-ip:8005/message` | Bidirectional |
| **Health** | `http://host-ip:8005/healthz` | Monitoring |

> ⏱️ Server ready in 5-10 seconds after container start

---

## Configuration

### Environment Variables

#### Core Settings

| Variable | Default | Description |
|:---------|:-------:|:------------|
| `PORT` | `8005` | Server port (1-65535) |
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `Asia/Dhaka` | Container timezone |
| `PROTOCOL` | `SHTTP` | Transport protocol |
| `CORS` | _(none)_ | Cross-Origin configuration |
| `API_KEY` | _(none)_ | Authentication key for server access |

#### Advanced Settings

| Variable | Default | Description |
|:---------|:-------:|:------------|
| `DEBUG_MODE` | `false` | Enable debug mode (`true`, `false`, `1`, `yes`) |

### Protocol Configuration

```yaml
# HTTP/Streamable HTTP (Recommended)
environment:
  - PROTOCOL=SHTTP

# Server-Sent Events
environment:
  - PROTOCOL=SSE

# WebSocket
environment:
  - PROTOCOL=WS
```

### API Key Configuration

```yaml
# No authentication (development only)
environment:
  - API_KEY=

# Secure authentication (production)
environment:
  - API_KEY=sk_prod_a1b2c3d4e5f6g7h8i9j0

# Complex key with special characters
environment:
  - API_KEY=my-secure-key_2024@production:v1.0
```

> 🔐 **Security:** Always use a strong API key in production (5-128 characters, alphanumeric with safe symbols: `_:.@+= -`)

### CORS Configuration

```yaml
# Development - Allow all origins
environment:
  - CORS=*

# Production - Specific domains
environment:
  - CORS=https://example.com,https://app.example.com

# Mixed domains and IPs
environment:
  - CORS=https://example.com,192.168.1.100:3000

# Regex patterns
environment:
  - CORS=/^https:\/\/.*\.example\.com$/
```

> ⚠️ **Security:** Never use `CORS=*` in production environments

---

## MCP Client Setup

### Transport Compatibility

| Client | HTTP | SSE | WebSocket | Recommended |
|:-------|:----:|:---:|:---------:|:------------|
| **VS Code (Cline/Roo-Cline)** | ✅ | ✅ | ❌ | HTTP |
| **Claude Desktop** | ✅ | ✅ | ⚠️* | HTTP |
| **Cursor** | ✅ | ✅ | ⚠️* | HTTP |
| **Windsurf** | ✅ | ✅ | ⚠️* | HTTP |
| **PyCharm (AI Assistant)** | ✅ | ✅ | ❌ | HTTP |
| **IntelliJ IDEA** | ✅ | ✅ | ❌ | HTTP |

> ⚠️ *WebSocket support is experimental

### VS Code (Cline/Roo-Cline)

Add to `.vscode/settings.json`:

```json
{
  "mcp.servers": {
    "sequential-thinking": {
      "url": "http://host-ip:8005/mcp",
      "transport": "http",
      "autoApprove": ["sequential_thinking"]
    }
  }
}
```

**With API Key:**

```json
{
  "mcp.servers": {
    "sequential-thinking": {
      "url": "http://host-ip:8005/mcp",
      "transport": "http",
      "headers": {
        "Authorization": "Bearer your-api-key-here"
      },
      "autoApprove": ["sequential_thinking"]
    }
  }
}
```

### Claude Desktop

**Config Locations:**
- **Linux:** `~/.config/Claude/claude_desktop_config.json`
- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://localhost:8005/mcp"
    }
  }
}
```

**With API Key:**

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://localhost:8005/mcp",
      "headers": {
        "Authorization": "Bearer your-api-key-here"
      }
    }
  }
}
```

### Cursor

Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://host-ip:8005/mcp"
    }
  }
}
```

### Windsurf (Codeium)

Add to `.codeium/mcp_settings.json`:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://host-ip:8005/mcp"
    }
  }
}
```

### PyCharm (JetBrains IDEs)

**For PyCharm, IntelliJ IDEA, WebStorm, and other JetBrains IDEs:**

Add to `.idea/mcp_config.json`:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://localhost:8005/mcp"
    }
  }
}
```

**With API Key:**

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://localhost:8005/mcp",
      "headers": {
        "Authorization": "Bearer your-api-key-here"
      }
    }
  }
}
```

**Alternative: Environment Variables**

Add to Run/Debug Configuration:

```bash
MCP_SERVER_URL=http://localhost:8005/mcp
MCP_SERVER_TRANSPORT=http
MCP_API_KEY=your-api-key-here
```

**PyCharm AI Assistant Integration:**

1. Go to **Settings** → **Tools** → **AI Assistant**
2. Add **External MCP Server**
3. Configure URL: `http://localhost:8005/mcp`, Transport: `HTTP`

### Claude Code

Add to `~/.config/claude-code/mcp_config.json`:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://localhost:8005/mcp"
    }
  }
}
```

Or configure via CLI:

```bash
claude-code config mcp add sequential-thinking \
  --transport http \
  --url http://localhost:8005/mcp
```

### GitHub Copilot CLI

Add to `~/.github-copilot/mcp.json`:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "transport": "http",
      "url": "http://host-ip:8005/mcp"
    }
  }
}
```

Or use environment variable:

```bash
export GITHUB_COPILOT_MCP_SERVERS='{"sequential-thinking":{"transport":"http","url":"http://localhost:8005/mcp"}}'
```

---

## Available Tools

### 🧠 sequential_thinking

Enable structured, step-by-step reasoning for complex problem-solving.

**Parameters:**
- `thought_process` (string, required): The reasoning steps to execute

**Key Benefits:**
- **Improved Accuracy** - Reduces errors through systematic thinking
- **Transparency** - Shows complete reasoning process
- **Complex Problem Solving** - Breaks down difficult tasks
- **Better Decisions** - Evaluates options methodically

**Use Cases:**

**1. Mathematical Problem Solving**
- Multi-step calculations
- Word problems
- Equation solving
- Logic puzzles

**2. Code Analysis & Debugging**
- Tracing execution flow
- Identifying bug causes
- Analyzing algorithms
- Reviewing code logic

**3. Decision Making**
- Evaluating trade-offs
- Comparing alternatives
- Risk assessment
- Strategic planning

**4. Research & Analysis**
- Breaking down complex topics
- Connecting related concepts
- Synthesizing information
- Drawing conclusions

**Example Prompts:**

**Mathematical:**
- "Use sequential thinking to solve this word problem step by step"
- "Break down this calculation and show your work"

**Programming:**
- "Use sequential thinking to debug this code"
- "Walk through this algorithm step by step"

**Decision Making:**
- "Help me evaluate these options using sequential reasoning"
- "Break down the pros and cons of each approach"

**Analysis:**
- "Use sequential thinking to analyze this complex topic"
- "Show your reasoning process for this conclusion"

---

## Advanced Usage

### Production Configuration

```yaml
services:
  sequential-thinking-mcp:
    image: mekayelanik/sequential-thinking-mcp:stable
    container_name: sequential-thinking-mcp
    restart: unless-stopped
    ports:
      - "8005:8005"
    environment:
      - PORT=8005
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - PROTOCOL=SHTTP
      - API_KEY=${SEQUENTIAL_THINKING_API_KEY}
      - CORS=https://app.example.com,https://admin.example.com
    
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
    
    healthcheck:
      test: ["CMD", "nc", "-z", "localhost", "8005"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
```

### Using Environment Files

Create `.env` file:

```env
SEQUENTIAL_THINKING_PORT=8005
SEQUENTIAL_THINKING_API_KEY=your-secure-production-key
SEQUENTIAL_THINKING_PROTOCOL=SHTTP
SEQUENTIAL_THINKING_CORS=https://yourdomain.com
TZ=UTC
PUID=1000
PGID=1000
```

### Reverse Proxy Setup

#### Nginx

```nginx
upstream sequential_thinking_mcp {
    server localhost:8005;
}

server {
    listen 443 ssl http2;
    server_name thinking.example.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://sequential_thinking_mcp;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
    }
}
```

#### Traefik

```yaml
services:
  sequential-thinking-mcp:
    image: mekayelanik/sequential-thinking-mcp:stable
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.sequential-thinking.rule=Host(`thinking.example.com`)"
      - "traefik.http.routers.sequential-thinking.entrypoints=websecure"
      - "traefik.http.routers.sequential-thinking.tls.certresolver=letsencrypt"
      - "traefik.http.services.sequential-thinking.loadbalancer.server.port=8005"
```

### Docker Network Setup

```yaml
services:
  sequential-thinking-mcp:
    image: mekayelanik/sequential-thinking-mcp:stable
    networks:
      - mcp-network
    environment:
      - PORT=8005
      - API_KEY=${SEQUENTIAL_THINKING_API_KEY}
    
  ai-application:
    image: your-ai-app:latest
    networks:
      - mcp-network
    environment:
      - SEQUENTIAL_THINKING_URL=http://sequential-thinking-mcp:8005/mcp

networks:
  mcp-network:
    driver: bridge
```

### Multiple Instances with Load Balancing

```yaml
services:
  sequential-thinking-mcp-1:
    image: mekayelanik/sequential-thinking-mcp:stable
    environment:
      - PORT=8005
      - API_KEY=${SEQUENTIAL_THINKING_API_KEY}
  
  sequential-thinking-mcp-2:
    image: mekayelanik/sequential-thinking-mcp:stable
    environment:
      - PORT=8005
      - API_KEY=${SEQUENTIAL_THINKING_API_KEY}
  
  nginx-lb:
    image: nginx:alpine
    ports:
      - "8005:80"
    volumes:
      - ./nginx-lb.conf:/etc/nginx/nginx.conf:ro
```

---

## Troubleshooting

### Common Issues

**Container Won't Start**

```bash
docker logs sequential-thinking-mcp
docker pull mekayelanik/sequential-thinking-mcp:stable
docker restart sequential-thinking-mcp
```

**Connection Refused**

```bash
docker ps | grep sequential-thinking-mcp
docker port sequential-thinking-mcp
curl http://localhost:8005/healthz
```

**API Key Authentication Errors**

```bash
# Verify API key is set
docker exec sequential-thinking-mcp env | grep API_KEY

# Test with authentication
curl -H "Authorization: Bearer your-api-key" \
     http://localhost:8005/mcp
```

**CORS Errors**

```yaml
# Development
environment:
  - CORS=*

# Production
environment:
  - CORS=https://yourdomain.com
```

**Permission Errors**

```bash
# Update PUID/PGID
docker run -d \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  mekayelanik/sequential-thinking-mcp:stable
```

**Debug Mode**

```yaml
environment:
  - DEBUG_MODE=true
```

### Health Check Testing

```bash
# Basic health check
curl http://localhost:8005/healthz

# Test MCP endpoint
curl http://localhost:8005/mcp

# Test with tool invocation
curl -X POST http://localhost:8005/mcp \
  -H "Content-Type: application/json" \
  -d '{"method":"tools/list"}'
```

---

## Security Best Practices

1. **Always Use Strong API Keys**
   ```yaml
   environment:
     - API_KEY=$(openssl rand -base64 32)
   ```

2. **Never Use `CORS=*` in Production**
   ```yaml
   environment:
     - CORS=https://yourdomain.com
   ```

3. **Use HTTPS with Reverse Proxy**
   - Always terminate SSL at reverse proxy
   - Use valid SSL certificates

4. **Run as Non-Root User**
   ```yaml
   environment:
     - PUID=1000
     - PGID=1000
   ```

5. **Monitor Logs for Suspicious Activity**
   ```bash
   docker logs -f sequential-thinking-mcp | grep -E "unauthorized|failed"
   ```

6. **Keep Docker Image Updated**
   ```bash
   docker pull mekayelanik/sequential-thinking-mcp:stable
   docker compose up -d
   ```

---

## Integration Examples

### Python Integration

```python
import requests

class SequentialThinkingMCP:
    def __init__(self, base_url, api_key=None):
        self.base_url = base_url
        self.headers = {"Content-Type": "application/json"}
        if api_key:
            self.headers["Authorization"] = f"Bearer {api_key}"
    
    def sequential_thinking(self, thought_process):
        payload = {
            "method": "tools/call",
            "params": {
                "name": "sequential_thinking",
                "arguments": {"thought_process": thought_process}
            }
        }
        response = requests.post(self.base_url, headers=self.headers, json=payload)
        return response.json()

# Usage
client = SequentialThinkingMCP("http://localhost:8005/mcp", "your-api-key")
result = client.sequential_thinking("Solve: 2x + 5 = 15")
```

### Node.js Integration

```javascript
const axios = require('axios');

class SequentialThinkingMCP {
  constructor(baseURL, apiKey = null) {
    this.baseURL = baseURL;
    this.headers = {'Content-Type': 'application/json'};
    if (apiKey) {
      this.headers['Authorization'] = `Bearer ${apiKey}`;
    }
  }

  async sequentialThinking(thoughtProcess) {
    const response = await axios.post(
      this.baseURL,
      {
        method: 'tools/call',
        params: {
          name: 'sequential_thinking',
          arguments: {thought_process: thoughtProcess}
        }
      },
      {headers: this.headers}
    );
    return response.data;
  }
}

// Usage
const client = new SequentialThinkingMCP('http://localhost:8005/mcp', 'your-api-key');
const result = await client.sequentialThinking('Calculate factorial of 5');
```

---

## Resources & Support

### Documentation
- 📦 [NPM Package](https://www.npmjs.com/package/@modelcontextprotocol/server-sequential-thinking)
- 🔧 [GitHub Repository](https://github.com/mekayelanik/sequential-thinking-mcp-docker)
- 🐳 [Docker Hub](https://hub.docker.com/r/mekayelanik/sequential-thinking-mcp)

### MCP Resources
- 📘 [MCP Protocol Specification](https://modelcontextprotocol.io)
- 🎓 [MCP Documentation](https://modelcontextprotocol.io/docs)
- 💬 [MCP Community](https://discord.gg/mcp)

### Getting Help

**Docker Image Issues:**
- [GitHub Issues](https://github.com/mekayelanik/sequential-thinking-mcp-docker/issues)
- [Discussions](https://github.com/mekayelanik/sequential-thinking-mcp-docker/discussions)

### Updating

```bash
# Docker Compose
docker compose pull && docker compose up -d

# Docker CLI
docker pull mekayelanik/sequential-thinking-mcp:stable
docker stop sequential-thinking-mcp
docker rm sequential-thinking-mcp
# Re-run your docker run command
```

---

## FAQ

**Q: What is Sequential Thinking MCP?**  
A: A Model Context Protocol server that enables AI assistants to perform structured, step-by-step reasoning.

**Q: Do I need an API key?**  
A: Optional but strongly recommended for production deployments.

**Q: Which protocol should I use?**  
A: We recommend SHTTP for best compatibility and performance.

**Q: How do I secure my deployment?**  
A: Use strong API key, enable CORS restrictions, use HTTPS with reverse proxy.

**Q: What resources does the container need?**  
A: Minimum 256MB RAM and 0.5 CPU cores. Recommended: 512MB RAM and 1 CPU core.

---

## License

GPL License - See [LICENSE](https://raw.githubusercontent.com/MekayelAnik/sequential-thinking-mcp-docker/refs/heads/main/LICENSE) for details.

**Disclaimer:** Unofficial Docker image for [@modelcontextprotocol/server-sequential-thinking](https://www.npmjs.com/package/@modelcontextprotocol/server-sequential-thinking).

---

<div align="center">

[Report Bug](https://github.com/mekayelanik/sequential-thinking-mcp-docker/issues) • [Request Feature](https://github.com/mekayelanik/sequential-thinking-mcp-docker/issues) • [Contribute](https://github.com/mekayelanik/sequential-thinking-mcp-docker/pulls)

⭐ **Star this project if you find it useful!**

</div>