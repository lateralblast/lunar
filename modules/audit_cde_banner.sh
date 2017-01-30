# audit_cde_banner
#
# Refer to Section(s) 8.2 Page(s) 112-3 CIS Solaris 10 v5.1.0
#.

audit_cde_banner () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "CDE Warning Banner"
    for check_file in /usr/dt/config/*/Xresources ; do
      dir_name=`dirname $check_file |sed 's/usr/etc/'`
      new_file="$dir_name/Xresources"
      if [ -f "$new_file" ]; then
        funct_file_value $new_file "Dtlogin*greeting.labelString" colon "Authorized uses only" star
        funct_file_value $new_file "Dtlogin*greeting.persLabelString" colon "Authorized uses only" star
      fi
    done
  fi
}
