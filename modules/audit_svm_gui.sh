# audit_svm_gui
#
# Refer to Section(s) 2.2.13 Page(s) 33-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_svm_gui () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Solaris Volume Manager GUI Daemons"
      service_name="svc:/network/rpc/mdcomm"
      funct_service $service_name disabled
      service_name="svc:/network/rpc/meta"
      funct_service $service_name disabled
      service_name="svc:/network/rpc/metamed"
      funct_service $service_name disabled
      service_name="svc:/network/rpc/metamh"
      funct_service $service_name disabled
    fi
  fi
}
