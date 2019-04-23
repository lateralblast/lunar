# audit_kubernetes_apiserver
#
# Refer to Section(s) 1.1.1-39 Page(s) 13-88 CIS Kubernetes Benchmark v1.4.0
#.

audit_kubernetes_apiserver () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    check_file="/etc/kubernetes/manifests/kube-apiserver.yaml"
    if [ -f "$check_file" ]; then
      check_file_value $check_file "--anonymous-auth" eq "false" hash 
      disable_value $check_file "--basic-auth-file" hash
      disable_value $check_file "--insecure-allow-any-token" hash
      check_file_value $check_file "--kubelet-https" eq "true" hash
      disable_value $check_file "--insecure-bind-address" hash
      check_file_value $check_file "--insecure-port" eq "0" hash
      check_file_value $check_file "--profiling" eq "false" hash 
      check_file_value $check_file "--repair-malformed-updates" eq "false" hash 
      #check_file_value $check_file "--enable-admission-plugins" eq "AlwaysAdmit" hash no
      #check_file_value $check_file "--enable-admission-plugins" eq "AlwaysPullImages" hash yes
      #check_file_value $check_file "--enable-admission-plugins" eq "DenyEscalatingExec" hash yes
      #check_file_value $check_file "--enable-admission-plugins" eq "SecurityContextDeny" hash yes
      #check_file_value $check_file "--enable-admission-plugins" eq "NamespaceLifecycle" hash no
      check_file_value $check_file "--audit-log-path" eq "/var/log/apiserver/audit.log" hash
      check_file_value $check_file "--audit-log-maxage" eq "30" hash
      check_file_value $check_file "--audit-log-maxbackup" eq "10" hash
      check_file_value $check_file "--audit-log-maxsize" eq "100" hash
      check_file_value $check_file "--authorization-mode" eq "Node,RBAC" hash
      disable_value $check_file "--token-auth-file" hash
      #check_file_value $check_file "--enable-admission-plugins" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--kubelet-client-certificate" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--kubelet-client-key" eq "[A-Z,a-z]" hash
      check_file_value $check_file "--service-account-lookup" eq "true" hash
      #check_file_value $check_file "--enable-admission-plugins" eq "PodSecurityPolicy" hash yes
      #check_file_value $check_file "--service-account-key-file" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--etcd-certfile" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--etcd-keyfile" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--enable-admission-plugins" eq "ServiceAccount" hash no
      #check_file_value $check_file "--tls-cert-file" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--tls-private-key-file" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--client-ca-file" eq "[A-Z,a-z]" hash
      check_file_value $check_file "--tls-cipher-suites" eq "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AE S_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM _SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM _SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256" hash
      #check_file_value $check_file "--etcd-cafile" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--enable-admission-plugins" eq "NodeRestriction" hash yes
      #check_file_value $check_file "--experimental-encryption-provider-config" eq "[A-Z,a-z]" hash
      # 1.1.35 Ensure that the encryption provider is set to aescbc
      #check_file_value $check_file "--enable-admission-plugins" eq "EventRateLimit" hash yes
      #check_file_value $check_file "--admission-control-config-file" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--feature-gates" eq "AdvancedAuditing=false" hash no
      check_file_value $check_file "--audit-policy-file" eq "/etc/kubernetes/audit-policy.yaml" hash
      check_file_value $check_file "--request-timeout" eq "300s" hash
      check_file_value $check_file "--address" eq "127.0.0.1" hash
      check_file_value $check_file "--terminated-pod-gc-threshold" eq "10" hash
      check_file_value $check_file "--use-service-account-credentials" eq "true" hash
      #check_file_value $check_file "--service-account-private-key-file" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--root-ca-file" eq "[A-Z,a-z]" hash
      #check_file_value $check_file "--feature-gates" eq "RotateKubeletServerCertificate=true" hash yes
    fi
  fi
}