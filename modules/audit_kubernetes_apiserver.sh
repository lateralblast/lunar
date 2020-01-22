# audit_kubernetes_apiserver
#
# Refer to Section(s) 1.1.1-39 Page(s) 13-88   CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.4.1-21 Page(s) 109-128 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.5.1-7  Page(s) 151-164 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.6.1-8  Page(s) 165-180 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 1.7.1-7  Page(s) 181-194 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 2.1.1-14 Page(s) 195-222 CIS Kubernetes Benchmark v1.4.0
# Refer to Section(s) 2.2.1-10 Page(s) 223-242 CIS Kubernetes Benchmark v1.4.0
#
# Still to be completed
#.

audit_kubernetes_apiserver () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
#    daemon_check=`ps -ef | grep "kube-apiserver" |grep -v grep`
    daemon_check="yes"
    if [ "$daemon_check" ]; then
      check_file="/etc/kubernetes/manifests/kube-apiserver.yaml"
      if [ -f "$check_file" ]; then
        check_file_perms $check_file 0644 root root
        check_file_value is $check_file "--anonymous-auth" eq "false" hash 
        disable_value $check_file "--basic-auth-file" hash
        disable_value $check_file "--insecure-allow-any-token" hash
        check_file_value is $check_file "--kubelet-https" eq "true" hash
        disable_value $check_file "--insecure-bind-address" hash
        check_file_value is $check_file "--insecure-port" eq "0" hash
        check_file_value is $check_file "--profiling" eq "false" hash 
        check_file_value is $check_file "--repair-malformed-updates" eq "false" hash 
        check_file_value not $check_file "--enable-admission-plugins" eq "AlwaysAdmit" hash # no
        check_file_value is $check_file "--enable-admission-plugins" eq "AlwaysPullImages" hash # yes
        check_file_value is $check_file "--enable-admission-plugins" eq "DenyEscalatingExec" hash # yes
        check_file_value is $check_file "--enable-admission-plugins" eq "SecurityContextDeny" hash # yes
        check_file_value is $check_file "--enable-admission-plugins" eq "NamespaceLifecycle" hash # no
        check_file_value is $check_file "--audit-log-path" eq "/var/log/apiserver/audit.log" hash
        check_file_value is $check_file "--audit-log-maxage" eq "30" hash
        check_file_value is $check_file "--audit-log-maxbackup" eq "10" hash
        check_file_value is $check_file "--audit-log-maxsize" eq "100" hash
        check_file_value is $check_file "--authorization-mode" eq "Node,RBAC" hash
        disable_value $check_file "--token-auth-file" hash
        check_file_value set $check_file "--enable-admission-plugins" eq "na" hash
        check_file_value set $check_file "--kubelet-client-certificate" eq "na" hash
        check_file_value set $check_file "--kubelet-client-key" eq "na" hash
        check_file_value is $check_file "--service-account-lookup" eq "true" hash
        check_file_value is $check_file "--enable-admission-plugins" eq "PodSecurityPolicy" hash # yes
        check_file_value set $check_file "--service-account-key-file" eq "na" hash
        check_file_value set $check_file "--etcd-certfile" eq "na" hash
        check_file_value set $check_file "--etcd-keyfile" eq "na" hash
        check_file_value not $check_file "--enable-admission-plugins" eq "ServiceAccount" hash # no
        check_file_value set $check_file "--tls-cert-file" eq "na" hash
        check_file_value set $check_file "--tls-private-key-file" eq "na" hash
        check_file_value set $check_file "--client-ca-file" eq "na" hash
        check_file_value is $check_file "--tls-cipher-suites" eq "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AE S_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM _SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM _SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256" hash
        check_file_value set $check_file "--etcd-cafile" eq "na" hash
        check_file_value is $check_file "--enable-admission-plugins" eq "NodeRestriction" hash # yes
        check_file_value set $check_file "--experimental-encryption-provider-config" eq "na" hash
        # 1.1.35 Ensure that the encryption provider is set to aescbc
        check_file_value is $check_file "--enable-admission-plugins" eq "EventRateLimit" hash # yes
        check_file_value set $check_file "--admission-control-config-file" eq "na" hash
        check_file_value not $check_file "--feature-gates" eq "AdvancedAuditing=false" hash # no
      fi
      check_file="/etc/kubernetes/apiserver"
      if [ -f "$check_file" ]; then
        check_file_value is $check_file "KUBE_API_ARGS" eq "--feature-gates=AllAlpha=true" hash
      fi
    fi
  fi
}