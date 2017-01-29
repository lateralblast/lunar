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
#.

audit_aws_cdn () {
  # Check Cloudfront is using WAF
  aws configure set preview.cloudfront true
  cdns=`aws cloudfront list-distributions --query 'DistributionList.Items[].Id' |grep -v null` 
  for cdn in $cdns; do 
    total=`expr $total + 1`
    check=`aws aws cloudfront get-distribution --id $cdn --query 'Distribution.DistributionConfig.WebACLId' --output text`
    if [ "$check" ]; then
      secure=`expr $secure + 1`
      echo "Secure:    Cloudfront $cdn is WAF integration enabled [$secure Passes]"
    else
      insecure=`expr $insecure + 1`
      echo "Warning:   Cloudfront $cdn is not WAF integration enabled [$insecure Warnings]"
    fi
  done
}

