# audit_webconsole
#
# The Java Web Console (smcwebserver(1M)) provides a common location
# for users to access web-based system management applications.
#.

audit_webconsole () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Web Console"
      service_name="svc:/system/webconsole:console"
      funct_service $service_name disabled
    fi
  fi
}
