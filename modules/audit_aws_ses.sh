# audit_aws_ses
#
# Refer to https://www.cloudconformity.com/conformity-rules/SES/dkim-enabled.html
#.

audit_aws_ses () {
  verbose_message "SES"
  # determine if your AWS Simple Email Service (SES) identities (domains and email addresses) are configured to use DKIM signatures
  domains=$( aws ses list-identities --region $aws_region --query Identities --output text 2> /dev/null )
  for domain in $domains; do
    check=$( aws ses get-identity-dkim-attributes --region $aws_region --identities $domain | grep DkimEnabled | grep true )
    if [ "$check" ]; then
      increment_secure "Domain $domain has DKIM enabled" 
    else
      increment_insecure "Domain $domain does not have DKIM enabled"
      verbose_message "" fix
      verbose_message "aws ses set-identity-dkim-enabled --region $aws_region --identity $domain --dkim-enabled" fix
      verbose_message "" fix
    fi
  done
}

