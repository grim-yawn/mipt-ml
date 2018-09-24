.PHONY: all
all: build

.PHONY: sync
sync:
	pipenv sync

.PHONY: build
build: sync html

.PHONY: html
html:
	pipenv run jupyter nbconvert notebooks/*.ipynb
	mkdir -p dist
	mv notebooks/*.html dist/