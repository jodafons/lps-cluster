all: build_local
SHELL := /bin/bash


build_local:
	virtualenv -p python ${VIRTUALENV_NAMESPACE}
	source ${VIRTUALENV_NAMESPACE}/bin/activate && pip install --upgrade pip && pip install -r requirements.txt


run_jupyter:
	source activate.sh jupyter