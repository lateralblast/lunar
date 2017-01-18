# audit_aws_password_policy
#
# Password policies are, in part, used to enforce password complexity
# requirements. IAM password policies can be used to ensure password
# are comprised of different character sets. It is recommended that
# the password policy require at least one uppercase letter.
#
# Setting a password complexity policy increases account resiliency
# against brute force login attempts.
#
# The policies should be set as follows:
# RequireUppercaseCharacters true
# RequireLowercaseCharacters true
# RequireSymbols true
# MinimumPasswordLength 14
# PasswordReusePrevention 24
# MaxPasswordAge 90
#
# Refer to Section(s) 1.5 Page(s)  19-20 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.6 Page(s)  21-22 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.7 Page(s)  23-24 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.8 Page(s)  25-26 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.9 Page(s)  27-28 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.10 Page(s) 29-30 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.11 Page(s) 31-32 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_password_policy () {
	policy=`aws iam get-account-password-policy 2> /dev/null`
	length=`echo "$pass_pol" |wc -l`
	total=`expr $total + 1`
	if [ "$length" = "0" ]; then
		insecure=`expr $insecure + 1`
    echo "Warning:   No password policy exists [$insecure Warnings]"
    funct_verbose_message "" fix
    funct_verbose_message "aws iam update-account-password-policy --require-uppercase-characters" fix
    funct_verbose_message "aws iam update-account-password-policy --require-lowercase-characters" fix
    funct_verbose_message "aws iam update-account-password-policy --require-symbols" fix
    funct_verbose_message "aws iam update-account-password-policy --require-numbers" fix
    funct_verbose_message "aws iam update-account-password-policy --minimum-password-length 14" fix
    funct_verbose_message "aws iam update-account-password-policy --password-reuse-prevention 24" fix
    funct_verbose_message "aws iam update-account-password-policy --max-password-age 90" fix
    funct_verbose_message "" fix
	else
    funct_aws_password_policy_check RequireUppercaseCharacters true "--require-uppercase-characters"
    funct_aws_password_policy_check RequireLowercaseCharacters true "--require-lowercase-characters"
    funct_aws_password_policy_check RequireSymbols true "--require-symbols"
    funct_aws_password_policy_check RequireNumbers true "--require-numbers"
    funct_aws_password_policy_check MinimumPasswordLength 14 "--minimum-password-length 14"
    funct_aws_password_policy_check PasswordReusePrevention 24 "--password-reuse-prevention 24"
    funct_aws_password_policy_check MaxPasswordAge 90 "--max-password-age 90"
	fi
}

