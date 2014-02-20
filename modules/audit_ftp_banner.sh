
# audit_ftp_banner
#
# The action for this item sets a warning message for FTP users before they
# log in. Warning messages inform users who are attempting to access the
# system of their legal status regarding the system. Consult with your
# organization's legal counsel for the appropriate wording for your
# specific organization.
#.

audit_ftp_banner () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "FTP Warning Banner"
      check_file="/etc/ftpd/banner.msg"
      funct_file_value $check_file Authorised space "users only" hash
      if [ "$audit_mode" = 0 ]; then
        funct_check_perms $check_file 0444 root root
      fi
    fi
    if [ "$os_version" = "11" ]; then
      funct_verbose_message"FTP Warning Banner"
      check_file="/etc/proftpd.conf"
      funct_file_value $check_file DisplayConnect space /etc/issue hash
      if [ "$audit_mode" = 0 ]; then
        svcadm restart ftp
      fi
    fi
  fi
}
