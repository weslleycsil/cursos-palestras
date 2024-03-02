
docker run -it -v ./bin:/opt/src/binarios ipxe-compiler:latest bash

docker build --pull --rm -f "./Dockerfile" -t ipxe-compiler:latest "compiler-ipxe"