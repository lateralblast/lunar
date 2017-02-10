# full_audit_kernel_services
#
# Audit kernel services
#.

full_audit_kernel_services () {
  audit_sysctl
  #audit_kernel_modules
  audit_kernel_accounting
  audit_kernel_params
  audit_tcp_syn_cookie
  audit_stack_protection
  audit_tcp_strong_iss
  audit_routing_params
  audit_modprobe_conf
  audit_unconfined_daemons
  audit_selinux
  audit_execshield
  audit_apparmour
  audit_virtual_memory
}
