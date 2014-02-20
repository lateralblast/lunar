# audit_cde_banner
#
# The Common Desktop Environment (CDE) provides a uniform desktop environment
# for users across diverse Unix platforms.
# Warning messages inform users who are attempting to login to the system of
# their legal status regarding the system and must include the name of the
# organization that owns the system and any monitoring policies that are in
# place. Consult with your organization's legal counsel for the appropriate
# wording for your specific organization.
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
