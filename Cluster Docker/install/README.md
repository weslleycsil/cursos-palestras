## Pré-requisitos

Para fazer por completo esse tutorial, você irá necessitar de pelo menos duas Máquinas Virtuais, sendo que o ideal seja de pelo menos 4 máquinas, cada uma com duas interfaces de rede uma interna e uma externa.

## Características do Lab

Serão 4 Máquinas virtuais Centos 7 instaladas e atualizadas. Todas elas deverão ter 2 interfaces de rede, uma para tráfego interno e outra para tráfego externo.

Das 4 máquinas, 3 serão utilizadas para o Cluster Docker e 1 para o Servidor NFS.

## Servidor NFS

Para o servidor NFS, aconselho efetuar a instalação do sistema, atualizar e depois de tudo pronto você adicionar um segundo e terceiro disco, para poder efetuar a criação do volume com LVM para o NFS e o terceiro disco para poder fazer a expansão do volume criado anteriormente.

[Instruções para o Servidor NFS](https://github.com/weslleycsil/cursos-palestras/blob/master/Cluster%20Docker/install/NFS-Server.md)

## Cluster Docker

Para o cluster serão 3 maquinas, sendo uma delas um Manager e duas Workers. [Pelas boas práticas](https://docs.docker.com/engine/swarm/admin_guide/) do Docker Swarm e etc, se deve ter mais nós Managers... mas não levaremos em consideração isso já que estamos apenas tratando de um Lab.

Então serão 1 Manager e 2 Workers, o processo é práticamente igual, mudando apenas o comando de iniciar o swarm.

Instruções para o [Cluster Docker](https://github.com/weslleycsil/cursos-palestras/blob/master/Cluster%20Docker/install/Docker.md)