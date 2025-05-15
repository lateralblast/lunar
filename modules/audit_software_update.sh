#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_software_update
#
# Check software update settings
#
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.update_manager.doc/GUID-EF6BEE4C-4583-4A8C-81B9-5B074CA2E272.html
#
# Refer to                  Page(s) 8     CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 1.2-5 Page(s) 13-20 CIS Apple OS X 10.12 Benchmark v1.0.0o
# Refer to Section(s) 1.2-7 Page(s) 16-34 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_software_update () {
  if [ "${os_name}" = "VMkernel" ]; then
    verbose_message "Software Update" "check"
    vmware_depot="http://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml"
    current_update=$( esxcli software profile get 2>&1 | head -1 )
    log_file="softwareupdate.log"
    backup_file="${work_dir}/${log_file}"
    available_update=$( esxcli software sources profile list -d "${vmware_depot}" | grep "${os_version}" | head -1 | awk '{print $1}' )
    if [ "${audit_mode}" != 2 ]; then
      if [ "${current_update}" != "${available_update}" ]; then
        if [ "${audit_mode}" = 0 ]; then
          verbose_message "Updating software" "notice"
          esxcli software profile install -d "${vmware_depot}" -p "${available_update}" --ok-to-remove
        fi
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Software is not up to date (Current: ${current_update} Available: ${available_update})"
          verbose_message    "esxcli software profile install -d ${vmware_depot} -p ${available_update} --ok-to-remove" "fix"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Software is up to date"
        fi
      fi
    else
      restore_file="${restore_dir}/${log_file}"
      if [ -f "${restore_file}" ]; then
        previous_update=$( cat "${restore_file}" )
        if [ "${current_update}" != "${previous_update}" ]; then
          verbose_message "Software to \"${previous_value}\"" "restore"
          esxcli software profile install -d "${vmware_depot}" -p "${previous_update}" --ok-to-remove --alow-downgrades
        fi
      fi
    fi
  fi
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1012 ]; then
      check_osx_defaults_int    "/Library/Preferences/com.apple.SoftwareUpdate"   "AutomaticCheckEnabled"            "1"
      check_osx_defaults_bool   "/Library/Preferences/com.apple.commerce"         "AutoUpdate"                       "1"
      check_osx_defaults_bool   "/Library/Preferences/com.apple.SoftwareUpdate"   "ConfigDataInstall"                "1"
      check_osx_defaults_bool   "/Library/Preferences/com.apple.SoftwareUpdate"   "CriticalUpdateInstall"            "1"
      check_osx_defaults_bool   "/Library/Preferences/com.apple.commerce"         "AutoUpdateRestartRequired"        "1"
      if [ "${long_os_version}" -ge 1013 ]; then
        check_osx_defaults_bool "/Library/Preferences/com.apple.SoftwareUpdate"   "AutomaticDownload"                "1"
        check_osx_defaults_bool "/Library/Preferences/com.apple.SoftwareUpdate"   "AutomaticallyInstallMacOSUpdates" "1"
      fi
    else
      verbose_message "Software Autoupdate" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      actual_status=$( sudo softwareupdate --schedule |awk '{print $4}' )
      log_file="softwareupdate.log"
      correct_status="on"
      if [ "${audit_mode}" != 2 ]; then
       verbose_message "If Software Update is enabled"
        if [ "${actual_status}" != "${correct_status}" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Software Update is not \"${correct_status}\""
            command_line="sudo softwareupdate --schedule ${correct_status}"
            verbose_message "${command_line}" "fix"
          else
            if [ "${audit_mode}" = 0 ]; then
              log_file="${work_dir}/${log_file}"
              echo "${actual_status}" > "${log_file}"
              verbose_message "Software Update schedule to \"${correct_status}\"" "set"
              sudo softwareupdate --schedule ${correct_status}
            fi
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Software Update is ${correct_status}"
          fi
        fi
      else
        restore_file="${restore_dir}/${log_file}"
        if [ -f "${restore_file}" ]; then
          previous_status=$( cat "${restore_file}" )
          if [ "${previous_status}" != "${actual_status}" ]; then
            verbose_message "Software Update to \"${previous_status}\"" "restore"
            sudo suftwareupdate --schedule "${previous_status}"
          fi
        fi
      fi
    fi
  fi
}
