# audit_strong_password
#
# Password policies are designed to force users to make better password choices
# when selecting their passwords.
#
# Solaris:
#
# Administrators may wish to change some of the parameters in this remediation
# step (particularly PASSLENGTH and MINDIFF) if changing their systems to use
# MD5, SHA-256, SHA-512 or Blowfish password hashes ("man crypt.conf" for more
# information). Similarly, administrators may wish to add site-specific
# dictionaries to the DICTIONLIST parameter.
# Sites often have differing opinions on the optimal value of the HISTORY
# parameter (how many previous passwords to remember per user in order to
# prevent re-use). The values specified here are in compliance with DISA
# requirements. If this is too restrictive for your site, you may wish to set
# a HISTORY value of 4 and a MAXREPEATS of 2. Consult your local security
# policy for guidance.
#
# OS X:
#
# Complex passwords contain one character from each of the following classes:
# English uppercase letters, English lowercase letters, Westernized Arabic
# numerals, and non- alphanumeric characters.
#
# FreeBSD
#
# MD5 encryption hashes are powerful, but in recent years other, more reliable
# ciphers have been adopted. Blowfish is one of the more powerful algorithms
# out there and fully supported for the FreeBSD password file database.
# Users will need to change their passwords for the settings to take effect as
# well as having the login.conf database rebuilt as is done here.
# There are interoperability issues with NIS and NIS+ configurations.
# In those cases, other algorithms are supported, including MD5 which is
# currently the default, and des. Administrators should also familiarize
# themselves with the FIPS-180 standard which contains information about US
# government accepted password hashes. Administrators working for the
# government may be required to use a different and more accepted algorithm
# over Blowfish.
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
