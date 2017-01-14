# audit_svm
#
# The Solaris Volume Manager, formerly known as Solstice DiskSuite, provides
# functionality for managing disk storage, disk arrays, etc. However, many
# systems without large storage arrays do not require that these services be
# enabled or may be using an alternate volume manager rather than the bundled
# SVM functionality. This service is disabled by default in the OS.
#
# Refer to Section(s) 2.2.8,12 Page(s) 28,32-3 CIS Solaris 10 Benchmark v5.1.0
#.

audit_svm () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Solaris Volume Manager Daemons"
      service_name="svc:/system/metainit"
      funct_service $service_name disabled
      service_name="svc:/system/mdmonitor"
      funct_service $service_name disabled
      if [ $os_update -lt 4 ]; then
        service_name="svc:/platform/sun4u/mpxio-upgrade"
      else
        service_name="svc:/system/device/mpxio-upgrade"
      fi
      funct_service $service_name disabled
    fi
  fi
}
