# audit_chkconfig
#
# Refer to Section(s) 1.2.4-5      Page(s) 36-7   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.2.4-5      Page(s) 34-5   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.2.5,2.2.11 Page(s) 53,122 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.16         Page(s) 63-4   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.11       Page(s) 103    CIS Amazon Linux Benchmark v2.0.0
#.

audit_chkconfig () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Miscellaneous Services"
    for service_name in wu-ftpd ftp vsftpd aaeventd\
      tftp acpid amd arptables_jg arpwatch atd netfs irda isdn \
      bluetooth capi conman cpuspeed cryrus-imapd dc_client \
      dc_server dhcdbd dhcp6s dhcrelay chargen chargen-udp\
      dovecot dund gpm hidd hplip ibmasm innd ip6tables \
      lisa lm_sensors mailman mctrans mdmonitor mdmpd microcode_ctl \
      mysqld netplugd network NetworkManager openibd yum-updatesd\
      pand postfix psacct mutipathd daytime daytime-udp \
      radiusd radvd rdisc readahead_early readahead_later rhnsd \
      rpcgssd rpcimapd rpcsvcgssd rstatd rusersd rwhod saslauthd \
      settroubleshoot smartd spamassasin echo echo-udp\
      time time-udp vnc svcgssd rpmconfigcheck rsh rsync rsyncd \
      saslauthd powerd raw rexec rlogin rpasswdd openct\
      ipxmount joystick esound evms fam gpm gssd pcscd\
      tog-pegasus tux wpa_supplicant zebra ncpfs; do
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      check_systemctl_service disable $service_name
    done
  fi
}
