FROM ruby:2.2.8

RUN apt-get update -qq && apt-get install -y --force-yes --no-install-recommends\
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      git \
      lsb-release \
      python-all \
      rlwrap \
      libpq-dev \
      libxml2-dev \
      libxslt1-dev \
 && rm -rf /var/lib/apt/lists/*;

# from https://github.com/nodejs/docker-node/blob/master/8/Dockerfile
RUN set -ex \
  && for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done

ENV NODE_VERSION 8.9.1

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp\
 && npm cache clear\
 && node-gyp configure || echo ""


RUN apt-get update \
 && apt-get upgrade -y --force-yes \
 && rm -rf /var/lib/apt/lists/*;

ENV NODE_ENV production

RUN echo "America/Toronto" > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN npm install -g bower
#RUN npm install -g npm && npm cache clear

RUN mkdir /app
WORKDIR /app

ENV RAILS_ENV production

ADD Gemfile Gemfile.lock /app/
RUN bundle config git.allow_insecure true && bundle install --deployment --without="development test"

ADD .bowerrc bower.json /app/
RUN bower install --allow-root

ADD client/package.json /app/client/package.json
RUN cd /app/client && npm install && npm cache clear --force

EXPOSE 3000
ENV PORT 3000
# CMD ["/start", "web"]

CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb"]

#ENV DATABASE_URL postgres://postgres@postgres.service.consul/mobilling_staging

ADD . /app

RUN rake assets:precompile && rake custom:create_non_digest_assets
