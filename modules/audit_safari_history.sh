# audit_safari_history
#
# Check Safari history limit
#
# Refer to Section(s) 6.3.2 Page(s) 374-79 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_history () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari History"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.Safari HistoryAgeInDaysLimit 31 $user_name
        done
      fi
    fi
  fi
}
