# audit_cde_screen_lock
#
# Refer to Section(s) 6.7 Page(s) 91-2 CIS Solaris 10 Benchmark v5.1.0
#.

audit_cde_screen_lock () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Screen Lock for CDE Users"
    for cde_file in $( ls /usr/dt/config/*/sys.resources 2> /dev/null ); do
      dir_name=$( dirname $cde_file | sed 's/usr/etc/' )
      if [ ! -d "$dir_name" ]; then
        mkdir -p $dir_name
      fi
      check_file="$dir_name/sys.resources"
      check_file_value is $check_file "dtsession*saverTimeout" colon " 10" star
      check_file_value is $check_file "dtsession*lockTimeout" colon " 10" star
      check_file_perms $check_file 0444 root sys
    done
  fi
}
