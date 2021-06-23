#!/bin/bash

source ../config.sh

# VARIABLES DEFINED
ENV=$1
if [ -z "$ENV" ]; then
  ENV='dev'
fi

APP_NAME_TEMPLATE=$DIST_OUTPUT_BUCKET-$REGION
APP_NAME=$SOLUTION_NAME

echo APP_NAME_TEMPLATE $APP_NAME_TEMPLATE
echo APP_NAME $APP_NAME
# FUNCTIONS
package_template() {
  aws cloudformation package --template-file $1 --s3-bucket $APP_NAME_TEMPLATE --output-template-file $2
}

deploy() {
  aws cloudformation deploy --template-file $1 --stack-name $APP_NAME \
  --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/cloudformation-deployment --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides EnvironmentName=$ENV \
  CorsEnabled=No \
  SourceBuckets=$LAMBDA_BUCKET \
  DeployDemoUI=Yes \
  AutoWebP=No \
  EnableSignature=No
}

package_template "global-s3-assets/serverless-image-handler.template" "output.yml"

# deploy cloudformation
deploy "output.yml"