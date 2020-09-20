# audit_kubernetes_kubelet
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

audit_kubernetes_kubelet () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    daemon_check=$( ps -ef | grep "kubelet" | grep -v grep )
    if [ "$daemon_check" ]; then
      check_file="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
      if [ -f "$check_file" ]; then
        check_file_perms $check_file 0755 root root
        check_file_value is $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--anonymous-auth=false" hash
        check_file_value is $check_file "KUBELET_AUTHZ_ARGS" eq "--authorization-mode=Webhook" hash
        check_file_value is $check_file "KUBELET_AUTHZ_ARGS" eq "--client-ca-file=[A-Z,a-z]" hash
        check_file_value is $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--read-only-port=0" hash
        check_file_value is $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--streaming-connection-idle-timeout=5m" hash
        check_file_value is $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--protect-kernel-defaults=true" hash
        check_file_value not $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--make-iptables-util-chains" hash
        check_file_value not $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--hostname-override" hash
        check_file_value is $check_file "KUBELET_SYSTEM_PODS_ARGS" eq "--event-qps=0" hash
        check_file_value is $check_file "KUBELET_CERTIFICATE_ARGS" eq "--tls-cert-file=[A-Z,a-z]" hash
        check_file_value is $check_file "KUBELET_CERTIFICATE_ARGS" eq "--tls-private-key-file=[A-Z,a-z]" hash
        check_file_value is $check_file "KUBELET_CADVISOR_ARGS" eq "--cadvisor-port=0" hash - contains
        check_file_value is $check_file "KUBELET_CERTIFICATE_ARGS" eq "--rotate-certificates=true" hash
        check_file_value is $check_file "KUBELET_CERTIFICATE_ARGS" eq "--feature-gates=RotateKubeletServerCertificate=true" hash
        check_file_value is $check_file "--tls-cipher-suites" eq "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AE S_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1verbose_message "5,TLS_ECDHE_RSA_WITH_AES_256_GCM _SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1verbose_message "5,TLS_ECDHE_ECDSA_WITH_AES_256_GCM _SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256" hash
      fi
    fi
  fi
}