# audit_webconsole
#
# Refer to Section(s) 2.1.5 Page(s) 20-1 CIS Solaris 10 Benchmark v5.1.0
#.

audit_webconsole () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Web Console"
      service_name="svc:/system/webconsole:console"
      check_sunos_service $service_name disabled
    fi
  fi
}
