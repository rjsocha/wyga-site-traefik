REGISTRY  ?= wyga/wyga-site
UPSTREAM  ?= traefik:latest
PLATFORMS ?= linux/amd64,linux/arm64
OUTPUT = type=image,push=true,compression=gzip,compression-level=9
BUILDER = multiplatform-builder
BUILDX = docker buildx build --provenance false --platform $(PLATFORMS) --output $(OUTPUT) --builder $(BUILDER)
TAG = latest
all:
	$(BUILDX) -f dockerfile/Dockerfile -t $(REGISTRY):$(TAG) --build-arg UPSTREAM=$(UPSTREAM) --pull context
