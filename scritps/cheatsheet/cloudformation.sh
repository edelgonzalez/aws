# Create stack
aws --profile cust1s cloudformation create-stack --stack-name AWSTDTESTVPC --template-body $CFPATH/vpc.json --disable-rollback --parameters ParameterKey=AvailabilityZone,ParameterValue=us-west-2a ParameterKey=SecurityGroupAccess,ParameterValue=0.0.0.0/0

# List stack statuses (excluding DELETE_COMPLETE)
aws --profile cust1s cloudformation list-stacks | jq '.StackSummaries[]|.StackName+", "+.StackStatus' | grep -v DELETE_COMPLETE

# Stack status
aws cloudformation describe-stack-events --stack-name TDCodeChallenge-VPC | jq '.StackEvents[]|{Time: .Timestamp, ResourceStatus: .ResourceStatus, ResourceStatusReason: .ResourceStatusReason, ResourceType: .ResourceType}'
