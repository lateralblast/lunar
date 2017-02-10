# audit_routing_daemons
#
# Turn off routing services if not required
#
# AIX:
#
# Refer to Section(s) 1.3.12-3,5 Page(s) 47-50,51-2 CIS AIX Benchmark v1.1.0
#.

audit_routing_daemons () {
  if [ "$routed_disable" = "yes" ]; then
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
      verbose_message "Routing Daemons"
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          for service_name in svc:/network/routing/zebra:quagga \
          svc:/network/routing/ospf:quagga \
          svc:/network/routing/rip:quagga \
          svc:/network/routing/ripng:default \
          svc:/network/routing/ripng:quagga \
          svc:/network/routing/ospf6:quagga \
          svc:/network/routing/bgp:quagga \
          svc:/network/routing/legacy-routing:ipv4 \
          svc:/network/routing/legacy-routing:ipv6 \
          svc:/network/routing/rdisc:default \
          svc:/network/routing/route:default \
          svc:/network/routing/ndp:default; do
            check_sunos_service $service_name disabled
          done
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        verbose_message "Routing Daemons"
        for service_name in bgpd ospf6d ospfd ripd ripngd; do
          check_chkconfig_service $service_name 3 off
          check_chkconfig_service $service_name 5 off
        done
      fi
    fi
    if [ "$os_name" = "AIX" ]; then
      for service_name in gated mrouted routed; do
        check_rctcp $service_name off
      done
    fi
  fi
}
