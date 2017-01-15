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
#
# Refer to Section(s) 7.4   Page(s) 147-8 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.4   Page(s) 170-1 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 7.4   Page(s) 150-1 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.4.4 Page(s) 254-5 CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 10.4  Page(s) 140   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.8   Page(s) 29    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 7.3   Page(s) 64-5  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.6   Page(s) 106-7 CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.4 Page(s) 233-4 CIS Amazon Linux Benchmark v2.0.0
#.

audit_default_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Default umask for Users"
  fi
  if [ "$os_name" = "SunOS" ]; then
    check_file="/etc/default/login"
    funct_file_value $check_file UMASK eq 077 hash
  fi
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    for check_file in /etc/.login /etc/profile /etc/skel/.bash_profile /etc/csh.login \
      /etc/csh.cshrc /etc/zprofile /etc/skel/.zshrc /etc/skel/.bashrc; do
      funct_file_value $check_file "umask" space 077 hash
    done
    for check_file in /etc/bashrc /etc/skel/.bashrc /etc/login.defs; do
      funct_file_value $check_file UMASK eq 077 hash
    done
  fi
}
