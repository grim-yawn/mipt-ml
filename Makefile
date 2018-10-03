USERNAME = strangeducttape
APPLICATION = mipt-ml
TAG=$(shell git rev-parse HEAD)

IMAGE = $(USERNAME)/$(APPLICATION):$(TAG)

.PHONY: build
build:
	docker build -t $(IMAGE) .

.PHONY: run
run: build
	docker run -p 8888:8888 \
	-v $(PWD)/notebooks:/home/appuser:rw \
	$(IMAGE)

.PHONY: html
html: build
	docker run --rm \
	-v $(PWD)/dist:/home/appuser/dist:rw \
	$(IMAGE) jupyter nbconvert --execute notebooks/*.ipynb --output-dir dist
