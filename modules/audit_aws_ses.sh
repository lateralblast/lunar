# audit_aws_ses
#
# Refer to https://www.cloudconformity.com/conformity-rules/SES/dkim-enabled.html
#.

audit_aws_ses () {
  # determine if your AWS Simple Email Service (SES) identities (domains and email addresses) are configured to use DKIM signatures
  domains=`aws ses list-identities --region $aws_region --query Identities --output text 2> /dev/null`
  for domain in $domains; do
    total=`expr $total + 1`
    check=`aws ses get-identity-dkim-attributes --region $aws_region --identities $domain |grep DkimEnabled |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Domain $domain has DKIM enabled [$secure Passes]" 
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Domain $domain does not have DKIM enabled [$insecure Warnings]"
      verbose_message "" fix
      verbose_message "aws ses set-identity-dkim-enabled --region $aws_region --identity $domain --dkim-enabled" fix
      verbose_message "" fix
    fi
  done
}

