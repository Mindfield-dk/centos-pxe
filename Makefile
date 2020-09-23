ORG=localgod
APP=centos-pxe
VERSION=latest
IMAGE=${ORG}/${APP}:${VERSION}

.PHONY: build run

build:
	@docker build -t ${IMAGE} .

run:
	@docker run --rm -it ${IMAGE}
