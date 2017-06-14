# FROM erlang:20.0-rc2
# breaks yaws: https://github.com/klacke/yaws/issues/309
# 1.92 doesn't work on OTP 18.1+
FROM erlang:18
# same here, but will ignore errors
MAINTAINER Chef Software, Inc. <docker@chef.io>

ADD http://plc.inf.elte.hu/erlang/dl/refactorerl-0.9.15.04_updated.tar.gz /tmp/
WORKDIR /tmp/refactorerl-0.9.15.04_updated
RUN bin/referl -build tool
ENV REFERL_ROOT=/tmp/refactorerl-0.9.15.04_updated

# yaws - "Suggested version is 1.92"
ADD http://yaws.hyber.org/download/yaws-1.92.tar.gz /tmp/
WORKDIR /tmp/yaws-1.92
RUN sed -i 's/-Werror//' src/Makefile

RUN ./configure --prefix=$REFERL_ROOT --localstatedir=$REFERL_ROOT/var --sysconfdir=$REFERL_ROOT/etc --disable-pam && \
      make && \
      make install

WORKDIR /tmp/refactorerl-0.9.15.04_updated
RUN mkdir lib/referl_repo
ADD entry.sh bin/
RUN chmod +x bin/entry.sh
ENTRYPOINT $REFERL_ROOT/bin/entry.sh
