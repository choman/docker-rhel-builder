FROM ubuntu:latest

ENV RHEL_DIR=/rhel

##ENV http_proxy=http://128.132.9.10:8080
##ENV https_proxy=http://128.132.9.10:8080

VOLUME /mnt:/mnt

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y yum rpm
RUN apt-get -y install vim

ADD src /scripts
RUN chmod 700 /scripts/script.sh

CMD [ "echo", "hello" ]
CMD ["/scripts/script.sh"]

