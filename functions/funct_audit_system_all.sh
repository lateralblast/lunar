# funct_audit_system_all
#
# Audit All System
#.

funct_audit_system_all () {

  audit_shell_services
  audit_accounting_services
  audit_firewall_services
  audit_password_services
  audit_kernel_services
  audit_mail_services
  audit_user_services
  audit_disk_services
  audit_hardware_services
  audit_power_services
  audit_virtualisation_services
  audit_x11_services
  audit_naming_services
  audit_file_services
  audit_web_services
  audit_print_services
  audit_routing_services
  audit_windows_services
  audit_startup_services
  audit_log_services
  audit_network_services
  audit_other_services
  audit_update_services
  if [ "$os_name" = "Darwin" ]; then
    audit_osx_services
  fi
}
