#!/bin/bash

sam package --template-file backend-template.yaml --s3-bucket responsetime-dev-templates-us-east-2 --output-template-file packaged.yaml --profile rtdeploy --region us-east-2
sam deploy --template-file /Users/andy/responsetime/packaged.yaml --stack-name responsetime-backend-dev-green --capabilities CAPABILITY_IAM --profile rtdeploy --region us-east-2
