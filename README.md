# Nginx Unit Demo

Example Go Nginx Unit application running on local KinD Kubernetes cluster
* [Install Porter](https://getporter.org/install/)
* Install Nginx Unit Demo
  * `porter install --allow-docker-host-access --reference ghcr.io/bdegeeter/porter-nginx-unit-demo:v0.1.1 porter-nginx-unit-demo`
* Go to `http://nginx-unit-demo.localtest.me`
* Get the local KinD kubeconfig for the cluster
  * `porter installation output show -i porter-nginx-unit-demo kubeconfig >nginx-unit-kubeconfig`
  * `KUBECONFIG=nginx-unit-kubeconfig k9s`
* Uninstall Nginx Unit Demo
  * `porter uninstall --allow-docker-host-access --reference ghcr.io/bdegeeter/porter-nginx-unit-demo:v0.1.1`
