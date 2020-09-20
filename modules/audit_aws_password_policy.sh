# audit_aws_password_policy
#
# Refer to Section(s) 1.5 Page(s)  19-20 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.6 Page(s)  21-22 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.7 Page(s)  23-24 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.8 Page(s)  25-26 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.9 Page(s)  27-28 CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.10 Page(s) 29-verbose_message " CIS AWS Foundations Benchmark v1.1.0
# Refer to Section(s) 1.11 Page(s) 31-32 CIS AWS Foundations Benchmark v1.1.0
#.

audit_aws_password_policy () {
  verbose_message "Password Policy"
  policy=$( aws iam get-account-password-policy 2> /dev/null )
  length=$( echo "$policy" | wc -l )
  if [ "$length" = "0" ]; then
    increment_insecure "No password policy exists"
    verbose_message "" fix
    verbose_message "aws iam update-account-password-policy --require-uppercase-characters" fix
    verbose_message "aws iam update-account-password-policy --require-lowercase-characters" fix
    verbose_message "aws iam update-account-password-policy --require-symbols" fix
    verbose_message "aws iam update-account-password-policy --require-numbers" fix
    verbose_message "aws iam update-account-password-policy --minimum-password-length 14" fix
    verbose_message "aws iam update-account-password-policy --password-reuse-prevention 24" fix
    verbose_message "aws iam update-account-password-policy --max-password-age 90" fix
    verbose_message "" fix
  else
    check_aws_password_policy RequireUppercaseCharacters true "--require-uppercase-characters"
    check_aws_password_policy RequireLowercaseCharacters true "--require-lowercase-characters"
    check_aws_password_policy RequireSymbols true "--require-symbols"
    check_aws_password_policy RequireNumbers true "--require-numbers"
    check_aws_password_policy MinimumPasswordLength 14 "--minimum-password-length 14"
    check_aws_password_policy PasswordReusePrevention 24 "--password-reuse-prevention 24"
    check_aws_password_policy MaxPasswordAge 90 "--max-password-age 90"
  fi
}

