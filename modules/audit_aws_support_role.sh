# audit_aws_support_role
#
# Refer to Section(s) 1.22 Page(s) 64-5 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_support_role () {
  arn=`aws iam list-policies --query "Policies[?PolicyName == 'AWSSupportAccess']" |grep Arn | awk -F': ' '{print $2}' |sed "s/ //g" |sed "s/,//g" |sed "s/\"//g"`
  roles=`aws iam list-entities-for-policy --policy-arn "$arn" |grep PolicyRoles |cut -f2 -d:`
  users=`aws iam list-entities-for-policy --policy-arn "$arn" |grep PolicyGroups |cut -f2 -d:`
  groups=`aws iam list-entities-for-policy --policy-arn "$arn" |grep PolicyUsers |cut -f2 -d:`
  total=`expr $total + 1`
	if [ ! $roles ] && [ ! $users ] && [ ! $groups ]; then
    secure=`expr $secure + 1`
    echo "Secure:    A support role has been created to manage incidents [$secure Passes]"
	else
    insecure=`expr $insecure + 1`
    echo "Warning:   There is no support role to manage incidents [$insecure Warnings]"
	fi
}

