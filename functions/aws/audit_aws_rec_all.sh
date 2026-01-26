#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# Audit AWS
#
# Run various AWS audit recommended tests
#
# This comes from sources like Cloud Conformity
#
# https://www.cloudconformity.com/conformity-rules/
# 
# This requires the AWS CLI to be installed and configured
#.

audit_aws_rec_all () {
  print_function "audit_aws_rec_all"
  audit_aws_rec_ec2
  audit_aws_rec_es
  audit_aws_rec_dynamodb
  audit_aws_rec_elb
  audit_aws_rec_vpcs
  audit_aws_rec_rds
  audit_aws_rec_ec
  audit_aws_rec_monitoring
  audit_aws_rec_redshift
  audit_aws_rec_inspector
}

