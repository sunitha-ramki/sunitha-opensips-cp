
all: build start

.PHONY: build start
build:
	docker build --tag="ocp-v1" .

start:
	docker run --name ocpv1 -p 192.168.0.103:95:80 -d ocp-v1:latest
