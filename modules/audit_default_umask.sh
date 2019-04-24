# audit_default_umask
#
# Refer to Section(s) 7.4   Page(s) 147-8 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.4   Page(s) 170-1 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 7.4   Page(s) 150-1 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.4.4 Page(s) 254-5 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 10.4  Page(s) 140   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.8   Page(s) 29    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 7.3   Page(s) 64-5  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.6   Page(s) 106-7 CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.4 Page(s) 233-4 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.4.4 Page(s) 246-7 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_default_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    verbose_message "Default umask for Users"
    if [ "$os_name" = "SunOS" ]; then
      check_file="/etc/default/login"
      check_file_value is $check_file UMASK eq 077 hash
    fi
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      for check_file in /etc/.login /etc/profile /etc/skel/.bash_profile /etc/csh.login \
        /etc/csh.cshrc /etc/zprofile /etc/skel/.zshrc /etc/skel/.bashrc; do
        check_file_value is $check_file "umask" space 077 hash
      done
      for check_file in /etc/bashrc /etc/skel/.bashrc /etc/login.defs; do
        check_file_value is $check_file UMASK eq 077 hash
      done
    fi
  fi
}
