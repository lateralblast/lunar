# audit_aws_iam
#
# The "root" account has unrestricted access to all resources in the AWS account.
# It is highly recommended that the use of this account be avoided.
# 
# The "root" account has unrestricted access to all resources in the AWS account.
# It is highly recommended that the use of this account be avoided.
# Ensure a log metric filter and alarm exist for usage of "root" account.
#
# http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
#
# Refer to Section(s) 1.1 Page(s) 10-1 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_iam () {
	aws iam generate-credential-report 2>&1 > /dev/null
	date_test=`date +%Y-%m`
	last_login=`aws iam get-credential-report --query 'Content' --output text | $base_d | cut -d, -f1,5,11,16 | grep -B1 '<root_account>' |cut -f2 -d, |cut -f1,2 -d- |grep '[0-9]'`
	total=`expr $total + 1`
	if [ "$date_test" = "$last_login" ]; then
		insecure=`expr $insecure + 1`
    echo "Warning:   Root account appears to be being used regularly [$insecure Warnings]"
	else
		secure=`expr $secure + 1`
    echo "Secure:    Root account does not appear to be being used frequently [$secure Passes]"
	fi
}

