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
#
# Ensure that your AWS Cloudfront Content Delivery Network distributions are
# not using insecure SSL protocols (i.e. SSLv3) for HTTPS communication between
# CloudFront edge locations and your custom origins. Cloud Conformity strongly
# recommends using TLSv1.0 or later (ideally use only TLSv1.2 if you origins
# support it) and avoid using the SSLv3 protocol.
#
# Using insecure and deprecated SSL protocols for your Cloudfront distributions
# could make the connection between the Cloudfront CDN and the origin server
# vulnerable to exploits such as POODLE (Padding Oracle on Downgraded Legacy
# Encryption) which allows an attacker to eavesdrop your Cloudfront traffic
# over a secure channel (encrypted with the SSLv3 protocol) by implementing
# a man-in-the-middle tactic.
#
# Refer to https://www.cloudconformity.com/conformity-rules/CloudFront/cloudfront-insecure-origin-ssl-protocols.html
#
# Ensure that the communication between your AWS CloudFront distributions and
# their custom origins is encrypted using HTTPS in order to secure the delivery
# of your web content and fulfill compliance requirements for data in transit
# encryption.
#
# Using HTTPS for your AWS Cloudfront distributions can offer you the guarantee
# that the encrypted traffic between the edge servers and the custom origin
# cannot be unsealed by malicious users in case they are able to capture
# packets sent across Cloudfront Content Distribution Network (CDN).
#
# Note: This rule does not apply if you have an AWS S3 bucket configured as
# website endpoint because the S3 service does not support HTTPS connections
# in this particular configuration.
#
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

