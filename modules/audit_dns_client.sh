# audit_dns_client
#
# Nscd is a daemon that provides a cache for the most common name service
# requests. The default configuration file, /etc/nscd.conf, determines the
# behavior of the cache daemon.
# Unless required disable Name Server Caching Daemon as it can result in
# stale or incorrect DNS information being cached by the system.
#.

audit_dns_client () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Name Server Caching Daemon"
    for service_name in nscd; do
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    done
  fi
}
