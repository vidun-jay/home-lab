# 🏡 Home Lab
Monorepo for home Kubernetes lab. 

## 🐳 Docker Hub

All images are published to:  
👉 [**docker.io/vidunj**](https://hub.docker.com/u/vidunj)

Used across bots and services in this repo.

## 🛠️ Deploy

Use the included `Makefile` to deploy services:

```bash
make          # shows available commands
make all      # deploys everything
make discord  # deploys only the Discord bots
make plex     # deploys only the Plex server
```
