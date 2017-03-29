

# Create a keypair from CLI
aws ec2 create-key-pair --key-name td-code-challenge | jq -r '.KeyMaterial' > td-code-challenge.pm
