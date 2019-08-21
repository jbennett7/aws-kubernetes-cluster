#!/bin/bash
function generate_user_data {
    cat <<EOF > /tmp/userdata.sh
EOF
}
COUNT=1
IMAGE_ID=$(aws ec2 describe-images \
    --filter Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64* \
    --query 'Images[*].[ImageId,CreationDate]' \
    --output text |
    awk 'NR==1{print $1}')
VPC_ID=$(aws ec2 describe-vpcs \
    --filter Name=isDefault,Values=true \
    --query "Vpcs[0].VpcId" \
    --output text)
SUBNET_ID=$(aws ec2 describe-subnets \
    --filter Name=vpc-id,Values=${VPC_ID} \
    --query "Subnets[0].SubnetId" \
    --output text)
SECURITY_GROUP=$(aws ec2 describe-security-groups \
    --filter Name=vpc-id,Values=${VPC_ID} \
    --query "SecurityGroups[?GroupName=='all'].GroupId" \
    --output text)
INSTANCE_TYPE="t2.micro"
KEY_NAME="contino-default-virginia"
INSTANCES=$(aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --count ${COUNT} \
    --instance-type ${INSTANCE_TYPE} \
    --key-name ${KEY_NAME} \
    --subnet-id ${SUBNET_ID})
echo ${INSTANCES}
