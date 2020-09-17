# audit_aws_cf
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFormation/cloudformation-stack-notification.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFormation/cloudformation-stack-policy.html
#.

audit_aws_cf () {
  # Check Cloud Formation stacks are using SNS
  verbose_message "CloudFormation"
  stacks=$( aws cloudformation list-stacks --region $aws_region --query 'StackSummaries[].StackId' --output text )
  for stack in $stacks; do 
    check=$( aws cloudformation describe-stacks --region $aws_region --stack-name $stack --query 'Stack[].NotificationARNs' --output text )
    stack=$( echo "$stack" | cut -f2 -d/ )
    if [ "$check" ]; then
      increment_secure "SNS topic exists for CloudFormation stack $stack"
    else
      increment_insecure "SNS topic does not exist for CloudFormation stack $stack"
    fi
  done
  # Check stacks have a policy
  stacks=$( aws cloudformation list-stacks --region $aws_region --query 'StackSummaries[].StackName' --output text )
    for stack in $stacks; do 
    check=$( aws cloudformation get-stack-policy --region $aws_region --stack-name $stack --query 'StackPolicyBody' --output text 2> /dev/null )
    if [ "$check" ]; then
      increment_secure "CloudFormation stack $stack has a policy"
    else
      increment_insecure "CloudFormation stack $stack does not have a policy"
    fi
  done
}

