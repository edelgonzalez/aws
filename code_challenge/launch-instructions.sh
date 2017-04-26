#!/bin/bash
# Pre requisites: this commands assume you have the following:
#  - AWS CLI installed and configured
#  - AWS AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env variable are set
#  - Jq command line is installed https://stedolan.github.io/jq/
#

# Step 1 create a new keypair
CFPATH=`echo file:/$(pwd) | sed 's|/|//|g'`
aws --region us-west-2 ec2 create-key-pair --key-name td-code-challenge | jq -r '.KeyMaterial' > td-code-challenge.pem
chmod 400 td-code-challenge.pem

# Step 2 launch VPC stack
aws --region us-west-2 cloudformation create-stack --stack-name TDCodeChallenge-VPC  --template-body $CFPATH/vpc.yml --disable-rollback --parameters ParameterKey=VPCCIDR,ParameterValue="10.70.13.0/24" ParameterKey=CandidateCIDR,ParameterValue="153.65.16.10/32"

# Step 3, launch web servers (Run this command till previous stack has completed)
aws --region us-west-2 cloudformation describe-stacks --stack-name TDCodeChallenge-VPC | jq '.Stacks[].StackStatus'
# once previous command return CREATE_COMPLETE then we can run this command
aws --region us-west-2 cloudformation create-stack --stack-name TDCodeChallenge-Web  --template-body $CFPATH/web-servers.yml --disable-rollback --parameters ParameterKey=Key,ParameterValue=td-code-challenge ParameterKey=VPCStackName,ParameterValue=TDCodeChallenge-VPC ParameterKey=AWSAccessKey,ParameterValue=$AWS_ACCESS_KEY_ID  ParameterKey=AWSSecretAccessKey,ParameterValue=$AWS_SECRET_ACCESS_KEY

# Clean up
aws --region us-west-2 cloudformation delete-stack --stack-name TDCodeChallenge-Web

# Check the status till the deletion of the fist stack is complete (will return an error when the stack is deleted)
aws --region us-west-2 cloudformation describe-stacks --stack-name TDCodeChallenge-Web | jq '.Stacks[].StackStatus'
# Once the stack deletion is complete, delete the VPC stack
aws --region us-west-2 cloudformation delete-stack --stack-name TDCodeChallenge-VPC
aws --region us-west-2 iam delete-server-certificate --server-certificate-name WebServer
