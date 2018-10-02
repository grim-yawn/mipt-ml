USERNAME = strangeducttape
APPLICATION = mipt-ml
IMAGE = $(USERNAME)/$(APPLICATION)

TAG=$(shell git rev-parse HEAD)

.PHONY: build
build:
	docker build -t $(IMAGE):$(TAG) .

.PHONY: run
run: build
	docker run --rm -it $(IMAGE):$(TAG)

.PHONY: html
html:
	docker run --rm \
	-v $(PWD)/dist:/home/appuser/dist \
	$(IMAGE):$(TAG) \
	pipenv run jupyter nbconvert --execute notebooks/*.ipynb && \
	mv notebooks/*.html dist/
