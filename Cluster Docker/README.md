Criando um Cluster de Docker Swarm do Zero até o deploy da Applicação
=============

Repositório da Live que rola dia 12/01/2022 no Yotube Canal [Infra Antenada](https://www.youtube.com/watch?v=W7o30oi70Jk)

Esse repositório contem manuais e scripts para fazer a Configuração de um Cluster de Docker Swarm e integra-lo com um Servidor NFS (que também será criado).

O passo a passo é intuitivo, porém caso queira mais informações você também pode acompanhar o video no canal do Youtube [Infra Antenada](https://www.youtube.com/watch?v=W7o30oi70Jk)

Caso queira mais informações sobre o Canal, Instagram ou quiser mais links, Acesse o [Linktree](https://linktr.ee/weslleycsil)


## Como começar

Comece criando o servidor NFS, após toda a configuração dele Feita, parta para a configuração dos nós Docker, separando em Managers e Workers. O processos dos dois tipos de nós são bem próximos, no manual correspondente será melhor explicado.

Passo a passo para configurar o Servidor NFS:
[Servidor NFS](https://github.com/weslleycsil/cursos-palestras/blob/master/Cluster%20Docker/install/NFS-Server.md)

Passo a passo para configura o Cluster Docker Swarm:
[Cluster Docker](https://github.com/weslleycsil/cursos-palestras/blob/master/Cluster%20Docker/install/Docker.md)


Arquivos Docker Compose das Stacks utilizadas como  Portainer, Traefik e aplicação Teste:
[Docker Composes](https://github.com/weslleycsil/cursos-palestras/tree/master/Cluster%20Docker/composes)

Alguns Scripts para auxiliar no dia a dia com o serviço:
[Scripts auxiliares](https://github.com/weslleycsil/cursos-palestras/tree/master/Cluster%20Docker/scripts)
