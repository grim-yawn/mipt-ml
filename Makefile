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

.PHONY: datasets
datasets: dataset_titanic

.PHONY: dataset_titanic
dataset_titanic: build
	docker run --rm \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	--mount type=volume,src=datasets,dst=/home/$(DOCKER_USER)/datasets \
	$(IMAGE) kaggle competitions download -c titanic -p /home/$(DOCKER_USER)/datasets/titanic

.PHONY: submit
submit: html submit_titanic

.PHONY: submit_titanic
submit_titanic: build
	docker run --rm \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	--mount type=volume,src=results,dst=/home/$(DOCKER_USER)/results,readonly \
	$(IMAGE) kaggle competitions submit -m "Created from: $(TAG)" -c titanic -f /home/$(DOCKER_USER)/results/titanic/result.csv

.PHONY: run
run: build datasets
	docker run -p 8888:8888 \
	--mount type=bind,src=$(PWD)/notebooks,dst=/home/$(DOCKER_USER)/notebooks \
	--mount type=volume,src=datasets,dst=/home/$(DOCKER_USER)/datasets,readonly \
	--mount type=volume,src=results,dst=/home/$(DOCKER_USER)/results \
	$(IMAGE)

.PHONY: html
html: build datasets
	docker run --rm \
	--mount type=volume,src=datasets,dst=/home/$(DOCKER_USER)/datasets,readonly \
	--mount type=volume,src=results,dst=/home/$(DOCKER_USER)/results \
	$(IMAGE) jupyter nbconvert --execute notebooks/*.ipynb --output-dir results