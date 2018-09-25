#!/bin/bash
# Script used to deploy applications to AWS Elastic Beanstalk
#
# Does three things:
# 1. Builds Docker image & pushes it to container registry
#
# REQUIREMENTS!
# - ECR Repository should exist -- reposiroty name should be same as Name variable
# - AWS_ACCOUNT_ID env variable
# - AWS_ACCESS_KEY_ID env variable
# - AWS_SECRET_ACCESS_KEY env variable
#
# usage: ./deploy.sh name-of-application staging us-east-1 f0478bd7c2f584b41a49405c91a439ce9d944657

set -e
start=`date +%s`

# AWS Account ID
read -s -p "Please Enter AWS Account ID, It should be same as in ELastic Bean stalk Set up : " aws_acct_id
echo -e  " \n AWS Account ID is : "  $aws_acct_id
AWS_ACCOUNT_ID=$aws_acct_id

echo $(date +%s)

NAME=weatherservice
REGION=us-east-1
VERSION=$(date +%s)


echo We will need your AWS Credentials to Push Docker Image to ECR

aws configure 
#aws configure set default.region $REGION
#aws configure set default.output json


# Login to AWS Elastic Container Registry
eval $(aws ecr get-login --no-include-email)

# Build the image
mvn package

echo Version is $VERSION

docker build -t $NAME:$VERSION .

# Tag it
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:$VERSION
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:latest

# Push to AWS Elastic Container Registry
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:latest

end=`date +%s`

echo Deploy ended with success! Time elapsed: $((end-start)) seconds

#echo Maven Version is ${MVN_VERSION}
