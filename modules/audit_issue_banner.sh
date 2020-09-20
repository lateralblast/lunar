# audit_issue_banner
#
# Refer to Section(s) 8.1-2     Page(s) 149-151 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 8.1.1-2   Page(s) 172-4   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 8.1-2     Page(s) 152-4   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.7.1.1-3 Page(s) 78-83   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 11.1-2    Page(s) 142-3   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.4       Page(s) 25      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.7.1.1-3 Page(s) 68-73   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 1.7.1.1-6 Page(s) 75-83   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 5.13      Page(s) 143     CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_issue_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Security Warning Message"
    if [ "$os_name" = "Darwin" ]; then
      file_list="/etc/issue /etc/motd /etc/issue.net /Library/Security/PolicyBanner.txt"
    else
      file_list="/etc/issue /etc/motd /etc/issue.net"
    fi
    for check_file in $file_list; do
      check_file_perms $check_file 0644 root root
      issue_check=0
      if [ -f "$check_file" ]; then
        issue_check=$( grep -c 'NOTICE TO USERS' $check_file )
      fi
      if [ "$audit_mode" != 2 ]; then
       verbose_message "Security message in $check_file"
        if [ "$issue_check" != 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "No security message in $check_file"
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Security message in $check_file"
            backup_file $check_file
            echo "" > $check_file
            echo "                            NOTICE TO USERS" >> $check_file
            echo "                            ---------------" >> $check_file
            echo "This computer system is the private property of $company_name, whether" >> $check_file
            echo "individual, corporate or government. It is for authorized use only. Users" >> $check_file
            echo "(authorized & unauthorized) have no explicit/implicit expectation of privacy" >> $check_file
            echo "" >> $check_file
            echo "Any or all uses of this system and all files on this system may be" >> $check_file
            echo "intercepted, monitored, recorded, copied, audited, inspected, and disclosed" >> $check_file
            echo "to your employer, to authorized site, government, and/or law enforcement" >> $check_file
            echo "personnel, as well as authorized officials of government agencies, both" >> $check_file
            echo "domestic and foreign." >> $check_file
            echo "" >> $check_file
            echo "By using this system, the user expressly consents to such interception," >> $check_file
            echo "monitoring, recording, copying, auditing, inspection, and disclosure at the" >> $check_file
            echo "discretion of such officials. Unauthorized or improper use of this system" >> $check_file
            echo "may result in civil and criminal penalties and administrative or disciplinary" >> $check_file
            echo "action, as appropriate. By continuing to use this system you indicate your" >> $check_file
            echo "awareness of and consent to these terms and conditions of use. LOG OFF" >> $check_file
            echo "IMMEDIATELY if you do not agree to the conditions stated in this warning." >> $check_file
            echo "" >> $check_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "Security message in $check_file"
          fi
        fi
      else
        restore_file $check_file $restore_dir
      fi
    done
  fi
}
