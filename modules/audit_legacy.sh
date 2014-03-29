# audit_legacy
#
# Solaris:
#
# Turn off inetd and init.d services on Solaris (legacy for Solaris 10+).
# Most of these services have now migrated to the new Service Manifest
# methodology.
#
# Refer to Section(s) 2.1-8 Page(s) 4-8 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.17,24-52 Page(s) 54-5,63-96 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.12 Page(s) 24 CIS Solaris 11.1 v1.0.0
#.

audit_legacy_inet() {
  funct_verbose_message "Inet Services"
  for service_name in time echo discard daytime chargen fs dtspc \
    exec comsat talk finger uucp name xaudio netstat ufsd rexd \
    systat sun-dr uuidgen krb5_prop 100068 100146 100147 100150 \
    100221 100232 100235 kerbd rstatd rusersd sprayd walld \
    printer shell login telnet ftp tftp 100083 100229 100230 \
    100242 100234 100134 100155 rquotad 100424 100422; do
    funct_inetd_service $service_name disabled
  done
}

audit_legacy_init() {
  funct_verbose_message "Init Services"
  for service_name in llc2 pcmcia ppd slpd boot.server autoinstall \
    power bdconfig cachefs.daemon cacheos.finish asppp uucp flashprom \
    PRESERVE ncalogd ncad ab2mgr dmi mipagent nfs.client autofs rpc \
    directory ldap.client lp spc volmgt dtlogin ncakmod samba dhcp \
    nfs.server kdc.master kdc apache snmpdx; do
    funct_initd_service $service_name disabled
  done
}

audit_legacy() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Legacy Inet/Init Services"
    if [ "$os_name" = "AIX" ]; then
      funct_rctcp_check timed off
      funct_subserver_check telnet tcp6 off
      funct_subserver_check exec tcp6 off
      funct_subserver_check daytime udp off
      funct_subserver_check shell tcp6 off
      funct_subserver_check cmsd sunrpc_tcp off
      funct_subserver_check ttdbserver sunrpc_tcp off
      funct_subserver_check uucp tcp off
      funct_subserver_check time udp off
      funct_subserver_check login tcp off
      funct_subserver_check talk udp off
      funct_subserver_check ntalk udp off
      funct_subserver_check ftp tcp6 off
      funct_subserver_check chargen tcp off
      funct_subserver_check discard tcp off
      funct_subserver_check dtspc tcp off
      funct_subserver_check echo tcp off
      funct_subserver_check echo udp off
      funct_subserver_check pcnfsd udp off
      funct_subserver_check rstatd udp off
      funct_subserver_check rusersd udp off
      funct_subserver_check rwalld udp off
      funct_subserver_check sprayd udp off
      funct_subserver_check klogin tcp off
      funct_subserver_check rquotad udp off
      funct_subserver_check tftp udp off
      funct_subserver_check imap2 tcp off
      funct_subserver_check pop3 tcp off
      funct_subserver_check finger tcp off
      funct_subserver_check instsrv tcp off
    else
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" != "11" ]; then
          audit_legacy_inet
          audit_legacy_init
        fi
      else
        audit_legacy_inet
        audit_legacy_init
      fi
    fi
  fi
}
