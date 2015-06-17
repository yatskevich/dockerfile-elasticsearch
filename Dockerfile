#
# ElasticSearch Dockerfile
# Based on dockerfile/elasticsearch
#
# https://github.com/yatskevich/dockerfile-elasticsearch
#

# Pull base image.
FROM ubuntu:14.04.2
 
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /opt/jdk/jre
ENV PATH $PATH:/opt/jdk/jre/bin
 
RUN apt-get update && apt-get install -y wget
 
RUN wget --no-check-certificate -O /tmp/pkg.tar.gz --header "Cookie: oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz && \
    tar -zxf /tmp/pkg.tar.gz --xform='s/[^\/]*/jdk/' -C /opt && \
    rm -rf /tmp/*

ENV ES_PKG_NAME elasticsearch-1.5.2

# Install ElasticSearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Install HEAD plugin
RUN \
  cd /elasticsearch && \
  bin/plugin -i mobz/elasticsearch-head

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
