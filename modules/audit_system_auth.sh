# audit_system_auth
#
# Refer to Section(s) 6.3.1   Page(s) 160-1  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.3.5-6 Page(s) 163-5  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 5.3.1-2 Page(s) 238-41 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.3.1-2 Page(s) 220-1  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.3.1-4 Page(s) 232-6  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_system_auth () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "PAM Authentication"
    check=0
    if [ "$os_vendor" = "Amazon" ] && [ "$os_version" = "2016" ]; then
      check=1
    fi
    if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 16 ]; then
      check=1
    fi
    if [ "$check" -eq 1 ]; then
      check_file="/etc/security/pwquality.conf"
      check_file_value is $check_file minlen eq 14 hash  
      check_file_value is $check_file dcredit eq "-1" hash  
      check_file_value is $check_file ocredit eq "-1" hash  
      check_file_value is $check_file ucredit eq "-1" hash  
      check_file_value is $check_file lcredit eq "-1" hash  
      audit_system_auth_nullok
      auth_string="auth"
      search_string="unlock_time"
      search_value="900"
      audit_system_auth_unlock_time $auth_string $search_string $search_value
      auth_string="account"
      search_string="remember"
      search_value="5"
      audit_system_auth_password_history $auth_string $search_string $search_value
      auth_string="password"
      search_string="sha512"
      audit_system_auth_password_hashing $auth_string $search_string
    else
      if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "CentOS" ] && [ "$os_version" = "7" ]; then
        check_file="/etc/security/pwquality.conf"
        check_file_value is $check_file minlen eq 14 hash  
        check_file_value is $check_file dcredit eq "-1" hash  
        check_file_value is $check_file ocredit eq "-1" hash  
        check_file_value is $check_file ucredit eq "-1" hash  
        check_file_value is $check_file lcredit eq "-1" hash  
        audit_system_auth_nullok
        auth_string="auth"
        search_string="unlock_time"
        search_value="900"
        audit_system_auth_unlock_time $auth_string $search_string $search_value
        auth_string="account"
        search_string="remember"
        search_value="5"
        audit_system_auth_password_history $auth_string $search_string $search_value
        auth_string="password"
        search_string="sha512"
        audit_system_auth_password_hashing $auth_string $search_string
      else
        check_rpm libpam-cracklib
        if [ "$audit_mode" != 2 ]; then
          audit_system_auth_nullok
          auth_string="account"
          search_string="remember"
          search_value="10"
          audit_system_auth_password_history $auth_string $search_string $search_value
          auth_string="auth"
          search_string="no_magic_root"
          audit_system_auth_no_magic_root $auth_string $search_string
          auth_string="account"
          search_string="reset"
          audit_system_auth_account_reset $auth_string $search_string
          auth_string="password"
          search_string="minlen"
          search_value="9"
          audit_system_auth_password_policy $auth_string $search_string $search_value
          auth_string="password"
          search_string="dcredit"
          search_value="-1"
          audit_system_auth_password_policy $auth_string $search_string $search_value
          auth_string="password"
          search_string="lcredit"
          search_value="-1"
          audit_system_auth_password_policy $auth_string $search_string $search_value
          auth_string="password"
          search_string="ocredit"
          search_value="-1"
          audit_system_auth_password_policy $auth_string $search_string $search_value
          auth_string="password"
          search_string="ucredit"
          search_value="-1"
          audit_system_auth_password_policy $auth_string $search_string $search_value
          auth_string="password"
          search_string="16,12,8"
          audit_system_auth_password_strength $auth_string $search_string
          auth_string="auth"
          search_string="unlock_time"
          search_value="900"
          audit_system_auth_unlock_time $auth_string $search_string $search_value
        fi
      fi
    fi
  fi
}
