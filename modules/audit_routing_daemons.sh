# audit_routing_daemons
#
# Turn off routing services if not required
#.

audit_routing_daemons () {
  if [ "$routed_disable" = "yes" ]; then
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          funct_verbose_message "Routing Daemons"
          service_name="svc:/network/routing/zebra:quagga"
          funct_service $service_name disabled
          service_name="svc:/network/routing/ospf:quagga"
          funct_service $service_name disabled
          service_name="svc:/network/routing/rip:quagga"
          funct_service $service_name disabled
          service_name="svc:/network/routing/ripng:default"
          funct_service $service_name disabled
          service_name="svc:/network/routing/ripng:quagga"
          funct_service $service_name disabled
          service_name="svc:/network/routing/ospf6:quagga"
          funct_service $service_name disabled
          service_name="svc:/network/routing/bgp:quagga"
          funct_service $service_name disabled
          service_name="svc:/network/routing/legacy-routing:ipv4"
          funct_service $service_name disabled
          service_name="svc:/network/routing/legacy-routing:ipv6"
          funct_service $service_name disabled
          service_name="svc:/network/routing/rdisc:default"
          funct_service $service_name disabled
          service_name="svc:/network/routing/route:default"
          funct_service $service_name disabled
          service_name="svc:/network/routing/ndp:default"
          funct_service $service_name disabled
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        funct_verbose_message "Routing Daemons"
        for service_name in bgpd ospf6d ospfd ripd ripngd; do
          funct_chkconfig_service $service_name 3 off
          funct_chkconfig_service $service_name 5 off
        done
      fi
    fi
    if [ "$os_name" = "AIX" ]; then
      funct_rctcp_check gated off
    fi
  fi
}
