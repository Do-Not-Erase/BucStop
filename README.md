# BucStop (Do Not Erase)

![BucStop Logo](/Bucstop%20WebApp/BucStop/wwwroot/Logo.png)

## Overview

BucStop is a modern microservices-based gaming platform developed as part of the Software Engineering II course. <br>This platform features classic arcade games (Snake, Tetris, and Pong) with a clean, responsive UI and a scalable architecture designed for cloud deployment.

[▶️ Watch the (old) BucStop-Goofin Intro & Demo Video](https://vimeo.com/1079595088/f69404c8a6?ts=0&share=copy)



## Architecture

The application is built using a microservices architecture with the following components:

- **WebApp**: Main frontend service that handles user authentication, game selection, and user interface
- **API Gateway**: Orchestrates communication between the WebApp and game microservices
- **Game Microservices**: Independent services for each game (Snake, Tetris, Pong, Buc-e-Mon)

![Architecture Diagram (old)](/Documentation/CookedGraph.png)

## Technologies

- **Backend**: ASP.NET Core 
- **Frontend**: HTML5, CSS3, JavaScript
- **Containerization**: Docker, Docker Compose
- **Deployment**: Raspberry Pi (self-hosted runner)
- **Networking**: Zerotier (secure remote access)
- **Logging**: Serilog
- **CI/CD**: GitHub Actions (automated deployment with smoke tests and rollback)


## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) and Docker Compose
- [.NET 6 SDK](https://dotnet.microsoft.com/download/dotnet/6.0) (for development only)
- [Git](https://git-scm.com/downloads)

### Local Development (with containerization)

1. Clone the repository:
   ```bash
   git clone https://github.com/Do-Not-Erase/BucStop.git
   cd BucStop
   ```

2. Start all services using Docker Compose:
   ```bash
   docker compose up
   ```

3. Access the application:
   - WebApp: http://localhost:8080
   - API Gateway: http://localhost:8081
   - Snake: http://localhost:8082
   - Pong: http://localhost:8083
   - Tetris: http://localhost:8084
   - Buc-e-Mon: http://localhost:8085
   
   **Note**: When accessing via Zerotier, replace `localhost` with your Pi's Zerotier IP (e.g., `10.147.19.64`)

### Local Development Without Docker

#### Using Visual Studio (Individual Services)

Each microservice has its own solution file:
- `Bucstop WebApp/BucStop.sln` - Main web application
- `Team-3-BucStop_APIGateway/APIGateway.sln` - API Gateway
- `Team-3-BucStop_Snake/Snake.sln` - Snake game
- `Team-3-BucStop_Pong/Pong.sln` - Pong game
- `Team-3-BucStop_Tetris/Tetris.sln` - Tetris game
- `Team-3-BucStop_Buc-e-Mon/Team-3-BucStop_Buc-e-Mon.sln` - Buc-e-Mon game

**To debug a single service:**
1. Open the specific service's `.sln` file in Visual Studio
2. Press F5 to run with debugging
3. The service will start on its configured port

**Note:** Since each service is in a separate solution, debugging the full stack requires either:
- Running other services via Docker Compose while debugging one in Visual Studio
- Opening multiple Visual Studio instances (one per service) - not recommended due to resource usage

**Recommended approach:** Use Docker Compose for local development (see above), and only open individual services in Visual Studio when you need to debug specific issues



## Deployment to Raspberry Pi

### Automated Deployment with GitHub Actions

The project uses a fully automated CI/CD pipeline that deploys to a Raspberry Pi on every push to `main`. The workflow:

1. **Build**: Builds all Docker images from latest code
2. **Deploy**: Starts/refreshes the Docker Compose stack
3. **Smoke Test**: Validates all services are reachable (HTTP connectivity check)
4. **Rollback**: Automatically reverts to last known-good commit if smoke test fails
5. **Success Log**: Records successful deployment SHA with timestamp

See [`.github/workflows/deploy-to-pi.yml`](.github/workflows/deploy-to-pi.yml) for the complete workflow.

### Setting Up Raspberry Pi (One-Time Setup)

#### Prerequisites
- Raspberry Pi (Model 3B+ or newer recommended)
- Raspberry Pi OS (64-bit preferred for better Docker performance)
- Zerotier account and network ID
- GitHub repository with Actions enabled

#### 1. Zerotier Network Setup

Zerotier creates a secure virtual network allowing remote access to your Pi without port forwarding:

1. Create a Zerotier account at [zerotier.com](https://www.zerotier.com/)
2. Create a new network and note the **Network ID**
3. Install Zerotier on the Raspberry Pi:
   ```bash
   curl -s https://install.zerotier.com | sudo bash
   sudo zerotier-cli join <YOUR_NETWORK_ID>
   ```
4. Authorize the Pi in the Zerotier web console (check the device box)
5. Note the assigned Zerotier IP address (e.g., `10.147.19.64`)
6. Install Zerotier on your development machine to access the Pi remotely

#### 2. Install Dependencies on Raspberry Pi

SSH into your Pi via Zerotier:
```bash
ssh pi@<ZEROTIER_IP>
```

Install Docker and Git:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose -y

# Install Git
sudo apt install git -y

# Log out and back in for docker group to take effect
```

See [Documentation/Raspberry Pi/](/Documentation/Raspberry%20Pi/) for detailed Pi setup guides.

#### 3. Configure GitHub Self-Hosted Runner

1. On GitHub, navigate to **Settings** → **Actions** → **Runners** → **New self-hosted runner**
2. Select **Linux** and **ARM64** (or ARM if using 32-bit OS)
3. Follow the commands provided to download and configure the runner on your Pi:
   ```bash
   # Example commands (use actual commands from GitHub)
   mkdir actions-runner && cd actions-runner
   curl -o actions-runner-linux-arm64-2.XXX.X.tar.gz -L https://github.com/actions/runner/releases/download/vX.XXX.X/actions-runner-linux-arm64-2.XXX.X.tar.gz
   tar xzf ./actions-runner-linux-arm64-2.XXX.X.tar.gz
   ./config.sh --url https://github.com/Do-Not-Erase/BucStop --token <YOUR_TOKEN>
   ```
4. Install runner as a service so it persists across reboots:
   ```bash
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```
5. Verify runner shows as "Idle" in GitHub Actions settings

#### 4. Clone Repository on Pi

```bash
cd ~
git clone https://github.com/Do-Not-Erase/BucStop.git
cd BucStop
```

#### 5. Trigger First Deployment

Push to `main` branch or manually trigger the workflow:
- Go to **Actions** tab in GitHub
- Select **Deploy to Raspberry Pi** workflow
- Click **Run workflow** → **Run workflow**

The runner on your Pi will execute the deployment automatically.

### Manual Deployment (Optional)

If you need to deploy manually without GitHub Actions:

```bash
ssh pi@<ZEROTIER_IP>
cd ~/BucStop
git pull origin main
docker compose up -d --build
```

### Environment Configuration

The application supports multiple environments through configuration files:

- `appsettings.Development.json`: Local development settings (for Visual Studio debugging)
- `appsettings.containersLocal.json`: Local Docker container settings (default for local `docker compose`)
- `appsettings.containers.json`: Production container settings (used on Raspberry Pi)

The deployment workflow automatically uses `containersLocal` for testing. When manually deploying to production, you can override:

```bash
env=containers docker compose up -d
```

## CI/CD Pipeline Details

### Smoke Testing

After each deployment, the workflow runs automated smoke tests ([`Scripts/smoke-test.sh`](Scripts/smoke-test.sh)) to verify:
- All services are reachable via HTTP
- Services respond within 120 seconds
- Currently runs in "reachability mode" (any HTTP response = success)

Configuration:
- `REACHABILITY_ONLY=1`: Accepts any HTTP status (including 4xx/5xx) as "service alive"
- `TIMEOUT_SECS=120`: Maximum wait time per endpoint
- Tests endpoints: WebApp (8080), Gateway (8081), Snake (8082), Pong (8083), Tetris (8084)
- **Note**: Buc-e-Mon (8085) is not currently included in smoke tests

### Automatic Rollback

If smoke tests fail, the workflow automatically:
1. Captures service state and recent logs (300 lines)
2. Reads last successful commit SHA from `deployment-success.log`
3. Checks out that commit (detached HEAD)
4. Rebuilds Docker images
5. Restarts the stack with the previous working version

See [`Scripts/rollback.sh`](Scripts/rollback.sh) for implementation.

### Success Tracking

Successful deployments are logged with:
- ISO 8601 timestamp
- Git commit SHA
- Stored in `deployment-success.log` (committed to repo)
- Uploaded as workflow artifact for backup

## Project Structure

```
BucStop/
├── .github/
│   └── workflows/
│       └── deploy-to-pi.yml        # CI/CD pipeline for automated deployment
├── Bucstop WebApp/                 # Main web application
│   └── BucStop/
│       ├── Controllers/            # MVC controllers
│       ├── Views/                  # UI templates
│       ├── Models/                 # Data models
│       ├── Services/               # Business logic
│       ├── MicroServices/          # Service communication
│       ├── Logs/                   # Application logs
│       └── Snapshots/              # User session snapshots
├── Team-3-BucStop_APIGateway/      # API Gateway service
│   └── APIGateway/
│       ├── Controllers/            # Gateway routing controllers
│       └── GameInfo.cs             # Game metadata
├── Team-3-BucStop_Snake/           # Snake game microservice
├── Team-3-BucStop_Tetris/          # Tetris game microservice
├── Team-3-BucStop_Pong/            # Pong game microservice
├── Team-3-BucStop_Buc-e-Mon/       # Buc-e-Mon game microservice
├── Team-3-BucStop_Test/            # Test/empty service template
├── Scripts/
│   ├── smoke-test.sh               # Post-deployment health checks
│   ├── rollback.sh                 # Automatic rollback script
│   ├── run-smoke.sh                # Smoke test wrapper
│   ├── deploy.sh                   # Manual deployment helper
│   └── shutdown.sh                 # Service shutdown script
├── Documentation/                  # Project documentation
│   ├── Raspberry Pi/               # Pi setup guides
│   ├── GitHub Actions/             # CI/CD documentation
│   └── Microservices and Docker/   # Architecture docs
├── docker-compose.yml              # Container orchestration
└── deployment-success.log          # Successful deployment tracking
```

## Contributing

1. Clone the repository 
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### Common Issues

1. **Services not connecting properly**:
   - Ensure all services are running (`docker ps`)
   - Check if the API Gateway is configured with correct service URLs
   - Verify network connectivity between containers

2. **Game not loading**:
   - Check browser console for JavaScript errors
   - Verify that the game's microservice is running
   - Check API Gateway logs for routing issues

### Logs

All services use Serilog for structured logging:

```bash
# View logs for all containers
docker compose logs

# View logs for a specific service
docker compose logs bucstop
docker compose logs api-gateway
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

* Original BucStop project that served as foundation from previous semesters
* All contributors to the project from the most recent semester:
	- @Christopher-Powers, @ChristopherOaks (other Chris), @Brofessortec, @nixonrs-bucs, @CurtisReece, @minknd, @Ismaelizzy, @Zach1204 
* Software Engineering II course instructor, Professor Kinser
