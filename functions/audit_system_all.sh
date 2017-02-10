# audit_system_all
#
# Audit All System
#.

audit_system_all () {
  full_audit_shell_services
  full_audit_accounting_services
  full_audit_firewall_services
  full_audit_password_services
  full_audit_kernel_services
  full_audit_mail_services
  full_audit_user_services
  full_audit_disk_services
  full_audit_hardware_services
  full_audit_power_services
  full_audit_virtualisation_services
  full_audit_x11_services
  full_audit_naming_services
  full_audit_file_services
  full_audit_web_services
  full_audit_print_services
  full_audit_routing_services
  full_audit_windows_services
  full_audit_startup_services
  full_audit_log_services
  full_audit_network_services
  full_audit_other_services
  full_audit_update_services
  if [ "$os_name" = "Darwin" ]; then
    full_audit_osx_services
  fi
}
