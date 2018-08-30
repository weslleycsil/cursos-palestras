# Curso Aprender Docker Pra Que?

Esse repositório contém os códigos utilizados durante o mini curso de Aprender Docker pra Que?

  
 Você encontra os slides utilizados em:  []()

 # O Curso

 A idéia desse mini curso é apresentar todo o conceito geral de docker, docker compose, imagem docker e containers.

 # Requisitos

Para poder utilizar o material aqui disponibilizado, será necessário um Computador com o seguinte ambiente configurado:

- Instalação do Docker 17.0.3 ou posterior
- Instalação do Docker Compose
- Acesso à internet para a obtenção das imagens do Containers utilizados

Para instalar Basta executar os seguintes comandos abaixo em seu ambiente Linux/MacOS:
<dt>Docker</dt>

    wget -qO- https://get.docker.com/ | sh

<dt>Docker Compose</dt>

	COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

Para permitir que um usuário utilize o docker sem o comando sudo, basta executar o comando abaixo, substituindo 'nome-usuario' pelo nome do seu usuario.

	sudo usermod -aG docker nome-usuario
     
    
# Primeiro Programa com NodeJS

O código abaixo deve ser salvo com a extensão .js e depois ser executado com: `node server.js`

    var http = require('http'), host = '127.0.0.1', port = '9000';
    var server = http.createServer(function(req, res) {
	    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
	    res.end("Olá mundo! Experimentando Node.js</h1>");
	})
	
	.listen(port, host, function() {
		console.log('Servidor rodando em http://' + host + ':' + port);
	});

# Comandos Úteis

<dt>Fazer o Build de uma Imagem</dt>

    docker build -t weslleycsil/docker-node-api .

<dt>Logar no Docker Hub</dt>

    docker login
    
<dt>Enviar uma Imagem ao Docker Hub</dt>

    docker push weslleycsil/docker-node-api
    
<dt>Iniciar um Cluster Swarm</dt>

    docker swarm init
    
<dt>Criar uma Stack de Serviços</dt>

    docker stack deploy -c app-principal.yml app-principal
    
<dt>Executar um Container de Hello World</dt>

    docker run hello-world