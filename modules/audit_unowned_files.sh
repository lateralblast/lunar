# audit_unowned_files
#
# Refer to Section(s) 9.1.11-2 Page(s) 160-1 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.11-2 Page(s) 184-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.11-2 Page(s) 163-4 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.11-2 Page(s) 270-1 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 12.9-10  Page(s) 151-2 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.7      Page(s) 23    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.2   Page(s) 232-3 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.24     Page(s) 89-90 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.24     Page(s) 135-6 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.1.11-2 Page(s) 248-9 CIS Amazon Linux Benchmark v1.0.0
# Refer to Section(s) 6.1.11-2 Page(s) 262-3 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_unowned_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Unowned Files and Directories"
    if [ "$audit_mode" = 1 ]; then
      if [ "$os_name" = "Linux" ]; then
        for file_system in $( df --local -P | awk {'if (NR!=1) print $6'} 2> /dev/null ); do
          for check_file in $( find $file_system -xdev -nouser -ls 2> /dev/null ); do
            increment_insecure "File $check_file is unowned"
          done
        done
      else
        if [ "$os_name" = "SunOS" ]; then
          find_command="find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
          -o -fstype objfs -o -fstype proc \) -prune \
          -o \( -nouser -o -nogroup \) -print"
        fi
        if [ "$os_name" = "AIX" ]; then
          find_command="find / \( -fstype jfs -o -fstype jfs2 \) \
          \( -type d -o -type f \) \( -nouser -o -nogroup \) -ls"
        fi
        for check_file in $( $find_command ); do
          increment_insecure "File $check_file is unowned"
        done
      fi
    fi
  fi
}
