# audit_service_tags
#
# A service tag enables automatic discovery of assets, including software and
# hardware. A service tag uniquely identifies each tagged asset, and allows
# information about the asset to be shared over a local network in a standard
# XML format.
# Turn off Service Tags if not being used. It can provide information that can
# be used as vector of attack.
#.

audit_service_tags () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Service Tags Daemons"
      service_name="svc:/network/stdiscover:default"
      funct_service $service_name disabled
      service_name="svc:/network/stlisten:default"
      funct_service $service_name disabled
      service_name="svc:/application/stosreg:default"
      funct_service $service_name disabled
    fi
  fi
}
