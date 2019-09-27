ACCESSKEY := $(ACCESSKEY)
ACMCERTIFICATEARN := $(ACMCERTIFICATEARN)
ENVIRONMENT := $(ENVIRONMENT)
HOSTEDZONEID := $(HOSTEDZONEID)
REGION := $(REGION)
SECRETKEY := $(SECRETKEY)
STACK := $(STACK)


all: createCreds clean install
.PHONY: all

.PHONY: clean
clean: teardownFrontend

.PHONY: install
install: updateFrontendS3 uploadFrontendS3 deployFrontend

.PHONY: createCreds
createCreds:
	mkdir -p ~/.aws/
	touch ~/.aws/credentials
	echo "[rtdeploy]" >> ~/.aws/credentials
	@echo "aws_access_key_id=$(ACCESSKEY)" >> ~/.aws/credentials
	@echo "aws_secret_access_key=$(SECRETKEY)" >> ~/.aws/credentials

.PHONY: testCreds
testCreds:
	aws cloudformation list-stacks --region $(REGION) --profile rtdeploy

.PHONY: uploadCFTemplates
prepareCFTemplates:
	aws s3 cp frontend-s3-template.yaml s3://responsetime-$(ENVIRONMENT)-templates-$(REGION) --region $(REGION) --profile rtdeploy
	aws s3 cp frontend-template.yaml s3://responsetime-$(ENVIRONMENT)-templates-$(REGION) --region $(REGION) --profile rtdeploy
	aws s3 cp backend-template.yaml s3://responsetime-$(ENVIRONMENT)-templates-$(REGION) --region $(REGION) --profile rtdeploy

.PHONY: deployFrontendS3
deployFrontendS3:
	aws cloudformation deploy --template-file frontend-s3-template.yaml --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --parameter-overrides Stack=$(STACK) Environment=$(ENVIRONMENT) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-create-complete --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy

.PHONY: updateFrontendS3
updateFrontendS3:
	aws cloudformation update-stack --template-url https://s3.amazonaws.com/responsetime-$(ENVIRONMENT)-templates-$(REGION)/frontend-s3-template.yaml --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --parameter ParameterKey=Stack,ParameterValue=$(STACK) ParameterKey=Environment,ParameterValue=$(ENVIRONMENT) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-update-complete --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy

.PHONY: teardownFrontendS3
teardownFrontendS3:
	aws cloudformation delete-stack --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-delete-complete --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy

.PHONY: uploadFrontendS3
uploadFrontendS3:
	aws s3 cp frontend/ s3://$(STACK).$(ENVIRONMENT).responsetime.net --recursive --region $(REGION) --profile rtdeploy

.PHONY: deployFrontend
deployFrontend:
	aws cloudformation deploy --template-file frontend-template.yaml --stack-name responsetime-frontend-$(ENVIRONMENT)-$(STACK) --parameter-overrides Stack=$(STACK) Environment=$(ENVIRONMENT) AcmCertificateArn=$(ACMCERTIFICATEARN) HostedZoneId=$(HOSTEDZONEID) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-create-complete --stack-name responsetime-frontend-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy

.PHONY: teardownFrontend
teardownFrontend:
	aws cloudformation delete-stack --stack-name responsetime-frontend-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-delete-complete --stack-name responsetime-frontend-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy

.PHONY: deployBackend
deployBackend:
	aws cloudformation deploy --template-file frontend-template.yaml --stack-name responsetime-backend-$(ENVIRONMENT)-$(STACK) --parameter-overrides Stack=$(STACK) Environment=$(ENVIRONMENT) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-create-complete --stack-name responsetime-backend-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy

.PHONY: teardownBackend
teardownBackend:
	aws cloudformation delete-stack --stack-name responsetime-backend-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy
	aws cloudformation wait stack-delete-complete --stack-name responsetime-backend-$(ENVIRONMENT)-$(STACK) --no-paginate --region $(REGION) --profile rtdeploy
