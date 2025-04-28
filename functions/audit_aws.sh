#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_aws () {
  audit_mode=$1
  check_environment
  check_aws
  audit_aws_all
  print_results
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_aws_rec () {
  audit_mode=$1
  check_environment
  check_aws
  audit_aws_rec_all
  print_results
}

# audit_aws_all
#
# Audit AWS
#
# Run various AWS audit tests
# 
# This requires the AWS CLI to be installed and configured
#.

audit_aws_all () {
  audit_aws_iam
  audit_aws_mfa
  audit_aws_access_keys
  audit_aws_creds
  audit_aws_iam_policies
  audit_aws_password_policy
  audit_aws_support_role
  audit_aws_monitoring
  audit_aws_logging
  audit_aws_keys
  audit_aws_config
  audit_aws_sns
  audit_aws_vpcs
  audit_aws_sgs
  audit_aws_certs
  audit_aws_dns
  audit_aws_ec2
  audit_aws_es
  audit_aws_elb
  audit_aws_s3
  audit_aws_ses
  audit_aws_rds
  audit_aws_cf
  audit_aws_ec
  audit_aws_cdn
  audit_aws_redshift
  audit_aws_inspector
}
