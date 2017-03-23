#!/bin/bash

# to configure a new profile/account
# aws configure --profile <profile name> (configure your keys)
# export AWS_DEFAULT_PROFILE=<profile name>-session
# aws configure --profile <profile name>-session (configure just default region and output format)



PROFILE=$1
TOKEN_CODE=$2
DURATION_IN_SECONDS=$3

#SUFIX=-session
SUFIX=s

if [ -z "$PROFILE" ]; then
  echo "[ERROR] you should specify the named profile as first parameter"
  exit 1
fi

if [ -z "$TOKEN_CODE" ]; then
  echo "[ERROR] you should specify the token code as second parameter"
  exit 1
fi

if [ -z "$DURATION_IN_SECONDS" ];then
  # Default duration 1 hour
  DURATION_IN_SECONDS=$((60*60))
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SECURITY_TOKEN
unset AWS_DEFAULT_PROFILE

USER_NAME=`aws --profile $PROFILE iam get-user | jq '.User.UserName' | sed 's/"//g'`
SERIAL_NUMBER=`aws --profile $PROFILE iam get-user | jq '.|.User.Arn' | cut -d'"' -f2 | cut -d':' -f1,2,3,4,5`:mfa/$USER_NAME

CREDENTIALS_JSON=`aws --profile $PROFILE sts get-session-token --duration-seconds $DURATION_IN_SECONDS --serial-number $SERIAL_NUMBER --token-code $TOKEN_CODE`
if [ $? != "0" ];then
  echo "[ERROR] there was an error requesting your credentials, plese verify the account/profile and toke code are correct"
else
  echo "" >> ~/.aws/credentials
  echo "[${PROFILE}$SUFIX]" >> ~/.aws/credentials
  echo aws_access_key_id = `echo $CREDENTIALS_JSON | jq '.Credentials.AccessKeyId' | sed 's/"//g'` >> ~/.aws/credentials
  echo aws_secret_access_key = `echo $CREDENTIALS_JSON | jq '.Credentials.SecretAccessKey' | sed 's/"//g'` >> ~/.aws/credentials
  echo aws_session_token = `echo $CREDENTIALS_JSON | jq '.Credentials.SessionToken' | sed 's/"//g'` >> ~/.aws/credentials
  export AWS_DEFAULT_PROFILE=${PROFILE}$SUFIX
  echo "AWS Credentials for $USER_NAME has been set for account $PROFILE which are valid for the next $((DURATION_IN_SECONDS/3600)) hours"
fi
