FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y \
  make g++ \
  nginx \
  curl git \
  supervisor

ENV NODE_ENV production

RUN curl -kL git.io/nodebrew | perl - setup
ENV PATH /root/.nodebrew/current/bin:$PATH
RUN nodebrew install-binary v4.4.3
RUN nodebrew use v4.4.3

ADD package.json /tmp/package.json
RUN cd /tmp && npm install

RUN \
  chown -R www-data:www-data /var/lib/nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  rm /etc/nginx/sites-enabled/default

ADD nginx/enda-api.conf /etc/nginx/sites-enabled
ADD supervisor.conf /etc/supervisor/conf.d/

RUN mkdir -p /var/www/enda-api
RUN cp -a /tmp/node_modules /var/www/enda-api/

ADD . /var/www/enda-api
WORKDIR /var/www/enda-api

CMD ["/usr/bin/supervisord"]

EXPOSE 80
