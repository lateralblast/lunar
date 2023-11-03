# audit_lockdown
#
# When lockdown mode is enabled, specific trusted websites can be excluded from
# Lockdown protection if necessary.
#
# Refer to Section(s) 2.6.7 Page(s) 181-2 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_lockdown () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Lockdown Mode"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults .GlobalPreferences LDMGlobalEnabled 1 bool
        done
      fi
    fi
  fi
}
