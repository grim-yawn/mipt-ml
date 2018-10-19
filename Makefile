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

.PHONY: submit
submit: html submit_titanic

.PHONY: submit_titanic
submit_titanic: build
	@ docker run --rm \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	--mount type=bind,src=$(PWD)/results,dst=/home/$(DOCKER_USER)/results,readonly \
	$(IMAGE) kaggle competitions submit -m "Created from: $(TAG)" -c titanic -f /home/$(DOCKER_USER)/results/titanic/result.csv

.PHONY: run
run: build
	@ docker run -p 8888:8888 \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	--mount type=bind,src=$(PWD)/notebooks,dst=/home/$(DOCKER_USER)/notebooks \
	$(IMAGE)

.PHONY: html
html: build
	docker rm html_gen || true
	@ docker run --name html_gen \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	$(IMAGE) jupyter nbconvert --execute notebooks/*.ipynb --output-dir results
	docker cp html_gen:/home/$(DOCKER_USER)/results $(PWD)
	docker rm html_gen

