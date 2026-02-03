#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aws_cdn
#
# Check AWS Cloudfront
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-integrated-with-waf.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-insecure-origin-ssl-protocols.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-traffic-to-origin-unencrypted.html
#.

audit_aws_cdn () {
  print_function  "audit_aws_cdn"
  verbose_message "Cloudfront"  "check"
  aws configure set preview.cloudfront true
  command="aws cloudfront list-distributions --query 'DistributionList.Items[].Id' --output text | grep -v null"
  command_message "${command}"
  cdns=$( eval "${command}" )
  for cdn in ${cdns}; do 
    # Check Cloudfront is using WAF
    command="aws cloudfront get-distribution --id \"${cdn}\" --query 'Distribution.DistributionConfig.WebACLId' --output text"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" is WAF integration enabled"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" is not WAF integration enabled"
    fi
    # Check logging is enabled
    command="aws cloudfront get-distribution --id \"${cdn}\" --query 'Distribution.DistributionConfig.Logging.Enabled' | grep true"
    command_message "${command}"
    check=$( eval "${command}" )
    if [ "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" has logging enabled"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" does not have logging enabled"
    fi
    # check SSL protocol versions being used against deprecated ones
    command="aws cloudfront get-distribution --id \"${cdn}\" --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginSslProtocols.Items' | grep -E \"SSLv3|SSLv2\""
    command_message "${command}"
    check=$( eval "${command}" )
    if [ ! "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" is not using a deprecated version of SSL"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" is using a deprecated verions of SSL"
    fi
    # check if HTTP only being used 
    command="aws cloudfront get-distribution --id \"${cdn}\" --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginProtocolPolicy' | grep -E \"http-only\""
    command_message "${command}"
    check=$( eval "${command}" )
    if [ ! "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" is not using HTTP only"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" is using HTTP only"
    fi
  done
}

