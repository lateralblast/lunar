# audit_legacy
#
# Turn off inetd and init.d services on Solaris (legacy for Solaris 10+).
# Most of these services have now migrated to the new Service Manifest
# methodology.
#.

audit_legacy () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" != "11" ]; then
      funct_verbose_message "Inet Services"
      for service_name in time echo discard daytime chargen fs dtspc \
        exec comsat talk finger uucp name xaudio netstat ufsd rexd \
        systat sun-dr uuidgen krb5_prop 100068 100146 100147 100150 \
        100221 100232 100235 kerbd rstatd rusersd sprayd walld \
        printer shell login telnet ftp tftp 100083 100229 100230 \
        100242 100234 100134 100155 rquotad 100424 100422; do
        funct_inetd_service $service_name disabled
      done
      funct_verbose_message "Init Services"
      for service_name in llc2 pcmcia ppd slpd boot.server autoinstall \
        power bdconfig cachefs.daemon cacheos.finish asppp uucp flashprom \
        PRESERVE ncalogd ncad ab2mgr dmi mipagent nfs.client autofs rpc \
        directory ldap.client lp spc volmgt dtlogin ncakmod samba dhcp \
        nfs.server kdc.master kdc apache snmpdx; do
        funct_initd_service $service_name disabled
      done
    fi
  fi
}
