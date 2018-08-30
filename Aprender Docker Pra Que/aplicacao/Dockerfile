#Iniciar pela imagem do Node
FROM node:carbon

#Pasta de Trabalho do APP dentro do Container
WORKDIR /usr/src/app

#Copiar arquivos necessários para fazer a instalação do app
COPY ./app/package.json /usr/src/app

COPY ./app/package-lock.json /usr/src/app

RUN npm install

COPY ./app/ /usr/src/app

EXPOSE 8080