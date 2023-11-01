# audit_amfi
#
# Apple Mobile File Integrity validates that application code is validated.
#
# Refer to Section(s) 5.1.3 Page(s) 303-4 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_amfi () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 12 ]; then
      verbose_message "Apple Mobile File Integrity"
      if [ "$audit_mode" != 2 ]; then
        check_value=$( sudo nvram -p 2>&1 > /dev/null |grep amfi |wc -l |sed "s/ //g" )
        if [ "$check_value" = "0" ]; then
          increment_secure "Apple Mobile File Integrity is not disabled"
        else
          increment_insecure "Apple Mobile File Integrity is set to $check_value"
        fi
      fi
    fi
  fi
}
