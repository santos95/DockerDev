FROM ubuntu:22.04 

LABEL "inss.gob.ni"="INSS"

LABEL version="1.0"

LABEL description="Wep site with apache"

RUN apt update 

ENV DEBIAN_FRONTEND noninteractive 

RUN apt install apache2 -y

EXPOSE 80

COPY run.sh /run.sh 

CMD sh /run.sh
