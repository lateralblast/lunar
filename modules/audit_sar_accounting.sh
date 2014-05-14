# audit_sar_accounting
#
# The recommendation is to enable sar performance accounting.
# This will provide a normal performance baseline which will help identify
# unusual performance patterns, created through potential attacks via a
# password cracking program being executed or through a DoS attack etc.
# System accounting gathers periodic baseline system data, such as CPU
# utilization and disk I/O. Once a normal baseline for the system has been
# established, unauthorized activities, such as a password cracking being
# executed and activity outside of normal usage hours may be detected due
# to departure from the normal system performance baseline. It is recommended
# that the collection script is run on an hourly basis, every day, to help to
# detect any anomalies. It is also important to generate and review the system
# activity report on a daily basis.
#
# Refer to Section(s) 2.12.8 Page(s) 212-3 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8 Page(s) 71-72 CIS Oracle Solaris 10 Benchmark v5.1.0
#.

audit_sar_accounting() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    if [ "$os_name" = "SunOS" ]; then
      check_file="/var/spool/cron/crontabs/adm"
      funct_append_file $check_file "0,20,40 * * * * /usr/lib/sa/sa1"
      funct_append_file $check_file "45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A"
    fi
    if [ "$os_name" = "AIX" ]; then
      package_name="bos.acct"
      funct_lslpp_check $package_name
      if [ "$lslpp_check" = "$package_name" ]; then
        check_file="/var/spool/cron/crontabs/adm"
        funct_append_file $check_file "#================================================================="
        funct_append_file $check_file "#      SYSTEM ACTIVITY REPORTS"
        funct_append_file $check_file "# 8am-5pm activity reports every 20 mins during weekdays."
        funct_append_file $check_file "# activity reports every an hour on Saturday and Sunday."
        funct_append_file $check_file "# 6pm-7am activity reports every an hour during weekdays."
        funct_append_file $check_file "# Daily summary prepared at 18:05."
        funct_append_file $check_file "#================================================================="
        funct_append_file $check_file "0 8-17 * * 1-5 /usr/lib/sa/sa1 1200 3 &"
        funct_append_file $check_file "0 * * * 0,6 /usr/lib/sa/sa1 &"
        funct_append_file $check_file "0 18-7 * * 1-5 /usr/lib/sa/sa1 &"
        funct_append_file $check_file "5 18 * * 1-5 /usr/lib/sa/sa2 -s 8:00 -e 18:01 -i 3600 -ubcwyaqvm &"
      else
        funct_verbose_message "" fix
        funct_verbose_message "Sar accounting requires $package_name to be installed" fix
        funct_verbose_message "" fix
      fi
    fi
    $check_dir="/var/adm/sa"
    if [ ! -d "$check_dir" ]; then
      mkdir -p $check_dir
    fi
    funct_check_perms $check_dir 0750 adm adm
  fi
}

