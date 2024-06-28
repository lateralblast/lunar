#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_aws_sns
#
# Check AWS SNS
# 
# Refer to Section(s) 3.15 Page(s) 129-verbose_message " CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/SNS/sns-topic-exposed.html
#.

audit_aws_sns () {
  verbose_message "SNS" "check"
  topics=$( aws sns list-topics --region "$aws_region" --query 'Topics[].TopicArn' --output text )
  for topic in $topics; do
    # Check SNS topics have subscribers
    subscribers=$( aws sns list-subscriptions-by-topic --region "$aws_region" --topic-arn "$topic" --output text )
    if [ -z "$subscribers" ]; then
      increment_insecure "SNS topic \"$topic\" has no subscribers"
    else
      increment_secure   "SNS topic has subscribers, review subscribers"
    fi
    #check SNS topics are not publicly accessible
    check=$( aws sns get-topic-attributes --region "$aws_region" --topic-arn "$topic" --query 'Attributes.Policy'  |grep -E "\*|{\"AWS\":\"\*\"}" )
    if [ -n "$check" ]; then
      increment_insecure "SNS topic \"$topic\" is publicly accessible"
    else
      increment_secure   "SNS topic is not publicly accessible"
    fi
  done
}

