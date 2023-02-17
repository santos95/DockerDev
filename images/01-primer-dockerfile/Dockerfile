FROM ubuntu:22.04

RUN apt update 

ENV DEBIAN_FRONTEND noninteractive 

RUN apt install apache2 -y

CMD apachectl -DFOREGROUND
