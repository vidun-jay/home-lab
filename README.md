# 🏡 Home Lab
Monorepo for home Kubernetes lab. 

## 🐳 Docker Hub

All images are published to:  
👉 [**docker.io/vidunvj**](https://hub.docker.com/u/vidunvj)

Used across bots and services in this repo.

## 🛠️ Deploy

Use the included `Makefile` to deploy services:

```bash
make          # shows available commands
make all      # deploys everything
make discord  # deploys only the Discord bots
make plex     # deploys only the Plex server
```

## 📋 To Do
- [ ] Implement CI/CD pipeline using GitHub Actions
- [ ] Finish adding all components to cluster
  - [ ] Migrate minecraft server to cluster
