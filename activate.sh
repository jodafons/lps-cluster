#!/bin/bash

export MARKET_PLACE_BASEPATH=/mnt/market_place/scripts
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_EXECUTABLE=/bin/bash
export VIRTUALENV_NAMESPACE=$MARKET_PLACE_BASEPATH/lps-cluster-env


if [ -d "$VIRTUALENV_NAMESPACE" ]; then
    echo "$VIRTUALENV_NAMESPACE exists."
    source $VIRTUALENV_NAMESPACE/bin/activate
else
    virtualenv -p python ${VIRTUALENV_NAMESPACE}
    source $VIRTUALENV_NAMESPACE/bin/activate
    pip install -e .
fi