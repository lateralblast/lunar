#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_kubernetes_all
#
# Audit Kubernetes 
#
# All the Kubernetes specific tests
#.

audit_kubernetes_all () {
  audit_kubernetes_apiserver
  audit_kubernetes_scheduler
  audit_kubernetes_controller
  audit_kubernetes_etcd
  audit_kubernetes_kubelet
}

