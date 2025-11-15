Auto-update (Unraid / Docker hosts)
=================================

This project doesn't change existing containers on your Unraid host by itself — you must pull a rebuilt image and recreate the container or use an auto-update mechanism.

Two recommended approaches:

1) Use Unraid's built-in update flow (GUI)
   - Pull the new image and use Docker → Edit container → Apply to recreate the container with the same settings.

2) Automatic updates with Watchtower (recommended for hands-off updates)
   - Watchtower monitors the Docker daemon and will automatically pull new images and replace running containers.
   - We include a Compose example in `docker-compose.autoupdate.yml` that runs both the Ombibot container and Watchtower.

Quick start (on any Linux host, or a full-featured Unraid that supports docker-compose):

```bash
# from the repository root
# copy your .env next to this compose file (or modify the service to point to your host path)
# start services in detached mode
docker compose -f docker-compose.autoupdate.yml up -d
```

How it works
------------
- Watchtower checks the Docker registry for the image used by the `ombibot` container on the interval specified (default here: 300s = 5 minutes).
- When a new image is detected, Watchtower pulls the image, stops the running container, recreates it (same args) and starts it with the new image.
- The `--cleanup` flag removes old images after the update.

Notes & caveats
----------------
- Watchtower recreates containers using the same Docker run parameters — that works best when you run containers with Docker CLI or compose. If you create or manage containers via Unraid GUI templates, Watchtower will still work but be mindful that Unraid shows containers it manages and may try to reconcile template state.
- Always keep backups of important configuration files and volumes (config files, DBs, etc.) before enabling automatic updates.
- If you want more control (e.g., auto-update only on certain tags), read Watchtower docs: https://containrrr.dev/watchtower/

If you want, I can:
- Add a small Unraid-specific script that pulls the new image and triggers the GUI update path, or
- Add a GitHub Actions job that tags releases and optionally notifies Community Applications maintainers to update the template.
