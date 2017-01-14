# audit_svm_gui
#
# The Solaris Volume Manager, formerly Solstice DiskSuite, provides software
# RAID capability for Solaris systems. This functionality can either be
# controlled via the GUI administration tools provided with the operating
# system, or via the command line. However, the GUI tools cannot function
# without several daemons listed in Item 2.3.12 Disable Solaris Volume
# Manager Services enabled. If you have disabled Solaris Volume Manager
# Services, also disable the Solaris Volume Manager GUI.
# Note: Since these services use Oracle's standard RPC mechanism, it is
# important that the system's RPC portmapper (rpcbind) also be enabled
# when these services are turned on.
#
# Since the same functionality that is in the GUI is available from the
# command line interface, administrators are strongly urged to leave these
# daemons disabled and administer volumes directly from the command line.
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
