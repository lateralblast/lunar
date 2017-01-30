# audit_strong_password
#
# Refer to Section(s) 5.12-19 Page(s) 58-66 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 8.10    Page(s) 30    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 7.2     Page(s) 63-4  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.3     Page(s) 103-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_strong_password () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Strong Password Creation Policies"
    if  [ "$os_name" = "SunOS" ]; then
      check_file="/etc/default/passwd"
      funct_file_value $check_file PASSLENGTH eq 8 hash
      funct_file_value $check_file NAMECHECK eq YES hash
      funct_file_value $check_file HISTORY eq 10 hash
      funct_file_value $check_file MINDIFF eq 3 hash
      funct_file_value $check_file MINALPHA eq 2 hash
      funct_file_value $check_file MINUPPER eq 1 hash
      funct_file_value $check_file MINLOWER eq 1 hash
      funct_file_value $check_file MINDIGIT eq 1 hash
      funct_file_value $check_file MINNONALPHA eq 1 hash
      funct_file_value $check_file MAXREPEATS eq 0 hash
      funct_file_value $check_file WHITESPACE eq YES hash
      funct_file_value $check_file DICTIONDBDIR eq /var/passwd hash
      funct_file_value $check_file DICTIONLIST eq /usr/share/lib/dict/words hash
    fi
    if [ "$os_name" = "Darwin" ]; then
      funct_pwpolicy_check requiresAlpha 1
      funct_pwpolicy_check requiresSymbol 1
      funct_pwpolicy_check maxMinutesUntilChangePassword 86400
      funct_pwpolicy_check minChars 15
      funct_pwpolicy_check passwordCannotBeName 1
      funct_pwpolicy_check minutesUntilFailedLoginReset 0
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/login.conf"
      funct_file_value $check_file passwd_format eq blf hash
    fi
  fi
}
