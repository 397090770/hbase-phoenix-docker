FROM iteblog/hbase-docker:1.0
MAINTAINER iteblog https://www.iteblog.com

RUN apt-get update && apt-get install -y supervisor python-pip && pip install supervisor-stdout
#RUN yum -y update && 
#RUN yum install -y wget && yum install -y epel-release && yum install -y supervisor &&  yum install -y python-pip && pip install supervisor-stdout
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV BUILD_REPO=http://archive.apache.org/dist/phoenix
ENV PHOENIX_VERSION=5.0.0
ENV BUILD_QUALIFIER=''
ENV HBASE_VERSION=2.0

RUN mkdir /phoenix-setup
WORKDIR /phoenix-setup

ADD install-phoenix.sh /phoenix-setup/install-phoenix.sh
RUN ./install-phoenix.sh

EXPOSE 8765

WORKDIR /opt/hbase/conf
ADD phoenix-changes.sed /opt/hbase/conf/changes.sed
RUN sed -i -f changes.sed  hbase-site.xml && rm changes.sed

CMD ["/usr/bin/supervisord"]
