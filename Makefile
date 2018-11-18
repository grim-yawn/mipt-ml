USERNAME = strangeducttape
APPLICATION = mipt-ml
TAG=$(shell git rev-parse HEAD)

IMAGE = $(USERNAME)/$(APPLICATION):$(TAG)

DOCKER_UID = 1000
DOCKER_USER = appuser

OSF_USERNAME = kosolapow.iwan@gmail.com
OSF_PROJECT = x783r

.PHONY: build
build:
	docker build \
	--build-arg NB_UID=$(DOCKER_UID) \
	--build-arg NB_USER=$(DOCKER_USER) \
	-t $(IMAGE) .

.PHONY: submit
submit: html submit_titanic

.PHONY: submit_titanic
submit_titanic: submit_titanic_kaggle submit_titanic_osf

.PHONY: submit_titanic_kaggle
submit_titanic_kaggle: build
	@ docker run --rm \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	--mount type=bind,src=$(PWD)/results,dst=/home/$(DOCKER_USER)/results,readonly \
	$(IMAGE) kaggle competitions submit -m "Created from: $(TAG)" -c titanic -f /home/$(DOCKER_USER)/results/titanic/result.csv

.PHONY: submit_titanic_osf
submit_titanic_osf: build
	@ docker run --rm \
	-e KAGGLE_USERNAME=$(KAGGLE_USERNAME) \
	-e KAGGLE_KEY=$(KAGGLE_KEY) \
	-e OSF_PASSWORD=$(OSF_PASSWORD) \
	-e OSF_USERNAME=$(OSF_USERNAME) \
	-e OSF_PROJECT=$(OSF_PROJECT) \
	--mount type=bind,src=$(PWD)/results,dst=/home/$(DOCKER_USER)/results,readonly \
	$(IMAGE) osf upload -f /home/$(DOCKER_USER)/results/titanic/result.csv osfstorage/Kosolapov/titanic.csv

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

