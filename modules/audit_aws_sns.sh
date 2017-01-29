# audit_aws_sns
#
# Refer to Section(s) 3.15 Page(s) 129-30 CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/SNS/sns-topic-exposed.html
#.

audit_aws_sns () {
	topics=`aws sns list-topics --region $aws_region --query 'Topics[].TopicArn' --output text`
  for topic in $topics; do
    # Check SNS topics have subscribers
    total=`expr $total + 1`
    subscribers=`aws sns list-subscriptions-by-topic --region $aws_region --topic-arn $topic --output text`
    if [ ! "$subscribers" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   SNS topic $topic has no subscribers [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    SNS topic has subscribers, review subscribers [$secure Passes]"
    fi
    #check SNS topics are not publicly accessible
    total=`expr $total + 1`
    check=`aws sns get-topic-attributes --region $aws_region --topic-arn $topic --query 'Attributes.Policy'  |egrep "\*|{\"AWS\":\"\*\"}"`
    if [ "$check" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   SNS topic $topic is publicly accessible [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    SNS topic is not publicly accessible [$secure Passes]"
    fi
  done

}

