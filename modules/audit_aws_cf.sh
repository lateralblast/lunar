# audit_aws_cf
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFormation/cloudformation-stack-notification.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFormation/cloudformation-stack-policy.html
#.

audit_aws_cf () {
  # Check Cloud Formation stacks are using SNS
  stacks=`aws cloudformation list-stacks --region $aws_region --query 'StackSummaries[].StackId' --output text` 
  for stack in $stacks; do 
    total=`expr $total + 1`
    check=`aws cloudformation describe-stacks --region $aws_region --stack-name $stack --query 'Stack[].NotificationARNs' --output text`
    stack=`echo "$stack" |cut -f2 -d/`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    SNS topic exists for CloudFormation stack $stack [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   SNS topic does not exist for CloudFormation stack $stack [$insecure Warnings]"
    fi
  done
  # Check stacks have a policy
  stacks=`aws cloudformation list-stacks --region $aws_region --query 'StackSummaries[].StackName' --output text`
    for stack in $stacks; do 
    total=`expr $total + 1`
    check=`aws cloudformation get-stack-policy --region $aws_region --stack-name $stack --query 'StackPolicyBody' --output text 2> /dev/null`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    CloudFormation stack $stack has a policy [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   CloudFormation stack $stack does not have a policy [$insecure Warnings]"
    fi
  done
}

