# audit_aws_cdn
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-integrated-with-waf.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-insecure-origin-ssl-protocols.html
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-traffic-to-origin-unencrypted.html
#.

audit_aws_cdn () {
  aws configure set preview.cloudfront true
  cdns=`aws cloudfront list-distributions --query 'DistributionList.Items[].Id' |grep -v null` 
  for cdn in $cdns; do 
    # Check Cloudfront is using WAF
    total=`expr $total + 1`
    check=`aws aws cloudfront get-distribution --id $cdn --query 'Distribution.DistributionConfig.WebACLId' --output text`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Cloudfront $cdn is WAF integration enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Cloudfront $cdn is not WAF integration enabled [$insecure Warnings]"
    fi
    # Check logging is enabled
    total=`expr $total + 1`
    check=`aws aws cloudfront get-distribution --id $cdn --query 'Distribution.DistributionConfig.Logging' |grep Enabled |grep true`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Cloudfront $cdn has logging enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Cloudfront $cdn does not have logging enabled [$insecure Warnings]"
    fi
    # check SSL protocol versions being used against deprecated ones
    total=`expr $total + 1`
    check=`aws aws cloudfront get-distribution --id $cdn --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginSslProtocols.Items' |egrep "SSLv3|SSLv2"`
    if [ ! "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Cloudfront $cdn is not using a deprecated version of SSL [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Cloudfront $cdn is using a deprecated verions of SSL [$insecure Warnings]"
    fi
    # check if HTTP only being used 
    total=`expr $total + 1`
    check=`aws aws cloudfront get-distribution --id $cdn --query 'Distribution.DistributionConfig.Origins.Items[].CustomOriginConfig.OriginProtocolPolicy' |egrep "http-only"`
    if [ ! "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Cloudfront $cdn is not using HTTP only [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Cloudfront $cdn is using HTTP only [$insecure Warnings]"
    fi
  done
}

