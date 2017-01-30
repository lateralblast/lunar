# audit_file_sharing
#
# Refer to Section 2.4.8 Page(s) 23-24 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Apple File Sharing"
    funct_launchctl_check com.apple.AppleFileServer off
    funct_verbose_message "FTP Services"
    funct_launchctl_check ftp off
    funct_verbose_message "Samba Services"
    funct_launchctl_check nmbd off
    funct_launchctl_check smbd off
  fi
}
