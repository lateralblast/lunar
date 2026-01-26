#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sleep
#
# MacBooks should be set so that the standbydelay is 15 minutes (900 seconds) or less.
# This setting should allow laptop users in most cases to stay within physically secured
# areas while going to a conference room, auditorium, or other internal location without
# having to unlock the encryption. When the user goes home at night, the laptop will auto-
# hibernate after 15 minutes and require the FileVault password to unlock prior to logging
# back into the system when it resumes.
# MacBooks should also be set to a hibernate mode that removes power from the RAM.
# This will stop the possibility of cold boot attacks on the system.
# Macs running Apple silicon chips, rather than Intel chips, do not require the same
# configuration as Intel-based Macs.
#
# Full Disk Encryption (FDE) is a Data-at-Rest (DAR) solution. It ensures that when the
# data on the drive is not in use it is full encrypted, but it can be decrypted (unlocked) as
# needed. When a Mac sleeps, the encryption keys remain in memory so that the drive is
# encrypted but unlocked. There are attacks available to interact with the OS and data on
# the unlocked drive. FileVault volumes should be locked when not in use to resist attack.
# The purpose of DAR is to ensure data is encrypted while at rest. If the volume is always
# unlocked it is not sufficient.
#
# Refer to Section(s) 2.5.2           Page(s) 52-3   CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.9.1.1-3,2.9.2 Page(s) 200-11 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_sleep () {
  print_function "audit_sleep"
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "Sleep" "check"
    if [ "${long_os_version}" -ge 1014 ]; then
      if [ "${os_machine}" = "arm64" ]; then
        check_pmset "sleep"                 "10"
        check_pmset "displaysleep"          "15"
        check_pmset "hibernatemode"         "25"
      else
        check_pmset "standbydelaylow"       "900"
        check_pmset "standbydelayhigh"      "900"
        check_pmset "highstandbythreshold"  "90"
        check_pmset "destroyfvkeyonstandby" "1"
        check_pmset "hibernatemode"         "25"
        check_pmset "powernap"              "0"
      fi
      check_pmset   "destroyfvkeyonstandby" "1"
    else
      check_pmset   "sleep"                 "off"
    fi
  fi
}
