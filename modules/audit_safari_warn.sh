# audit_safari_warn
#
# Attackers use crafted web pages to social engineer users to load unwanted content.
# Warning users prior to loading the content enables better security.
#
# Refer to Section(s) 6.3.2 Page(s) 380-4 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_warn () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Safari Fraudulent Website Warning"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.Safari WarnAboutFraudulentWebsites 1 bool $user_name
        done
      fi
    fi
  fi
}
