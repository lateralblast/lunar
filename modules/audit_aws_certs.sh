# audit_aws_certs
#
# Ensure that all the expired SSL/TLS certificates stored in AWS IAM are
# removed in order to follow IAM security best practices.
#
# Removing expired SSL/TLS certificates eliminates the risk that an
# invalid certificate will be deployed accidentally to a resource such as AWS
# Elastic Load Balancer (ELB), which will trigger font-end errors and damage
# the credibility of the application/website behind the ELB.
#
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/expired-ssl-tls-certificate.html
#.

audit_aws_certs () {
  certs=`aws iam list-server-certificates --region $aws_region --query "ServerCertificateMetadataList[].ServerCertificateName" --output text`
  cur_date=`date "+%Y-%m-%dT%H:%M:%SS"`
  cur_secs=`date -j -f "%Y-%m-%dT%H:%M:%SS" "$cur_date" "+%s"`
  for cert in $certs; do
    total=`expr $total + 1`
  	exp_date=`aws iam get-server-sertificate --certificate-name $cert --query "ServerCertificateMetadataList[].Expiration" --output text`
    exp_secs=`date -j -f "%Y-%m-%dT%H:%M:%SS" "$exp_date" "+%s"`
    if [ "$exp_secs" -lt "$cur_secs" ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Certificate $cert has expired [$insecure Warnings]"
    else
      secure=`expr $secure + 1`
      echo "Secure:    Certificate $cert has not expired [$secure Passes]"
    fi
  done
}

