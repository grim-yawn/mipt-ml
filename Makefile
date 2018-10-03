USERNAME = strangeducttape
APPLICATION = mipt-ml
TAG=$(shell git rev-parse HEAD)

IMAGE = $(USERNAME)/$(APPLICATION):$(TAG)

DOCKER_UID = 1000
DOCKER_USER = appuser

.PHONY: build
build:
	docker build \
	--build-arg NB_UID=$(DOCKER_UID) \
	--build-arg NB_USER=$(DOCKER_USER) \
	-t $(IMAGE) .

.PHONY: run
run: build
	docker run -p 8888:8888 \
	-v $(PWD)/notebooks:/home/$(DOCKER_USER):rw \
	$(IMAGE)

.PHONY: html
html: build
	mkdir -p dist && chmod +rwx dist
	docker run --rm \
	-v $(PWD)/dist:/home/$(DOCKER_USER)/dist:rw \
	$(IMAGE) jupyter nbconvert --execute notebooks/*.ipynb --output-dir dist
