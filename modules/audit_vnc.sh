# audit_vnc
#
# Turn off VNC
#.

audit_vnc () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "VNC Daemons"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/application/x11/xvnc-inetd:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in vncserver; do
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
    fi
  fi
}
