FROM ubuntu:22.04 

LABEL "inss.gob.ni"="INSS"

LABEL version="1.0"

LABEL description="Wep site with apache"

RUN apt update 

ENV DEBIAN_FRONTEND noninteractive 

RUN apt install apache2 -y

RUN echo "$(whoami)" > /var/www/html/user1.html 

RUN adduser docker 

USER docker 

RUN echo "$(whoami)" > /tmp/user2.html

USER root 

RUN cp /tmp/user2.html /var/www/html/user2.html 

VOLUME /var/www/html/

EXPOSE 80

CMD apachectl -DFOREGROUND
