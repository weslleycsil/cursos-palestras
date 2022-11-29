# Configuração das Stacks no Cluster

Após feita toda a configuração do cluster, é hora de subir algumas stacks para podermos começar a trabalhar com o cluster.

Serão 3 Stacks que subiremos, a do [Portainer](#portainer), a do [Traefik](#traefik) e a da nossa [Aplicação](#aplicação-final). Também subiremos uma stack [exemplo](#aplicação-exemplo) apenas para testes.

## Portainer

Para podermos trabalharmos de forma um pouco mais gráfica (é sempre  bom sabermos os comandos mesmo com interface), iremos subir um portainer para gerenciar e subir stacks e mais algumas outras coisas.

Para isso, basta você efetuar o download do arquivo [portainer.yml](https://raw.githubusercontent.com/weslleycsil/cursos-palestras/master/Cluster%20Docker/composes/portainer.yml) e executar o seguinte comando no Nó Manager do seu Cluster:
```
docker stack deploy --compose-file=portainer.yml portainer
```

Cabe lembrar, que você deve passar a localização do arquivo no comando, portanto lembre-se de acessar a pasta onde está o arquivo antes, ou passar o caminho completo.

Informações importante sobre o conteúdo dessa stack:
```
services:
  agent:
    image: portainer/agent
    environment:
      # REQUIRED: Should be equal to the service name prefixed by "tasks." when
      # deployed inside an overlay network
      AGENT_CLUSTER_ADDR: tasks.agent
      # AGENT_PORT: 9001
      # LOG_LEVEL: debug
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
    networks:
      - agent_network
    deploy:
      mode: global
      placement:
        constraints: [node.platform.os == linux]
  
  portainer:
    image: portainer/portainer
    command: -H tcp://tasks.agent:9001 --tlsskipverify
    ports:
      - "9000:9000"
    volumes:
      - portainer_data:/data
    networks:
      - agent_network
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == manager]
```

Temos dois serviços basicamente, um do agente do portainer que roda globalmente em todos os nós do cluster, e o serviço do portainer que roda somente nos nós que são Manager, isso porque apenas os Manager que tem conectividade externa, então como é feito um mapeamento da porta 9000 do host com a porta 9000 do portainer (container) é preciso ter certeza que é um Manager.

Outro ponto também importante é sobre o volume, que é um volume configurado via NFS e não um volume comum do Docker:
```
volumes:
  portainer_data:
    driver: local
    driver_opts:
      type: nfs
      o: nfsvers=4,addr=10.10.10.250,rw
      device: ":/NFS_VOL/HDD/portainer"
```

## Traefik

Para quem não conhece, o traefik é uma das melhores soluções de encaminhamento do planeta (na minha humilde opinião).
Ele facilmente substitui o nginx para fazer o encaminhamento de requisições para os containers/serviços.

[<img src="https://doc.traefik.io/traefik/assets/img/traefik-architecture.png">](https://doc.traefik.io/traefik/)


Para sairmos utilizando ele, eu gosto de configurar manualmente a rede do serviço, você pode fazer isso direto pela interface do portainer ou também utilizando os comandos abaixo:
```
docker network create \
  --driver overlay \
  --subnet 11.11.11.0/24 \
  --gateway 11.11.11.1 \
  traefik_proxy
```

Esses comandos acima, basicamente criam uma rede do tipo overlay em todo o cluster, onde a rede será 11.11.11.0/24 e o gw será 11.11.11.1 bem simples. A partir de agora, todos os serviços que terão "vista" para a internet devem ser expostos à essa rede, sendo assim, ela que receberá nossas requisições externas.

Você pode fazer o deploy da stack diretamente no portainer copiando o conteúdo do arquivo [traefik.yml](https://raw.githubusercontent.com/weslleycsil/cursos-palestras/master/Cluster%20Docker/composes/traefik.yml) ou baixando ele para a máquina e executando o comando abaixo:
```
docker stack deploy --compose-file=traefik.yml traefik
```

Eu particurlarmente prefiro por fazer o deploy da stack pelo portainer, pois facilita caso eu precise fazer alguma modificação no serviço, assim faço direto pela interface e não preciso ir no arquivo e executar o comando para atualizar o serviço

Informações importante sobre o conteúdo dessa stack:
```
command:
  - "--api"
  - "--entrypoints=Name:http Address::80 Redirect.EntryPoint:https"
  - "--entrypoints=Name:https Address::443 TLS"
  - "--defaultentrypoints=http,https"
  - "--acme"
  - "--acme.storage=/data/acme.json"
  - "--acme.entryPoint=https"
  - "--acme.httpChallenge.entryPoint=http"
  - "--acme.onHostRule=true"
  - "--acme.onDemand=false"
  - "--acme.email=email@gmail.com"
  - "--docker"
  - "--docker.swarmMode"
  - "--docker.domain=dominio.com.br"
  - "--docker.watch"
```

Acima temos alguns comandos importantes como:

- "--entrypoints=Name:http Address::80 Redirect.EntryPoint:https" -> habilitamos o redirecionamento de http para https forçado
- "--acme.email=email@gmail.com" -> nosso email para gerar os certificados pelo Let's Encrypt
- "--docker.domain=dominio.com.br" -> dominio do nosso cluster, para poder gerar o certificados.

Outro ponto também importante é sobre o volume, que é um volume configurado via NFS e não um volume comum do Docker:
```
volumes:
  traefik_data:
    driver: local
    driver_opts:
      type: nfs
      o: nfsvers=4,addr=10.10.10.250,rw
      device: ":/NFS_VOL/HDD/traefik"
```

## Aplicação Exemplo

## Aplicação Final