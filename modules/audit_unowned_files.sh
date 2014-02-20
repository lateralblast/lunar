# audit_unowned_files
#
# Sometimes when administrators delete users from the password file they
# neglect to remove all files owned by those users from the system.
# A new user who is assigned the deleted user's user ID or group ID may then
# end up "owning" these files, and thus have more access on the system than
# was intended.
#.

audit_unowned_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Unowned Files and Directories"
    if [ "$audit_mode" = 1 ]; then
      echo "Checking:  For Un-owned files and directories [This might take a while]"
      for check_file in `find / \( -fstype nfs -o -fstype cachefs \
        -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
        -o -fstype objfs -o -fstype proc \) -prune \
        -o \( -nouser -o -nogroup \) -print`; do
        total=`expr $total + 1`
        score=`expr $score - 1`
        echo "Warning:   File $check_file is unowned [$score]"
      done
    fi
  fi
}
