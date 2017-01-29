# audit_aws_cdn
#
# Ensure that all your AWS CloudFront web distributions are integrated with the
# Web Application Firewall (AWS WAF) service to protect against application-
# layer attacks that can compromise the security of your web applications or
# place unnecessary load on them.
#
# With AWS Cloudfront – WAF integration enabled you will be able to block any
# malicious requests made to your Cloudfront Content Delivery Network based on
# the criteria defined in the WAF Web Access Control List (ACL) associated with
# the CDN distribution.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-integrated-with-waf.html
# 
# Ensure that your AWS Cloudfront distributions have the Logging feature enabled
# in order to track all viewer requests for the content delivered through the
# Content Delivery Network (CDN).
#
# The Cloudfront access logs contain detailed information (requested object
# name, date and time of the access, client IP, access point, error code, etc)
# about each request made for your web content, information that can be
# extremely useful during security audits or as input data for various
# analytics/reporting tools. You can also use this feature in combination with
# AWS Lambda and AWS WAF to process the logging data and block the requests
# coming from those IP addresses that generate too many error codes as the
# requests that generate these errors are often made by attackers trying to
# find vulnerabilities within your website/web application.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-logging-enabled.html
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
  done
}

