# audit_sar_accounting
#
# Refer to Section(s) 2.12.8 Page(s) 212-3 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8    Page(s) 71-72 CIS Oracle Solaris 10 Benchmark v5.1.0
#.

audit_sar_accounting() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "SAR Accounting"
    if [ "$os_name" = "SunOS" ]; then
      check_file="/var/spool/cron/crontabs/adm"
      check_append_file $check_file "0,20,40 * * * * /usr/lib/sa/sa1"
      check_append_file $check_file "45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A"
    fi
    if [ "$os_name" = "AIX" ]; then
      package_name="bos.acct"
      check_lslpp $package_name
      if [ "$lslpp_check" = "$package_name" ]; then
        check_file="/var/spool/cron/crontabs/adm"
        check_append_file $check_file "#================================================================="
        check_append_file $check_file "#      SYSTEM ACTIVITY REPORTS"
        check_append_file $check_file "# 8am-5pm activity reports every 20 mins during weekdays."
        check_append_file $check_file "# activity reports every an hour on Saturday and Sunday."
        check_append_file $check_file "# 6pm-7am activity reports every an hour during weekdays."
        check_append_file $check_file "# Daily summary prepared at 18:05."
        check_append_file $check_file "#================================================================="
        check_append_file $check_file "0 8-17 * * 1-5 /usr/lib/sa/sa1 1200 3 &"
        check_append_file $check_file "0 * * * 0,6 /usr/lib/sa/sa1 &"
        check_append_file $check_file "0 18-7 * * 1-5 /usr/lib/sa/sa1 &"
        check_append_file $check_file "5 18 * * 1-5 /usr/lib/sa/sa2 -s 8:00 -e 18:01 -i 3600 -ubcwyaqvm &"
      else
        verbose_message "" fix
        verbose_message "Sar accounting requires $package_name to be installed" fix
        verbose_message "" fix
      fi
    fi
    $check_dir="/var/adm/sa"
    if [ ! -d "$check_dir" ]; then
      mkdir -p $check_dir
    fi
    check_file_perms $check_dir 0750 adm adm
  fi
}

