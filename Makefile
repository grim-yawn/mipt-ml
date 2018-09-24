.PHONY: all
all: sync html

.PHONY: sync
sync:
	pipenv sync

.PHONY: html
html:
	pipenv run jupyter nbconvert notebooks/*.ipynb
	mkdir -p dist
	mv notebooks/*.html dist/