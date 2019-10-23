# AWS Lambda Python Action

This is a GitHub Action that can be used to automate the deployment of python functions to AWS Lambda. Using a provided space-delimited list of python dependencies, it installs them to a lambda layer and then binds that layer to the lambda function in AWS.

## Usage

1. Create a repository and add a file called 'lambda_function.py' that contains your lambda function.  
2. Go into the Settings for the repository, then go to the 'Secrets' section and add the following secret environment variables:
  * **AWS_ACCESS_KEY_ID** (The AWS access key part of your credentials)
  * **AWS_DEFAULT_OUTPUT** (The Default Format for AWS Responses, i.e. 'json')
  * **AWS_DEFAULT_REGION** (The Default AWS Region, i.e. us-east-1)
  * **AWS_SECRET_ACCESS_KEY** (The AWS secret access key part of your credentials)
  * **LAMBDA_FUNCTION_NAME** (The Name or ARN for the Lambda Function in AWS)
  * **LAMBDA_LAYER_ARN** (The ARN for the Lambda Dependency Layer in AWS)
  * see here for more info on these values: https://docs.aws.amazon.com/cli/latest/reference/configure/  
3. Next, in the root of the repository, create a '.github' folder and within that folder create a 'workflows' folder.  
4. Then, inside of the 'workflows' folder, create a YAML file that contains your workflow and references this action repository to deploy your lambda function to AWS.  

Here is an example workflow YAML file that you would have in your lambda function's repository in **.github/workflows/**:  
```yml
name: On Push
on:
  push:
    branches:
      - master

jobs:
  deploy_to_aws:
    name: Deploy a functon to AWS Lambda
    runs-on: ubuntu-latest
    steps:
    - name: Checking out code...
      id: checkout
      uses: actions/checkout@master
      with:
        fetch-depth: 1
    - name: Deploying to AWS Lambda Step (entrypoint.sh)
      id: aws
      uses: samsetegne/aws_lambda_python_action@0.0.6
      with:
        requirements: 'pymysql pandas cython'
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_DEFAULT_OUTPUT: ${{ secrets.AWS_DEFAULT_OUTPUT }}
        AWS_DEFAULT_REGION: ${{ secrets.AWS_DEFAULT_REGION }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        LAMBDA_FUNCTION_NAME: ${{ secrets.LAMBDA_FUNCTION_NAME }}
        LAMBDA_LAYER_ARN: ${{ secrets.LAMBDA_LAYER_ARN }}
```

In the '**on:**' section, the trigger action is set to only when pushes are made to the master branch. Then, in the '**jobs:**' section, there are two '**steps:**'
  * ### Step 1
    - Checkout your repo's code using the official checkout action from GitHub found in the repository **actions/checkout**
  * ### Step 2
    - Deploy the lambda function to AWS using the action from this repo (**samsetegne/aws_lambda_python_action**) and include pymysql, pandas, and cython as requirements to be installed in the lambda layer created during the automated deployment.
