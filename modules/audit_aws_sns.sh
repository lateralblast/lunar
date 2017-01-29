# audit_aws_sns
#
# AWS Simple Notification Service (SNS) is a web service that can publish
# messages from an application and immediately deliver them to subscribers
# or other applications. Subscribers are clients interested in receiving
# notifications from topics of interest; they can subscribe to a topic or be
# subscribed by the topic owner. When publishers have information or updates
# to notify their subscribers about, they can publish a message to the topic
# which immediately triggers Amazon SNS to deliver the message to all
# applicable subscribers. It is recommended that the list of subscribers to
# given topics be periodically reviewed for appropriateness.
#
# Reviewing subscriber topics will help ensure that only expected recipients
# receive information published to SNS topics.
#
# Refer to Section(s) 3.15 Page(s) 129-30 CIS AWS Foundations Benchmark v1.1.0
#
# Identify any publicly accessible SNS topics and implement the necessary
# permissions in order to protect them against attackers or unauthorized
# personnel.
#
# Setting accidentally (or intentionally) overly permissive policies for your
# SNS topics can allow unauthorized users to receive/publish messages and
# subscribe to the exposed topics. One common scenario is when a root user
# grants permissions for an SNS topic to the "Everyone" grantee while testing
# the notification system and forgets about the insecure set of permissions
# applied during the testing stage.
#
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

