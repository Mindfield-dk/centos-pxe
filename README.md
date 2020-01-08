# CentOS PXE Server

## Description
This is a PXE server based on CentOS providing CentOS

## Build
```bash
make build
```

## Run

```bash
docker run --rm -d -p 69:69 -p 4011:4011 mindfield/centos-pxe:latest
```
