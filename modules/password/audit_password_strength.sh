#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_password_strength
#
# Refer to Section(s) 5.12-19 Page(s) 58-66  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 5.2.1-6 Page(s) 112-27 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 8.10    Page(s)        CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 7.2     Page(s) 63-4   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.3     Page(s) 103-4  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.2.1-8 Page(s) 315-30 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_password_strength () {
  print_function "audit_password_strength"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "Strong Password Creation Policies" "check"
    if  [ "${os_name}" = "SunOS" ]; then
      check_file_value "is" "/etc/default/passwd" "PASSLENGTH"    "eq"    "8"                         "hash"
      check_file_value "is" "/etc/default/passwd" "NAMECHECK"     "eq"    "YES"                       "hash"
      check_file_value "is" "/etc/default/passwd" "HISTORY"       "eq"    "10"                        "hash"
      check_file_value "is" "/etc/default/passwd" "MINDIFF"       "eq"    "3"                         "hash"
      check_file_value "is" "/etc/default/passwd" "MINALPHA"      "eq"    "2"                         "hash"
      check_file_value "is" "/etc/default/passwd" "MINUPPER"      "eq"    "1"                         "hash"
      check_file_value "is" "/etc/default/passwd" "MINLOWER"      "eq"    "1"                         "hash"
      check_file_value "is" "/etc/default/passwd" "MINDIGIT"      "eq"    "1"                         "hash"
      check_file_value "is" "/etc/default/passwd" "MINNONALPHA"   "eq"    "1"                         "hash"
      check_file_value "is" "/etc/default/passwd" "MAXREPEATS"    "eq"    "0"                         "hash"
      check_file_value "is" "/etc/default/passwd" "WHITESPACE"    "eq"    "YES"                       "hash"
      check_file_value "is" "/etc/default/passwd" "DICTIONDBDIR"  "eq"    "/var/passwd"               "hash"
      check_file_value "is" "/etc/default/passwd" "DICTIONLIST"   "eq"    "/usr/share/lib/dict/words" "hash"
    fi
    if [ "${os_name}" = "Darwin" ]; then
      check_pwpolicy    "requiresAlpha"     "1"
#      check_pwpolicy   "minimumAlphaCharacters" "1"
      check_pwpolicy    "requiresSymbol"    "1"
#      check_pwpolicy   "minimumSymbolCharacters" "1"
      check_pwpolicy    "RequiresNumeric"   "1"
#      check_pwpolicy "minimumNumericCharacters" "1"
      if [ "${long_os_version}" -ge 1014 ]; then
        check_pwpolicy  "requiresMixedCase" "1"
        check_pwpolicy  "usingHistory"      "15"
      fi
      check_pwpolicy    "maxMinutesUntilChangePassword"                   "86400"
      check_pwpolicy    "minChars"                                        "15"
      check_pwpolicy    "passwordCannotBeName"                            "1"
      check_pwpolicy    "minutesUntilFailedLoginReset"                    "0"
      check_pwpolicy    "policyAttributeMaximumFailedAuthentications"     "15"
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_value  "is" "/etc/login.conf" "passwd_format" "eq" "blf" "hash"
    fi
  fi
}
