# audit_apache
#
# Refer to Section(s) 3.11,14       Page(s) 66-9        CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.2.10        Page(s) 110         CIS Ubuntu Linux 16.04 Benchmark v1.0.0
# Refer to Section(s) 3.11,14       Page(s) 79-81       CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.11,14       Page(s) 69-71       CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.10,13     Page(s) 110,113     CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.10,13       Page(s) 59,61       CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.7      Page(s) 56-7        CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.10          Page(s) 21-2        CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.11        Page(s) 21-2        CIS Solaris 10 v5.1.0
# Refer to Section(s) 2.2.10,13     Page(s) 102,105     CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.10,13     Page(s) 110,113     CIS Ubuntu 16.04 Benchmark v2.0.0
# Refer to Section(s) 2-11          Page(s) 16-186      CIS Apache 2.2 Benchmark v3.6.0
# Refer to Section(s) 2-11          Page(s) 16-186      CIS Apache 2.4 Benchmark v1.5.0
#.

audit_apache () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Apache and web based services"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        service_name="svc:/network/http:apache2"
        check_sunos_service $service_name disabled
      fi
      if [ "$os_version" = "11" ]; then
        service_name="svc:/network/http:apache2"
        check_sunos_service $service_name disabled
      fi
      if [ "$os_version" = "10" ]; then
        service_name="apache"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in httpd apache apache2 tomcat5 squid prixovy; do
        check_systemctl_service disable $service_name
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
        check_linux_package uninstall $service_name 
      done
    fi
    check_file_perms /var/log/httpd 0640 root apache
    for check_dir in /etc /etc/sfw /etc/apache /etc/apache2 /etc/apache2.2 /etc/apache/2.4 /usr/local/etc /usr/sfw/etc /opt/sfw/etc; do
      for check_file in "$check_dir/httpd.conf" "$check_dir/apache2.conf"; do
        if [ -f "$check_file" ]; then
          check_file_value is $check_file SSLHonorCipherOrder space On hash
          check_file_value is $check_file SSLCipherSuite space 'EECDH:EDH:!NULL:!SSLv2:!RC4:!aNULL:!3DES:!IDEA' hash
          check_file_value is $check_file ServerTokens space Prod hash
          check_file_value is $check_file ServerSignature space Off hash
          check_file_value is $check_file SSLProtocol space'TLSv1.2 TLSv1.3' hash
          check_file_value is $check_file SSLInsecureRenegotiation space Off hash
          check_file_value is $check_file UserDir space Off hash
          check_file_value is $check_file TraceEnable space Off hash
          check_file_value is $check_file AllowOverride space None hash
          check_file_value is $check_file Options space None hash
          check_file_value is $check_file FileETag space None hash
          check_file_value is $check_file User space apache hash
          check_file_value is $check_file Group space apache hash
          check_file_value is $check_file KeepAlive space On hash
          check_file_value is $check_file MaxKeepAliveRequests space 100 hash
          check_file_value is $check_file KeepAliveTimeout space 15 hash
          check_file_value is $check_file TraceEnable space Off hash
          check_file_value is $check_file RewriteEngine space On hash
          check_file_value is $check_file RewriteOptions space Inherit hash
          check_file_value is $check_file LimitRequestLine space 512 hash
          check_file_value is $check_file LimitRequestFields space 100 hash
          check_file_value is $check_file LimitRequestFieldsize space 1024 hash
          check_file_value is $check_file LimitRequestBody space 102400 hash
#          check_file_value is $check_file LogLevel space "notice core:info" hash
#          check_file_value is $check_file ErrorLog space "syslog:local1" hash
#          check_file_value is $check_file LogFormat space '"%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User- agent}i\"" combined' hash
#          check_file_value is $check_file CustomLog space 'log/access_log "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User- agent}i\""' hash
          check_file_value is $check_file Header space "always append X-Frame-Options SAMEORIGIN" hash
          check_file_value is $check_file RewriteCond space '%{THE_REQUEST} !HTTP/1\.1$' hash
          check_file_value is $check_file RewriteCond space '%{HTTP_HOST} !^www\.example\.com [NC]' hash
          check_file_value is $check_file RewriteCond space '%{REQUEST_URI} !^/error [NC]' hash
          check_file_value is $check_file RewriteRule space '.* - [F]' hash
          check_file_value is $check_file RequestReadTimeout space 'header=20-40,MinRate=500 body=20,MinRate=500' hash
          check_file_value is $check_file LimitRequestBody space 102400 hash
          check_file_value not $check_file 'LoadModule dav_module' space modules/mod_dav.so hash
          check_file_value not $check_file 'LoadModule dav_fs_module' space modules/mod_dav_fs.so hash
          check_file_value not $check_file 'LoadModule status_module' space modules/mod_status.so hash
          check_file_value not $check_file 'LoadModule autoindex_module' space autoindex_module hash
          check_file_value not $check_file 'LoadModule proxy_module' space modules/mod_proxy.so hash
          check_file_value not $check_file 'LoadModule proxy_balancer_module' space modules/mod_proxy_balancer.so hash
          check_file_value not $check_file 'LoadModule proxy_ftp_module' space modules/mod_proxy_ftp.so hash
          check_file_value not $check_file 'LoadModule proxy_http_module' space modules/mod_proxy_http.so hash
          check_file_value not $check_file 'LoadModule proxy_connect_module' space modules/mod_proxy_connect.so hash
          check_file_value not $check_file 'LoadModule proxy_ajp_module' space modules/mod_proxy_ajp.so hash
          check_file_value not $check_file 'LoadModule proxy_fcgi_module' space modules/mod_proxy_fcgi.so hash
          check_file_value not $check_file 'LoadModule proxy_scgi_module' space modules/mod_proxy_scgi.so hash
          check_file_value not $check_file 'LoadModule proxy_express_module' space modules/proxy_express_module.so hash
          check_file_value not $check_file 'LoadModule proxy_wstunnel_module' space modules/proxy_wstunnel_module.so hash
          check_file_value not $check_file 'LoadModule proxy_fdpass_module' space modules/proxy_fdpass_module.so hash
          check_file_value not $check_file 'LoadModule userdir_module' space modules/mod_userdir.so hash
          check_file_value not $check_file 'LoadModule info_module' space modules/mod_info.so hash
          check_file_value not $check_file 'LoadModule mod_auth_basic' space modules/mod_auth_basic.so hash
          check_file_value not $check_file 'LoadModule mod_auth_digest' space modules/mod_auth_digest.so hash
          check_file_value is $check_file 'LoadModule log_config_module' space 'modules/mod_log_config.so' hash
          check_file_value is $check_file 'LoadModule rewrite_module' space 'modules/mod_rewrite.so' hash
          check_file_value is $check_file 'LoadModule security2_module' space 'modules/mod_security2.so' hash
          check_file_value is $check_file 'LoadModule reqtimeout_module' space 'modules/mod_reqtimeout.so' hash
        fi
      done
    done
  fi
}
