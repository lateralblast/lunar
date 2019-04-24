# audit_crypt_policy
#
# Set default cryptographic algorithms
#.

audit_crypt_policy () {
  if [ "$os_name" = "SunOS" ]; then
  	verbose_message "Cryptographic Algorithms"
    check_file="/etc/security/policy.conf"
    check_file_value is $check_file CRYPT_DEFAULT eq 6 hash
    check_file_value is $check_file CRYPT_ALGORITHMS_ALLOW eq 6 hash
  fi
}
