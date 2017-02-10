# audit_vopied
#
# Veritas Online Passwords In Everything
#
# Turn off vopied if not required. It is associated with Symantec products.
#.

audit_vopied () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "VOPIE Daemon"
      service_name="svc:/network/vopied/tcp:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
