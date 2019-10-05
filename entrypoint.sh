#!/bin/bash

install_zip_dependencies(){
	echo "Installing and zipping dependencies..."
	mkdir python
	pip install --target=python $1
	zip -r dependencies.zip ./python
}

publish_dependencies_as_layer(){
	echo "Publishing dependencies as a layer..."
	local result=$(aws lambda publish-layer-version --layer-name "${LAMBDA_LAYER_ARN}" --zip-file fileb://dependencies.zip)
	LAYER_VERSION=$(jq '.Version' <<< "$result")
	rm -rf python
	rm dependencies.zip
}

publish_function_code(){
	echo "Deploying the code itself..."
	echo "Listing all files (ls -a)"
	ls -a
	echo "Running tree command"
	tree /
	zip -r code.zip . -x .git\*
	aws lambda update-function-code --function-name "${LAMBDA_FUNCTION_NAME}" --zip-file fileb://code.zip
}

update_function_layers(){
	echo "Using the layer in the function..."
	aws lambda update-function-configuration --function-name "${LAMBDA_FUNCTION_NAME}" --layers "${LAMBDA_LAYER_ARN}:${LAYER_VERSION}"
}

deploy_lambda_function(){
	install_zip_dependencies $1
	publish_dependencies_as_layer
	publish_function_code
	update_function_layers
}

deploy_lambda_function $1
echo "Done."
