# audit_apache
#
# Solaris:
#
# The action in this section describes disabling the Apache 1.x and 2.x web
# servers provided with Solaris 10. Both services are disabled by default.
# Run control scripts for Apache 1 and the NCA web servers still exist,
# but the services will only be started if the respective configuration
# files have been set up appropriately, and these configuration files do not
# exist by default.
# Even if the system is a Web server, the local site may choose not to use
# the Web server provided with Solaris in favor of a locally developed and
# supported Web environment. If the machine is a Web server, the administrator
# is encouraged to search the Web for additional documentation on Web server
# security.
#
# Linux:
#
# HTTP or web servers provide the ability to host web site content.
# The default HTTP server shipped with CentOS Linux is Apache.
# The default HTTP proxy package shipped with CentOS Linux is squid.
# Unless there is a need to run the system as a web server, or a proxy it is
# recommended that the package(s) be deleted.
#
# Refer to Section 3.11,14 Page(s) 66-69 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section 2.4.14.7 Page(s) 56-7 CIS OS X 10.5 Benchmark v1.1.0
#.

audit_apache () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Apache and web based services"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        funct_verbose_message "Apache"
      fi
      if [ "$os_version" = "10" ]; then
        service_name="svc:/network/http:apache2"
        funct_service $service_name disabled
      fi
      if [ "$os_version" = "11" ]; then
        service_name="svc:/network/http:apache22"
        funct_service $service_name disabled
      fi
      if [ "$os_version" = "10" ]; then
        service_name="apache"
        funct_service $service_name disabled
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    for service_name in httpd apache tomcat5 squid prixovy; do
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    done
    if [ "$os_vendor" = "CentOS" ]; then
      funct_linux_package uninstall httpd
      funct_linux_package uninstall squid
    fi
    for check_dir in /etc /etc/sfw /etc/apache /etc/apache2 /usr/local/etc /usr/sfw/etc /opt/sfw/etc; do
      check_file="$check_dir/httpd.conf"
      if [ -f "$check_file" ]; then
        funct_file_value $check_file ServerTokens space Prod hash
        funct_file_value $check_file ServerSignature space Off hash
        funct_file_value $check_file UserDir space Off hash
        funct_file_value $check_file TraceEnable space Off hash
      fi
    done
  fi
}
