# audit_issue_banner
#
# The contents of the /etc/issue file are displayed prior to the login prompt
# on the system's console and serial devices, and also prior to logins via
# telnet. /etc/motd is generally displayed after all successful logins, no
# matter where the user is logging in from, but is thought to be less useful
# because it only provides notification to the user after the machine has been
# accessed.
# Warning messages inform users who are attempting to login to the system of
# their legal status regarding the system and must include the name of the
# organization that owns the system and any monitoring policies that are in
# place. Consult with your organization's legal counsel for the appropriate
# wording for your specific organization.
#
# Refer to Section(s) 8.1-2     Page(s) 149-151 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 8.1.1-2   Page(s) 172-4   CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 8.1-2     Page(s) 152-4   CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
# Refer to Section(s) 1.7.1.1-3 Page(s) 78-83   CIS Red Hat Enterprise Linux 7 Benchmark v2.1.0
# Refer to Section(s) 11.1-2    Page(s) 142-3   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.4       Page(s) 25      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.7.1.1-3 Page(s) 68-73   CIS Amazon Linux Benchmark v2.0.0
#.

audit_issue_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Security Warning Message"
    total=`expr $total + 1`
    check_file="/etc/issue"
    issue_check=0
    if [ -f "$check_file" ]; then
      issue_check=`cat $check_file |grep 'NOTICE TO USERS' |wc -l`
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Security message in $check_file"
      if [ "$issue_check" != 1 ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   No security message in $check_file [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   Security message in $check_file"
          funct_backup_file $check_file
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
          secure=`expr $secure + 1`
          echo "Secure:    Security message in $check_file [$secure Passes]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
