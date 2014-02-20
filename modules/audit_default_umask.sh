# audit_default_umask
#
# The default umask(1) determines the permissions of files created by users.
# The user creating the file has the discretion of making their files and
# directories readable by others via the chmod(1) command. Users who wish to
# allow their files and directories to be readable by others by default may
# choose a different default umask by inserting the umask command into the
# standard shell configuration files (.profile, .cshrc, etc.) in their home
# directories.
# Setting a very secure default value for umask ensures that users make a
# conscious choice about their file permissions. A default umask setting of
# 077 causes files and directories created by users to not be readable by any
# other user on the system. A umask of 027 would make files and directories
# readable by users in the same Unix group, while a umask of 022 would make
# files readable by every user on the system.
#.

audit_default_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Default umask for Users"
  fi
  if [ "$os_name" = "SunOS" ]; then
    check_file="/etc/default/login"
    funct_file_value $check_file UMASK eq 077 hash
  fi
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    for check_file in /etc/.login /etc/profile /etc/skel/.bash_profile; do
      funct_file_value $check_file "umask" space 077 hash
    done
    for check_file in /etc/bashrc /etc/skel/.bashrc; do
      funct_file_value $check_file UMASK eq 077 hash
    done
  fi
}
