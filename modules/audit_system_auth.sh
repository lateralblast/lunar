#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_auth
#
# Check system auth settings
#
# Refer to Section(s) 6.3.1   Page(s) 160-1  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.3.5-6 Page(s) 163-5  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 5.3.1-2 Page(s) 238-41 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.3.1-2 Page(s) 220-1  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.3.1-4 Page(s) 232-6  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_system_auth () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "PAM Authentication" "check"
    check=0
    if [ "${os_vendor}" = "Amazon" ] && [ "${os_version}" = "2016" ]; then
      check=1
    fi
    if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 16 ]; then
      check=1
    fi
    if [ "${check}" -eq 1 ]; then
      check_file_value "is" "/etc/security/pwquality.conf" "minlen"  "eq" "14" "hash" 
      check_file_value "is" "/etc/security/pwquality.conf" "dcredit" "eq" "-1" "hash" 
      check_file_value "is" "/etc/security/pwquality.conf" "ocredit" "eq" "-1" "hash" 
      check_file_value "is" "/etc/security/pwquality.conf" "ucredit" "eq" "-1" "hash" 
      check_file_value "is" "/etc/security/pwquality.conf" "lcredit" "eq" "-1" "hash" 
      audit_system_auth_nullok
      audit_system_auth_unlock_time      "auth"     "unlock_time" "900"
      audit_system_auth_password_history "account"  "remember"    "5"
      audit_system_auth_password_hashing "password" "${password_hashing}"
    else
      if [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "CentOS" ] && [ "${os_version}" = "7" ]; then
        check_file_value "is" "/etc/security/pwquality.conf" "minlen"  "eq" "14" "hash"  
        check_file_value "is" "/etc/security/pwquality.conf" "dcredit" "eq" "-1" "hash"  
        check_file_value "is" "/etc/security/pwquality.conf" "ocredit" "eq" "-1" "hash"  
        check_file_value "is" "/etc/security/pwquality.conf" "ucredit" "eq" "-1" "hash"  
        check_file_value "is" "/etc/security/pwquality.conf" "lcredit" "eq" "-1" "hash"  
        audit_system_auth_nullok
        audit_system_auth_unlock_time      "auth"     "unlock_time" "900"
        audit_system_auth_password_history "account"  "remember"    "5"
        audit_system_auth_password_hashing "password" "${password_hashing}"
      else
        if [ "${audit_mode}" != 2 ]; then
          audit_system_auth_nullok
          audit_system_auth_password_history  "account"  "remember"   "10"
          audit_system_auth_password_policy   "password" "minlen"     "9"
          audit_system_auth_password_policy   "password" "dcredit"    "-1"
          audit_system_auth_password_policy   "password" "lcredit"    "-1"
          audit_system_auth_password_policy   "password" "ocredit"    "-1"
          audit_system_auth_password_policy   "password" "ucredit"    "-1"
          audit_system_auth_unlock_time       "auth"     "unlock_time" "900"
          audit_system_auth_account_reset     "account"  "reset"
          audit_system_auth_password_strength "password" "16,12,8"
          audit_system_auth_no_magic_root     "auth"     "no_magic_root"
        fi
      fi
    fi
  fi
}
