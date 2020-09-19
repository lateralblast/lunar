# audit_system_integrity
#
# Refer to Section 5.18 Page(s) 148-9 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_system_integrity() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "System Integrity"
    if [ "$audit_mode" != 2 ]; then
      check=$( /usr/bin/csrutil status | grep enabled )
      if [ ! "$check" ]; then
        increment_insecure "System Integrity Protection is not enabled"
      else
        increment_secure "System Integrity Protection is enabled"
      fi
    fi
  fi
}
