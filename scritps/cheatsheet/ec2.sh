

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

# Describe VPCs/Subnets
aws --profile cust1s ec2 describe-vpcs | jq -r '.Vpcs[]|[.VpcId ,(.Tags[]|select(.Key=="Name")).Value]|@tsv'

# Run instances with tag
aws --region us-west-2 ec2 run-instances --image-id ami-4836a428 --instance-type t2.micro --subnet-id subnet-46db4821 --tag-specifications 'ResourceType=instance,Tags=[{Key=Owner,Value=edgar.gonzalez},{Key=Name,Value="Test Ansible"}]' --key-name icaws-admin-staging-test  --associate-public-ip-address --dry-run


# contains
cat test.json | jq '.[]|select((.Tags[].Key|tostring)|(contains("Name") or contains("2")))|.'

# Get VPC ID and Stack name
aws ec2 describe-vpcs | jq '.Vpcs[]|select((.Tags|length) > 0)|[.VpcId,(.Tags[]|select(.Key=="aws:cloudformation:stack-name")).Value]|@tsv'

# Describe VPCs that have the Tags node
aws ec2 describe-vpcs | jq 'select(.Vpcs[].Tags?)'

# Describe VPCs that have the elemen Tags, and have the Key Name containing certain text
aws ec2 describe-vpcs  | jq '.Vpcs[]|select(.Tags?)|select(any(.Tags[]; .Key=="Name" and (.Value|contains("Pune")) ))'

# Select all the VPCs with no tags at all
aws ec2 describe-vpcs | jq '.Vpcs[]|select(.Tags?==null)'

# Get all the route tables associated with subnet with IGW access_key
aws ec2 describe-route-tables | jq '.RouteTables[]|select(.Associations[].SubnetId?!=null)|select((.Routes[].GatewayId|contains("igw")))'

# Count all the instances
aws ec2 describe-instances | jq '[.Reservations[].Instances[]|.InstanceId]|length'

# Get all the instances with Tag Owner/edgar.gonzalez
aws ec2 describe-instances | jq '.Reservations[].Instances[]|select(.Tags?)|select(any(.Tags[]; .Key=="Owner" and .Value=="edgar.gonzalez"))'

# Get all the instances with tag owner/edgar.gonzalez/Name and display InstanceId and Name
aws ec2 describe-instances | jq '.Reservations[].Instances[]|select(.Tags?)|select(any(.Tags[]; .Key=="Owner" and .Value=="edgar.gonzalez"))|select(.Tags[].Key=="Name")|[.InstanceId, (.Tags[]|select(.Key=="Name")).Value]|@tsv'

# Describe security groups that belongs to a VPC, display just description and security group id
aws ec2 describe-security-groups | jq '.SecurityGroups[]|select(.VpcId=="vpc-49c5bb2e")|[.Description, .GroupId]|@tsv'


# Get list of instances with .Tags[] elements, and list Tag Name, State and private IP associate-public-ip-address
aws ec2 describe-instances | jq '.Reservations[].Instances[]|select(.Tags?)|[(.Tags[]|select(.Key=="Name")).Value,.State.Name,.PrivateIpAddress]|@csv'

# Get list of active VPN connections
 aws ec2 describe-vpn-connections | jq '.VpnConnections[]|select(.State=="available")|[select(.Tags?)|(.Tags[]|select(.Key=="Name")).Value,.VpnGatewayId,.CustomerGatewayId,.State]|@csv'
