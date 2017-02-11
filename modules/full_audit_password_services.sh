# full_audit_password_services
#
# Audit password related services
#.

full_audit_password_services () {
  audit_rsa_securid_pam
  audit_system_auth
  audit_system_auth_use_uid
  audit_password_expiry
  audit_password_strength
  audit_passwd_perms
  audit_retry_limit
  audit_login_records
  audit_failed_logins
  audit_login_delay
  audit_pass_req
  audit_pam_wheel
  audit_password_hashing
  audit_pam_deny
  audit_crypt_policy
  audit_account_lockout
  audit_sudo_timeout
}
