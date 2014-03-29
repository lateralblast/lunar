# audit_volfs
#
# The volume manager automatically mounts external devices for users whenever
# the device is attached to the system. These devices include CD-R, CD-RW,
# floppies, DVD, USB and 1394 mass storage devices. See the vold (1M) manual
# page for more details.
# Note: Since this service uses Oracle's standard RPC mechanism, it is
# important that the system's RPC portmapper (rpcbind) also be enabled
# when this service is turned on.
#
# Allowing users to mount and access data from removable media devices makes
# it easier for malicious programs and data to be imported onto your network.
# It also introduces the risk that sensitive data may be transferred off the
# system without a log record. Another alternative is to edit the
# /etc/vold.conf file and comment out any removable devices that you do not
# want users to be able to mount.
#
# Refer to Section(s) 2.8 Page(s) 20-1 CIS Solaris 11.1 v1.0.0
#.


audit_volfs () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Volume Management Daemons"
    fi
    if [ "$os_version" = "10" ]; then
      service_name="svc:/system/filesystem/volfs"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/system/filesystem/rmvolmgr"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      service_name="svc:/network/rpc/smserver"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "10" ]; then
      service_name="volmgt"
      funct_service $service_name disabled
    fi
  fi
}
