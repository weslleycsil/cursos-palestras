Docker desde o Básico até a Criação do Cluster Swarm e integração com um Servidor NFS
=============

Repositório da Live que rola dia 12/01/2022 no Yotube Canal [Infra Antenada](https://www.youtube.com/watch?v=W7o30oi70Jk)

Esse repositório contem manuais e scripts para fazer a Configuração de um Cluster de Docker Swarm e integra-lo com um Servidor NFS (que também será criado).

O passo a passo é intuitivo, porém caso queira mais informações você também pode acompanhar o video no canal do Youtube [Infra Antenada](https://www.youtube.com/watch?v=W7o30oi70Jk)

Caso queira mais informações sobre o Canal, Instagram ou quiser mais links, Acesse o [Linktree](https://linktr.ee/weslleycsil)


## Como começar

Comece criando o servidor NFS, após toda a configuração dele Feita, parta para a configuração dos nós Docker, separando em Managers e Workers. O processos dos dois tipos de nós são bem próximos, no manual correspondente será melhor explicado.

[Pré-requisitos e Inicio](https://github.com/weslleycsil/cursos-palestras/tree/master/Docker%20do%20basico%20ao%20Cluster%20Swarm%20com%20NFS/install)

Passo a passo para configurar o Servidor NFS:
[Servidor NFS](https://github.com/weslleycsil/cursos-palestras/blob/master/Docker%20do%20basico%20ao%20Cluster%20Swarm%20com%20NFS/install/NFS-Server.md)

Passo a passo para configura o Cluster Docker Swarm:
[Cluster Docker](https://github.com/weslleycsil/cursos-palestras/blob/master/Docker%20do%20basico%20ao%20Cluster%20Swarm%20com%20NFS/install/Docker.md)


Arquivos Docker Compose das Stacks utilizadas como  Portainer, Traefik e aplicação Teste:
[Docker Composes](https://github.com/weslleycsil/cursos-palestras/tree/master/Docker%20do%20basico%20ao%20Cluster%20Swarm%20com%20NFS/composes)

Alguns Scripts para auxiliar no dia a dia com o serviço:
[Scripts auxiliares](https://github.com/weslleycsil/cursos-palestras/tree/master/Docker%20do%20basico%20ao%20Cluster%20Swarm%20com%20NFS/scripts)
