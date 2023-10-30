# audit_media_sharing
#
# Disabling Media Sharing reduces the remote attack surface of the system.
#
# Refer to Section(s) 2.3.3.10 Page(s) 114-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_media_sharing() {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Media Sharing"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name defaults read com.apple.amp.mediasharingd home-sharing-enabled )
          if [ "$check_value" = "$media_sharing" ]; then
            increment_secure "Media sharing for $user_name is set to $media_sharing"
          else
            increment_insecure "Media sharing for $user_name is not set to $media_sharing"
          fi
        done
      fi
    fi
  fi
}
