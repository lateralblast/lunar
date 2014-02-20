# audit_system_auth
#
# Audit /etc/pam.d/system-auth on RedHat
# Audit /etc/pam.d/common-auth on Debian
# Lockout accounts after 5 failures
# Set to remember up to 4 passwords
# Set password length to a minimum of 9 characters
# Set strong password creation via pam_cracklib.so and pam_passwdqc.so
# Restrict su command using wheel
#.

audit_system_auth () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "PAM Authentication"
    funct_rpm_check libpam-cracklib
    if [ "$linux_dist" = "debian" ] || [ "$linux_dist" = "suse" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$linux_dist" = "redhat" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
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
      auth_string="auth"
      search_string="use_uid"
      audit_system_auth_use_uid $auth_string $search_string
    fi
  fi
}
