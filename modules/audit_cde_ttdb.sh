# audit_cde_ttdb
#
# The ToolTalk service enables independent CDE applications to communicate
# with each other without having direct knowledge of each other.
# Not required unless running CDE applications.
#
# Refer to Section(s) 2.1.1 Page(s) 17-8 CIS Solaris 10 v5.1.0
#.

audit_cde_ttdb () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "CDE ToolTalk Database Server"
      service_name="svc:/network/rpc/cde-ttdbserver:tcp"
      funct_service $service_name disabled
    fi
  fi
}
