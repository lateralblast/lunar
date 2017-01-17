# funct_audit_aws_all
#
# Audit AWS
#
# Run various AWS audit tests
# 
# This requires the AWS CLI to be installed and configured
#.

funct_audit_aws_all () {
	audit_aws_iam
  audit_aws_mfa
}