# audit_online_documentation
#
# AIX:
#
# httpdlite is the Lite NetQuestion Web server software for online
# documentation. It is recommended that this software is disabled,
# unless it is required in the environment.
#
# Refer to Section(s) 2.12.4 Page(s) 209 CIS AIX Benchmark v1.1.0
#.

audit_online_documentation () {
  if [ "$os_name" = "AIX" ] || [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Online Documenation"
    if [ "$os_name" = "AIX" ]; then
      funct_itab_check httpdlite off
    fi
    if [ "$os_name" = "SunOS" ]; then
      funct_initd_service ab2mgr disabled
    fi
  fi
}
