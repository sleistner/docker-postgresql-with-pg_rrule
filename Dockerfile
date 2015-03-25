FROM sameersbn/ubuntu:14.04.20150323
MAINTAINER jtrantin@redhat.com

ENV PG_VERSION 9.4
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && apt-get install -y postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} postgresql-server-dev-${PG_VERSION} pwgen unzip qt4-qmake make gcc g++ libical1 libical-dev libc6-dev \
 && rm -rf /var/lib/postgresql \
 && rm -rf /var/lib/apt/lists/* # 20150323
 

RUN mkdir /tmp/pg_rrule \
 && cd /tmp/pg_rrule \
 && wget https://github.com/petropavel13/pg_rrule/archive/master.zip \
 && unzip master.zip \
 && cd pg_rrule-master/src \
 && ln -s /usr/include/postgresql/${PG_VERSION}/server/ /usr/include/postgresql/server \
 && qmake-qt4 pg_rrule.pro \
 && make \
 && cp libpg_rrule.so /usr/lib/postgresql/${PG_VERSION}/lib/pg_rrule.so \
 && cp ../pg_rrule.control /usr/share/postgresql/${PG_VERSION}/extension \
 && cp ../sql/pg_rrule.sql /usr/share/postgresql/9.4/extension/pg_rrule--0.2.0.sql

ADD start /start
RUN chmod 755 /start

EXPOSE 5432

VOLUME ["/var/lib/postgresql"]
VOLUME ["/run/postgresql"]

CMD ["/start"]
