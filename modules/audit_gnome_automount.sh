#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_gnome_automount
#
# Check Gnome Automount
#
# Refer to Section(s) 1.8.6 Page(s) 172-7  CIS Ubuntu 22.04 Benchmaek v1.0.0
# Refer to Section(s) 1.8.7 Page(s) 178-82 CIS Ubuntu 22.04 Benchmaek v1.0.0
# Refer to Section(s) 1.8.8 Page(s) 183-7  CIS Ubuntu 22.04 Benchmaek v1.0.0
# Refer to Section(s) 1.8.9 Page(s) 188-92 CIS Ubuntu 22.04 Benchmaek v1.0.0
#.

audit_gnome_automount () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message       "Automount/Autorun for GNOME Users" "check"
    check_gsettings_value "org.gnome.desktop.media-handling"  "automount-open" "false"
    check_gsettings_value "org.gnome.desktop.media-handling"  "automount"      "false"
    check_gsettings_value "org.gnome.desktop.media-handling"  "autorun-never"  "true"
    if [ "$os_vendor" = "Ubuntu" ]; then
      if [ $os_version -ge 22 ]; then 
        if [ -d "/etc/dconf" ]; then
          check_file="/etc/dconf/db/ibus.d/00-media-automount"
          if [ "$ansible" = 1 ]; then
            string="Automount GNOME Users"
            echo "- name: $string"
            echo "  copy:"
            echo "    content: |"
            echo "             [org/gnome/desktop/media-handling]"
            echo "             automount-open=false"
            echo "             automount=false"
            echo "    dest: $check_file"
          fi
          if [ -f "$check_file" ]; then
            check_file_value_with_position "is" "$check_file" "automount-open" "eq" "false" "hash after" "handling"
            check_file_value_with_position "is" "$check_file" "automount"      "eq" "false" "hash after" "handling"
            check_file_value_with_position "is" "$check_file" "autorun-never"  "eq" "true"  "hash after" "handling"
          else
            if [ "$audit_mode" = 1 ]; then
              verbose_message "echo \"[org/gnome/desktop/media-handling]\" > $check_file" "fix"
              verbose_message "echo \"automount-open=false\" >> $check_file" "fix"
              verbose_message "echo \"automount=false\" >> $check_file"      "fix"
              verbose_message "echo \"autorun-never=true\" >> $check_file"   "fix"
              verbose_message "dconf update" "fix"
            fi 
            if [ "$audit_mode" = 0 ]; then
              echo "[org/gnome/desktop/media-handling]" > "$check_file"
              echo "automount-open=false" >> "$check_file"
              echo "automount=false" >> "$check_file"
              echo "autorun-never=true" >> "$check_file"
              dconf update
            fi          
            if [ "$audit_mode" = 2 ]; then
              if [ -f "$check_file" ]; then
                rm "$check_file"
              fi
            fi
          fi
          check_file="/etc/dconf/db/ibus.d/locks/00-media-automount"
          if [ "$ansible" = 1 ]; then
            string="Automount/Autorun Lock GNOME Users"
            echo "- name: $string"
            echo "  copy:"
            echo "    content: |"
            echo "             /org/gnome/desktop/media-handling/automount"
            echo "             /org/gnome/desktop/media-handling/automount-open"
            echo "             /org/gnome/desktop/media-handling/autorun-never"
            echo "    dest: $check_file"
          fi
          if [ -f "$check_file" ]; then
            check_append_file "$check_file" "/org/gnome/desktop/media-handling/automount-false" "hash"
            check_append_file "$check_file" "/org/gnome/desktop/media-handling/automount"       "hash"
            check_append_file "$check_file" "/org/gnome/desktop/media-handling/autorun-never"   "hash"
          else
            if [ "$audit_mode" = 1 ]; then
              verbose_message "mkdir -p /etc/dconf/db/ibus.d/locks" "fix"
              verbose_message "echo \"/org/gnome/desktop/media-handling/automount\" > $check_file"       "fix"
              verbose_message "echo \"/org/gnome/desktop/media-handling/automount-open\" >> $check_file" "fix"
              verbose_message "echo \"/org/gnome/desktop/media-handling/autorun-never\" >> $check_file"  "fix"
              verbose_message "dconf update" "fix"
            fi 
            if [ "$audit_mode" = 0 ]; then
              mkdir -p /etc/dconf/db/ibus.d/locks
              echo "/org/gnome/desktop/media-handling/automount" > "$check_file"
              echo "/org/gnome/desktop/media-handling/automount-open" > "$check_file"
              echo "/org/gnome/desktop/media-handling/autorun-never" > "$check_file"
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
  fi
}
