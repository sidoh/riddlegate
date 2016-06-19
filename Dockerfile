FROM ruby:2.3

MAINTAINER sidoh "https://github.com/sidoh"

RUN gem update --system
RUN gem install bundler

RUN git clone https://github.com/sidoh/riddlegate /root/riddlegate
RUN cd /root/riddlegate
RUN git checkout docker
RUN bundle install

ENV RACK_ENV=docker

EXPOSE 4567
CMD ["/root/riddlegate/bin/run.sh"]
