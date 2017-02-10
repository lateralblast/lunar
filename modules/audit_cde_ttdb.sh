# audit_cde_ttdb
#
# Refer to Section(s) 2.1.1 Page(s) 17-8 CIS Solaris 10 v5.1.0
#.

audit_cde_ttdb () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "CDE ToolTalk Database Server"
      service_name="svc:/network/rpc/cde-ttdbserver:tcp"
      check_sunos_service $service_name disabled
    fi
  fi
}
