O arquivo em scripts/compilar.sh precisa ser modificado de acordo com o seu ambiente, nesse caso eu adicionei o endereço ip do Lab utilizado nesse repositório, mas você deve colocar o ip do servidor tftp da sua rede.

Compile a imagem docker primeiro:\
docker build --pull --rm -f "./Dockerfile" -t ipxe-compiler:latest "./"

Execute a imagem para compilar os binarios do ipxe:\
docker run -it -v ./bin:/opt/src/binarios ipxe-compiler:latest bash