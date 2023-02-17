FROM ubuntu:22.04

RUN apt update 

ENV DEBIAN_FRONTEND noninteractive 

RUN apt install apache2 -y

#ADD beryllium /var/www/html
COPY startbootstrap-freelancer-master /var/www/html

CMD apachectl -DFOREGROUND
