# audit_aws_certs
#
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/expired-ssl-tls-certificate.html
#.

audit_aws_certs () {
  verbose_message "Certificates"
  certs=$( aws iam list-server-certificates --region $aws_region --query "ServerCertificateMetadataList[].ServerCertificateName" --output text )
  cur_date=$( date "+%Y-%m-%dT%H:%M:%SS" )
  if [ "$os_name" = "Linux" ]; then
    cur_secs=$( date -d "$cur_date" "+%s" )
  else
    cur_secs=$( date -j -f "%Y-%m-%dT%H:%M:%SS" "$cur_date" "+%s" )
  fi
  for cert in $certs; do
  	exp_date=$( aws iam get-server-certificate --server-certificate-name $cert --query "ServerCertificate.ServerCertificateMetadata.Expiration" --output text )
    if [ "$os_name" = "Linux" ]; then
      exp_secs=$( date -d "$exp_date" "+%s" )
    else
      exp_secs=$( date -j -f "%Y-%m-%dT%H:%M:%SZ" "$exp_date" "+%s" )
    fi
    if [ "$exp_secs" -lt "$cur_secs" ]; then
      increment_insecure "Certificate $cert has expired"
    else
      increment_secure "Certificate $cert has not expired"
    fi
  done
}
