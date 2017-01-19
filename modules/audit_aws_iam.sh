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
# Refer to Section(s) 1.1  Page(s) 10-1  CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.18 Page(s) 46-57 CIS AWS Foundations Benchmark v1.1.0
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
	total=`expr $total + 1`
	check=`aws iam get-role --role-name $aws_iam_master_role 2> /dev/null`
	if [ "$check" ]; then 
		secure=`expr $secure + 1`
    echo "Secure:    IAM Master role $aws_iam_master_role exists [$secure Passes]"
	else
		insecure=`expr $insecure + 1`
    echo "Warning:   IAM Master role $aws_iam_master_role does not exist [$insecure Warnings]"
    funct_verbose_message "" fix
    funct_verbose_message "cd aws" fix
    funct_verbose_message "aws iam create-role --role-name $aws_iam_master_role --assume-role-policy-document file://account-creation-policy.json" fix
    funct_verbose_message "aws iam put-role-policy --role-name $aws_iam_master_role --policy-name $aws_iam_master_role --policy-document file://iam-master-policy.json" fix
    funct_verbose_message "" fix
	fi
	total=`expr $total + 1`
	check=`aws iam get-role --role-name $aws_iam_manager_role 2> /dev/null`
	if [ "$check" ]; then 
		secure=`expr $secure + 1`
    echo "Secure:    IAM Manager role $aws_iam_manager_role exists [$secure Passes]"
	else
		insecure=`expr $insecure + 1`
    echo "Warning:   IAM Manager role $aws_iam_manager_role does not exist [$insecure Warnings]"
    funct_verbose_message "" fix
    funct_verbose_message "cd aws" fix
    funct_verbose_message "aws iam create-role --role-name $aws_iam_master_role --assume-role-policy-document file://account-creation-policy.json" fix
    funct_verbose_message "aws iam put-role-policy --role-name $aws_iam_manager_role --policy-name $aws_iam_manager_role --policy-document file://iam-manager-policy.json" fix
    funct_verbose_message "" fix
	fi
}

