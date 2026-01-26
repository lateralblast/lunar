#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_crypt_policy
#
# Set default cryptographic algorithms
#.

audit_crypt_policy () {
  print_function "audit_crypt_policy"
  if [ "${os_name}" = "SunOS" ]; then
  	verbose_message  "Cryptographic Algorithms"        "check"
    check_file_value "is" "/etc/security/policy.conf"   "CRYPT_DEFAULT"          "eq" "6" "hash"
    check_file_value "is" "/etc/security/policy.conf"   "CRYPT_ALGORITHMS_ALLOW" "eq" "6" "hash"
  fi
}
