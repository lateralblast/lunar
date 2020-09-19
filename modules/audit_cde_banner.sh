# audit_cde_banner
#
# Refer to Section(s) 8.2 Page(s) 112-3 CIS Solaris 10 v5.1.0
#.

audit_cde_banner () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "CDE Warning Banner"
    for cde_file in /usr/dt/config/*/Xresources ; do
      dir_name=$( dirname $cde_file | sed 's/usr/etc/' )
      check_file="$dir_name/Xresources"
      if [ -f "$check_file" ]; then
        check_file_value is $check_file "Dtlogin*greeting.labelString" colon "Authorized uses only" star
        check_file_value is $check_file "Dtlogin*greeting.persLabelString" colon "Authorized uses only" star
      fi
    done
  fi
}
