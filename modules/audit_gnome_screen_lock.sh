#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_gnome_screen_lock
#
# Check Gnome Screen Lock
#
# Refer to Section(s) 6.12  Page(s) 55-56  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.8   Page(s) 92-3   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.8.4 Page(s) 162-5  CIS Ubuntu 22.04 Benchmaek v1.0.0
# Refer to Section(s) 1.8.5 Page(s) 167-71 CIS Ubuntu 22.04 Benchmaek v1.0.0
#.

audit_gnome_screen_lock () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Screen Lock for GNOME Users" "check"
    check_file_value "is" "/usr/openwin/lib/app-defaults/XScreenSaver" "*timeout:"     "space" "0:10:00" "bang"
    check_file_value "is" "/usr/openwin/lib/app-defaults/XScreenSaver" "*lockTimeout:" "space" "0:00:00" "bang"
  fi
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Screen Lock for GNOME Users" "check"
    check_gsettings_value "org.gnome.desktop.session"     "idle-delay" "uint32 900"
    check_gsettings_value "org.gnome.desktop.screensaver" "lock-delay" "uint32 5" 
    if [ "$os_vendor" = "Ubuntu" ]; then
      if [ $os_version -ge 22 ]; then 
        check_file="/etc/dconf/db/ibus.d/00-screensaver"
        if [ -f "$check_file" ]; then
          if [ "$ansible" = 1 ]; then
            string="Screen Lock for GNOME Users"
            echo "- name: $string"
            echo "  copy:"
            echo "    content: |"
            echo "             [org/gnome/desktop/session]"
            echo "             idle-delay=uint32 900"
            echo "             [org/gnome/desktop/screensaver]"
            echo "             lock-delay=uint32 5"
            echo "    dest: $check_file"
          fi
          check_file_value "is" "$check_file" "idle-delay" "eq" "uint32 900" "hash" "after" "session"
          check_file_value "is" "$check_file" "lock-delay" "eq" "uint32 5"   "hash" "after" "screensaver"
        else
          if [ "$audit_mode" = 1 ]; then
            verbose_message "echo \"[org/gnome/desktop/session]\" > $check_file"      "fix"
            verbose_message "echo \"idle-delay=uint32 900\" >> $check_file"           "fix"
            verbose_message "echo \"[org/gnome/desktop/screensaver]\" >> $check_file" "fix"
            verbose_message "echo \"lock-delay=uint32 5\" >> $check_file"             "fix"
            verbose_message "dconf update" "fix"
          fi 
          if [ "$audit_mode" = 0 ]; then
            echo "[org/gnome/desktop/session]" > "$check_file"
            echo "idle-delay=uint32 900" >> "$check_file"
            echo "[org/gnome/desktop/screensaver]" >> "$check_file"
            echo "lock-delay=uint32 5" >> "$check_file"
            dconf update
          fi          
          if [ "$audit_mode" = 2 ]; then
            if [ -f "$check_file" ]; then
              rm "$check_file"
            fi
          fi
        fi
      fi
    fi
  fi
}
