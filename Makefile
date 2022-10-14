
REGISTRY?=ghcr.io/bdegeeter/nginx-unit-go-demo
VERSION=0.1.1

.PHONY: build-image
build-image:
	docker buildx build . --tag $(REGISTRY):v$(VERSION)

.PHONY: publish-image
publish-image: build-image
	docker push $(REGISTRY):v$(VERSION)

.PHONY: build-bundle
build-bundle:
	cd installer && porter build --version=$(VERSION)

.PHONY: publish-bundle
publish-bundle:
	cd installer && porter publish

.PHONY: install-bundle
install-bundle:
	cd installer && porter install --allow-docker-host-access --debug && \
	porter installation output show kubeconfig > ../demo.kubeconfig

.PHONY: uninstall-bundle
uninstall-bundle:
	cd installer && porter uninstall --allow-docker-host-access --debug

.PHONY: bundle-kubeconfig
bundle-kubeconfig:
	cd installer && porter installation output show kubeconfig >demo.kubeconfig