# audit_file_sharing
#
# Apple's File Sharing uses a combination of many technologies: FTP, SMB
# (Windows sharing) and AFP (Mac sharing). Generally speaking, file sharing
# should be turned off and a dedicated, well-managed file server should be
# used to share files. If file sharing must be turned on, the user should be
# aware of the security implications of each option.
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
