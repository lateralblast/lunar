# audit_aws_cf
#
# Ensure all your AWS CloudFormation stacks are using Simple Notification
# Service (AWS SNS) in order to receive notifications when an event occurs.
# Monitoring stack events such as create - which triggers the provisioning
# process based on a defined CloudFormation template, update – which updates
# the stack configuration or delete – which terminates the stack by removing
# its collection of AWS resources, will enable you to respond fast to any
# unauthorized action that could alter your AWS environment.
#
# With SNS integration you can increase the visibility of your AWS
# CloudFormation stack activity, beneficial for security and management
# purposes.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFormation/cloudformation-stack-notification.html
#
# Ensure your AWS CloudFormation stacks are using policies as a fail-safe
# mechanism in order to prevent accidental updates to stack resources.
# A CloudFormation stack policy is a JSON-based document that defines which
# actions can be performed on specified resources.
#
# With CloudFormation stack policies you can protect all or certain resources
# in your stacks from being unintentionally updated or deleted during the update
# process.
#
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

