# audit_media_sharing
#
# Disabling Media Sharing reduces the remote attack surface of the system.
#
# Refer to Section(s) 2.3.3.10 Page(s) 114-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_media_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Media Sharing"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.amp.mediasharingd home-sharing-enabled 0 bool $user_name
        done
      fi
    fi
  fi
}
