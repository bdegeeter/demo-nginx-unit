#!/usr/bin/env bash
set -euo pipefail
K8S_CFG=/home/nonroot/.kube/config
CLUSTER_NAME=nginx-unit-k8s-kind

install() {
  echo Create KinD Cluster
  kind create cluster --name ${CLUSTER_NAME} --kubeconfig=${K8S_CFG} --config=/cnab/app/kind.cluster.config --wait=40s
  cp ${K8S_CFG} /cnab/app/kind.kubeconfig
  echo hostname
  env |grep HOSTNAME
  docker network connect kind ${HOSTNAME}
  KIND_DIND_IP=$(docker inspect -f "{{ .NetworkSettings.Networks.kind.IPAddress }}" ${CLUSTER_NAME}-control-plane)
  sed -i -e "s@server: .*@server: https://${KIND_DIND_IP}:6443@" /home/nonroot/.kube/config
  #docker pull ${1}
  #kind load docker-image "${1}" --name ${CLUSTER_NAME}
  kubectl create namespace ingress-nginx
  kubectl create namespace nginx-unit
  kubectl apply -k deploy/local/
  echo "Browse to http://nginx-unit-demo.localtest.me to see you local deployment"
}

upgrade() {
  echo "TODO: Support Upgrade"
}

uninstall() {
  echo Delete KinD Cluster
  kind delete cluster --name ${CLUSTER_NAME}
}

# Call the requested function and pass the arguments as-is
"$@"
