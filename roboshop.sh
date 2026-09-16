SG_ID="sg-0fb54d735c2e0463c"
AMI_ID="ami-0220d79f3f480ecf5"


for instance in $@
do 

    INSTANCE_ID=$( aws ec2 run-instances \
    --image-id @AMI_ID \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].INSTANCE_ID' \
    --output text )

    if [ $instance=="frontend" ]; then

        ip=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[*].Instances[*].PublicIpAddress' \
            --output text

        )
        else 
        ip=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[*].Instances[*].PrivateIpIpAddress' \
            --output text
        )    
    fi    

    echo "IPAddress: $ip"
done