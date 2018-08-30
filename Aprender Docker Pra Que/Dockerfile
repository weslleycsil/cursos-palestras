#Iniciar pela imagem do Node
FROM node:10

LABEL "com.example.vendor"="Weslley Silva"
LABEL com.example.label-with-value="https://twcreativs.com.br"
LABEL version="1.0"
LABEL description="Serviço VOD de Streaming - API"

#Pasta de Trabalho do APP dentro do Container
WORKDIR /usr/src/app

#Copiar arquivos necessários para fazer a instalação do app
COPY ./api/package*.json /usr/src/app/

RUN npm install

COPY ./api/ /usr/src/app

EXPOSE 8080
VOLUME ["/usr/src/app/uploads/","/usr/src/app/files/"]
CMD [ "npm", "start" ]