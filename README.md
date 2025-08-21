# Docker CI Pack

This pack gives you a **production-ready Dockerfile** and a **GitHub Actions workflow** that:

- Builds your app into a Docker image on each push to `main`
- Tags it as `latest`, `sha-*`, and `v*` when you push a tag
- Pushes the image to **Docker Hub**

---

## 1) Prerequisites

- Docker installed locally
- A Docker Hub account
- A GitHub repository with your app (Node.js assumed here, with `npm start`)

Your app **must** listen on the port passed by the `PORT` environment variable (default here is `3000`).  
If you use a different port, change it in the Dockerfile and the commands below.

---

## 2) Files in this pack

```text
.
├── Dockerfile
├── .dockerignore
├── compose.yaml
├── scripts/
│   └── test-local.sh
└── .github/
    └── workflows/
        └── docker-publish.yml
```

- **Dockerfile**: minimal, production-focused (Node 20 Alpine).
- **.dockerignore**: keeps your image small.
- **compose.yaml**: run locally with Docker Compose.
- **scripts/test-local.sh**: quick local build/run helper.
- **.github/workflows/docker-publish.yml**: CI workflow.

---

## 3) One-time setup (GitHub Secrets)

In your GitHub repo:

1. Go to **Settings → Secrets and variables → Actions**.
2. Add two **Repository secrets**:
   - `DOCKERHUB_USERNAME` → your Docker Hub username
   - `DOCKERHUB_TOKEN` → a Docker Hub **Access Token** (create it from Docker Hub → Security → New Access Token)
3. Optionally, edit the workflow file to change the repository name part of the image:

   ```yaml
   env:
     IMAGE_NAME: docker.io/${{ secrets.DOCKERHUB_USERNAME }}/github-action-app
   ```

   Replace `github-action-app` with your actual Docker Hub repository name (for example `my-webapp`).

---

## 4) Local build & run (test before pushing)

From your project root (where the Dockerfile is):

```bash
bash scripts/test-local.sh
```

or manually:

```bash
docker build -t local/github-action-app:test .
docker run --rm -p 3000:3000 -e PORT=3000 local/github-action-app:test
```

Then open: <http://localhost:3000>

> If your app uses a different port, change both the **Dockerfile** `ENV PORT=...` and the **-p** mapping above.

---

## 5) Push to main → CI builds & pushes

Once you commit these files and push to **main**, GitHub Actions will:

1. Build your image from the Dockerfile
2. Tag it as `latest` (on default branch), plus an `sha-*` tag
3. Push it to Docker Hub as:  
   `docker.io/<DOCKERHUB_USERNAME>/<repo>:latest`

When you create a tag like `v1.0.0`, CI will also push `:v1.0.0`.

---

## 6) Pull & run from Docker Hub

Replace `USERNAME/REPO` with your Docker Hub namespace/repo:

```bash
docker pull USERNAME/REPO:latest
docker run --rm -p 3000:3000 -e PORT=3000 USERNAME/REPO:latest
```

Example:

```bash
docker pull myname/github-action-app:latest
docker run --rm -p 3000:3000 -e PORT=3000 myname/github-action-app:latest
```

---

## Notes

- This Dockerfile expects a Node.js app with a `package.json` and a `start` script.
- If your app needs a build step (e.g. React/Next), add it before `COPY . .` in the Dockerfile and ensure your start script serves the built files.
- For Python/other stacks, you can adapt the Dockerfile easily:
  - Use a Python base image (e.g., `python:3.12-slim`), `pip install -r requirements.txt`, and set `CMD` to your start command.

test Fri Aug 22 01:11:20 AM EEST 2025
trigger Fri Aug 22 01:36:31 AM EEST 2025
