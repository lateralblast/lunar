#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_certs
#
# Check AWS Certificates
#
# Refer to https://www.cloudconformity.com/conformity-rules/IAM/expired-ssl-tls-certificate.html
#.

audit_aws_certs () {
  print_function  "audit_aws_certs"
  verbose_message "Certificates" "check"
  command="aws iam list-server-certificates --region \"${aws_region}\" --query \"ServerCertificateMetadataList[].ServerCertificateName\" --output text"
  command_message "${command}"
  certs=$( eval "${command}" )
  command="date \"+%Y-%m-%dT%H:%M:%SS\""
  command_message "${command}"
  cur_date=$( eval "${command}" )
  if [ "${os_name}" = "Linux" ]; then
    command="date -d \"${cur_date}\" \"+%s\""
    command_message "${command}"
    cur_secs=$( eval "${command}" )
  else
    command="date -j -f \"%Y-%m-%dT%H:%M:%SS\" \"${cur_date}\" \"+%s\""
    command_message "${command}"
    cur_secs=$( eval "${command}" )
  fi
  for cert in ${certs}; do
    command="aws iam get-server-certificate --server-certificate-name \"${cert}\" --query \"ServerCertificate.ServerCertificateMetadata.Expiration\" --output text"
    command_message "${command}"
    exp_date=$( eval "${command}" )
    if [ "${os_name}" = "Linux" ]; then
      command="date -d \"${exp_date}\" \"+%s\""
      command_message "${command}"
      exp_secs=$( eval "${command}" )
    else
      command="date -j -f \"%Y-%m-%dT%H:%M:%SZ\" \"${exp_date}\" \"+%s\""
      command_message "${command}"
      exp_secs=$( eval "${command}" )
    fi
    if [ "${exp_secs}" -lt "${cur_secs}" ]; then
      increment_insecure "Certificate \"${cert}\" has expired"
    else
      increment_secure   "Certificate \"${cert}\" has not expired"
    fi
  done
}
