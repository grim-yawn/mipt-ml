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
	docker run --name html_gen \
	$(IMAGE) jupyter nbconvert --execute notebooks/*.ipynb --output-dir dist
	# NOTE(ikosolapov): docker cp instead of volume mounting to fix permission denied
	# error for non-root user in container and root user on host.
	docker cp html_gen:/home/$(DOCKER_USER)/dist .
	docker rm html_gen