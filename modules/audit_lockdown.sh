# audit_lockdown
#
# When lockdown mode is enabled, specific trusted websites can be excluded from
# Lockdown protection if necessary.
#
# Refer to Section(s) 2.6.7 Page(s) 181-2 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_lockdown() {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Lockdown Mode"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name defaults read .GlobalPreferences.plist LDMGlobalEnabled 2>&1 )
          if [ "$check_value" = "$lockdown_enable" ]; then
            increment_secure "Lockdown mode for $user_name is set to $lockdown_enable"
          else
            increment_insecure "Lockdown mode for $user_name is not set to $lockdown_enable"
          fi
        done
      fi
    fi
  fi
}
