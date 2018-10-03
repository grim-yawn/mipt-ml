USERNAME = strangeducttape
APPLICATION = mipt-ml
IMAGE = $(USERNAME)/$(APPLICATION)

TAG=$(shell git rev-parse HEAD)

.PHONY: build
build:
	docker build -t $(IMAGE):$(TAG) .

.PHONY: run
run: build
	docker run -p 8888:8888 \
	-v $(PWD)/notebooks:/app/notebooks:rw \
	$(IMAGE):$(TAG) \
	jupyter notebook --ip 0.0.0.0 --no-browser --allow-root

.PHONY: html
html: build
	docker run --rm \
	-v $(PWD)/dist:/app/dist:rw \
	$(IMAGE):$(TAG) \
	jupyter nbconvert --execute notebooks/*.ipynb --output-dir dist
