

# Create a keypair from CLI
aws ec2 create-key-pair --key-name td-code-challenge | jq -r '.KeyMaterial' > td-code-challenge.pm
​
#filter by tag, columns text format
aws --region us-west-2  --profile tmc-beta1 ec2 describe-instances --filters "Name=tag:Name,Values=*16nM4XL20TB-SMP*" | jq -r   '.Reservations[].Instances[]|[(.Tags[]|select(.Key=="Name")).Value,(.BlockDeviceMappings|length), .PublicIpAddress, .InstanceId]|@tsv'
aws --region us-west-2  --profile tmc-beta3 ec2 describe-instances --filters "Name=tag:Name,Values=*WD-6n*-SMP*" | jq -r   '.Reservations[].Instances[]|[(.Tags[]|select(.Key=="Name")).Value,(.BlockDeviceMappings|length), .PublicIpAddress, .InstanceId]|@tsv'

#List ec2 instances
aws ec2 describe-instances | jq '.Reservations[].Instances[]|"InstanceId: "+.InstanceId+", PublicIP: "+.PublicIpAddress'

#************
#List ec2 instances with Tag Name
aws ec2 describe-instances | jq '.Reservations[].Instances[]|"InstanceId: "+.InstanceId+", PublicIP: "+.PublicIpAddress+", Name: "+ (.Tags[]|select(.Key=="Name").Value)'
aws ec2 describe-instances | jq '.Reservations[].Instances[]|"InstanceId: "+.InstanceId+", PublicIP: "+.PublicIpAddress+", Private IP: "+.PrivateIpAddress+", Name: "+ (.Tags[]|select(.Key=="Name").Value)'

#List ec2 that contains certain tag
aws ec2 describe-instances --filters "Name=tag-key,Values=Name"
aws --region us-west-2  --profile tmc-beta1 ec2 describe-instances --filters "Name=tag:Name,Values=*16nM4XL*" | jq -r   '.Reservations[].Instances[]|[(.Tags[]|select(.Key=="Name")).Value,.InstanceId]|@tsv'
aws --region us-west-2  --profile tmc-beta1 ec2 describe-instances --filters "Name=tag:Name,Values=*16nM4XL20TB-SMP*" | jq -r   '.Reservations[].Instances[]|[(.Tags[]|select(.Key=="Name")).Value,(.BlockDeviceMappings|length), .PublicIpAddress, .InstanceId]|@tsv'
