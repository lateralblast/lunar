# audit_aws_ses
#
# Ensure DomainKeys Identified Mail (DKIM) feature is enabled within your AWS
# SES domains settings to protect both email senders and receivers against
# phishing attacks by using DKIM-signature headers to make sure that each
# message sent is authentic.
#
# By enabling DKIM signing for your AWS SES outgoing email messages you will
# demonstrate that these messages are legitimate and have not been modified in
# transit by spammers.
#
# Refer to https://www.cloudconformity.com/conformity-rules/SES/dkim-enabled.html
#.

audit_aws_ses () {
  # determine if your AWS Simple Email Service (SES) identities (domains and email addresses) are configured to use DKIM signatures
  domains=`aws ses list-identities --region $aws_region --query Identities --output text 2> /dev/null`
  for domain in $domains; do
    check=`aws ses get-identity-dkim-attributes --region $aws_region --identities $domain |grep DkimEnabled |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Domain $domain has DKIM enabled [$secure Passes]" 
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Domain $domain does not have DKIM enabled [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "aws ses set-identity-dkim-enabled --region $aws_region --identity $domain --dkim-enabled" fix
      funct_verbose_message "" fix
    fi
  done
}

