# audit_webmin
#
# Webmin is a web-based system configuration tool for Unix-like systems,
# although recent versions can also be installed and run on Windows.
# With it, it is possible to configure operating system internals, such
# as users, disk quotas, services or configuration files, as well as modify
# and control open source apps, such as the Apache HTTP Server, PHP or MySQL.
#
# Turn off webmin if it is not being used.
#.

audit_webmin () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Webmin Daemon"
      service_name="svc:/application/management/webmin:default"
      funct_service $service_name disabled
    fi
  fi
}
