#!/bin/bash

mkdir python

pip install pipenv
pipenv lock -r > requirements.txt
pipenv run pip install -r requirements.txt --target=python

zip -q -r dependencies.zip ./python

local result=$(aws lambda publish-layer-version --layer-name "${LAMBDA_LAYER_ARN}" --zip-file fileb://dependencies.zip)
LAYER_VERSION=$(jq '.Version' <<< "$result")

zip -r code.zip . -x .git\*

aws lambda update-function-code --function-name "${LAMBDA_FUNCTION_NAME}" --zip-file fileb://code.zip
aws lambda update-function-configuration --function-name "${LAMBDA_FUNCTION_NAME}" --layers "${LAMBDA_LAYER_ARN}:${LAYER_VERSION}"
