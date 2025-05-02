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
  verbose_message "Cloudfront" "check"
  aws configure set preview.cloudfront true
  cdns=$( aws cloudfront list-distributions --query 'DistributionList.Items[].Id' --output text | grep -v null )
  for cdn in ${cdns}; do 
    # Check Cloudfront is using WAF
    check=$( aws cloudfront get-distribution --id "${cdn}" --query 'Distribution.DistributionConfig.WebACLId' --output text )
    if [ "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" is WAF integration enabled"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" is not WAF integration enabled"
    fi
    # Check logging is enabled
    check=$( aws cloudfront get-distribution --id "${cdn}" --query 'Distribution.DistributionConfig.Logging.Enabled' | grep true )
    if [ "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" has logging enabled"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" does not have logging enabled"
    fi
    # check SSL protocol versions being used against deprecated ones
    check=$( aws cloudfront get-distribution --id "${cdn}" --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginSslProtocols.Items' | grep -E "SSLv3|SSLv2" )
    if [ ! "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" is not using a deprecated version of SSL"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" is using a deprecated verions of SSL"
    fi
    # check if HTTP only being used 
    check=$( aws cloudfront get-distribution --id "${cdn}" --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginProtocolPolicy' | grep -E "http-only" )
    if [ ! "${check}" ]; then
      increment_secure   "Cloudfront CDN \"${cdn}\" is not using HTTP only"
    else
      increment_insecure "Cloudfront CDN \"${cdn}\" is using HTTP only"
    fi
  done
}

