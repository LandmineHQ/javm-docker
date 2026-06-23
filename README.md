# javm-docker 🐳

A simple Docker hello-world example with GitHub Actions CI/CD pipeline.

## Project Structure

```
javm-docker/
├── .github/
│   └── workflows/
│       └── docker-publish.yml   # GitHub Actions workflow
├── .dockerignore                # Files excluded from Docker build
├── Dockerfile                   # Docker image definition
├── entrypoint.sh                # Container entrypoint script
└── README.md                    # This file
```

## Quick Start

### Build locally

```bash
docker build -t javm-docker .
```

### Run locally

```bash
docker run --rm javm-docker
```

### Pull from Docker Hub (after CI/CD is configured)

```bash
docker pull <your-dockerhub-username>/javm-docker:latest
docker run --rm <your-dockerhub-username>/javm-docker:latest
```

## GitHub Actions CI/CD Setup

### Step 1: Create Docker Hub Access Token

1. Go to [Docker Hub](https://hub.docker.com/) and log in
2. Navigate to **Account Settings** → **Personal access tokens**
3. Click **Generate new token**
4. Give it a description (e.g., `github-actions`) and select **Read & Write** permissions
5. Copy the generated token (you won't be able to see it again!)

### Step 2: Configure GitHub Repository Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following **Repository secrets**:

| Secret Name         | Value                        |
|---------------------|------------------------------|
| `DOCKERHUB_USERNAME`| Your Docker Hub username     |
| `DOCKERHUB_TOKEN`   | The access token from Step 1 |

### Step 3: Push and Trigger

Once the secrets are configured, pushing to the `main` branch or creating a version tag will automatically:

1. Build the Docker image
2. Tag it appropriately (latest, branch name, SHA, semver)
3. Push it to Docker Hub

### Tagging Strategy

| Trigger                  | Tags Generated                        |
|--------------------------|---------------------------------------|
| Push to `main`           | `latest`, `main`, `<short-sha>`       |
| Tag `v1.2.3`             | `1.2.3`, `1.2`, `<short-sha>`         |
| Pull Request #42         | `pr-42` (build only, no push)         |

## License

MIT
