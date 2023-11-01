# audit_time_machine
#
# Backups should automatically run whenever the backup drive is available.
#
# Refer to Section(s) 2.3.4.1 Page(s) 125-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_time_machine () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "iCloud Drive"
      if [ "$audit_mode" != 2 ]; then
        check_osx_defaults /Library/Preferences/com.apple.TimeMachine.plist AutoBackup 1 bool
      fi
    fi
  fi
}
