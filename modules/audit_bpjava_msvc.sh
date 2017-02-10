# audit_bpjava_msvc
#
# Turn off bpjava-msvc if not required. It is associated with NetBackup.
#.

audit_bpjava_msvc () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "BPJava Service"
      service_name="svc:/network/bpjava-msvc/tcp:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
