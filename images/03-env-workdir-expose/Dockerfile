FROM ubuntu:22.04

RUN apt update 

ENV DEBIAN_FRONTEND noninteractive 

RUN apt install apache2 -y

WORKDIR /var/www/html

COPY startbootstrap-freelancer-master .

ENV contenido comando_env

RUN echo "${contenido}" > variables.html

EXPOSE 80

CMD apachectl -DFOREGROUND
