#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_user_services
#
# Audit users and groups
#.

full_audit_user_services () {
  print_function "full_audit_user_services"
  audit_root_access
  audit_root_home
  audit_root_path
  audit_root_primary_group
  audit_root_ssh_keys
  audit_mesgn
  audit_writesrv
  audit_groups_exist
  audit_home_perms
  audit_home_ownership
  audit_duplicate_users
  audit_duplicate_groups
  audit_user_dotfiles
  audit_forward_files
  audit_default_umask
  audit_password_fields
  audit_password_lock
  audit_password_history
  audit_group_fields
  audit_reserved_ids
  audit_super_users
  audit_daemon_umask
  audit_cron_perms
  audit_wheel_group
  audit_wheel_su
  audit_old_users
  audit_cron_allow
  audit_cron
  audit_system_accounts
  audit_shadow_group
  audit_dcui
}
