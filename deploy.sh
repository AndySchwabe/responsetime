#!/bin/bash

cd ~/responsetime/ || exit
sam build
sam package --template-file template.yaml --s3-bucket responsetime-dev-sam-us-east-2 --output-template-file packaged.yaml --profile rt-dev --region us-east-2
sam deploy --template-file /Users/andy/responsetime/packaged.yaml --stack-name responsetime-dev-blue --capabilities CAPABILITY_IAM --profile rt-dev --region us-east-2
