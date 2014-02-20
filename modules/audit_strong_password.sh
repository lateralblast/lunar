# audit_strong_password
#
# Password policies are designed to force users to make better password choices
# when selecting their passwords.
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
#.

audit_strong_password () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Strong Password Creation Policies"
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
}
