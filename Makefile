STACK := $(STACK)
ENVIRONMENT := $(ENVIRONMENT)
REGION := $(REGION)

.PHONY: all
all:
	clean install

.PHONY: clean
clean:
	teardownfrontend

.PHONY: install
install:
	uploadfrontend deployfrontends

.PHONY: deployfrontends3
deployfrontends3:
	aws cloudformation deploy --template-file frontend-s3-template.yaml --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy

.PHONY: uploadfrontend
uploadfrontend:
	aws s3 cp frontend/ s3://$(STACK).$(ENVIRONMENT).responsetime.net --recursive --region $(REGION) --profile rtdeploy

.PHONY: deployfrontend
deployfrontend:
	aws cloudformation deploy --template-file frontend-s3-template.yaml --stack-name responsetime-frontend-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy

.PHONY: teardownfrontends3
teardownfrontends3:
	aws cloudformation delete-stack --stack-name responsetime-frontend-s3-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy

.PHONY: teardownfrontend
teardownfrontend:
	aws cloudformation delete-stack --stack-name responsetime-frontend-$(ENVIRONMENT)-$(STACK) --region $(REGION) --profile rtdeploy
