# DOCKER-VERSION 0.5.3

FROM vproke/debian-chef-solo

MAINTAINER Vaclav Prokes <vproke@gmail.com>

# UPDATE REPOS
RUN apt-get -y update

# INSTALL CORE DEPENDENCIES
RUN apt-get -yqq install apt-utils locales supervisor sudo net-tools curl

# SETUP LOCALES
# This block became necessary with the new chef 12
RUN echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8

# PREPARE AND RUN CHEF
ADD chef /chef
RUN cd /chef && /opt/chef/embedded/bin/berks vendor /chef/cookbooks
RUN chef-solo -c /chef/solo.rb -j /chef/solo.json

# PREPARE FLEXIBEE ADMIN USER - TODO
#ADD flexibee-admin-batch.xml /tmp/flexibee-admin-batch.xml
#RUN curl https://localhost:5434/admin/batch -k -T /tmp/flexibee-admin-batch.xml

# CONFIGURE VOLUMES
VOLUME  ["/etc/flexibee". "/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

EXPOSE 5435 5432 5434

# PREPARE AND RUN SUPERVISOR
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-flexibee.sh /supervisord-flexibee.sh
RUN chmod 755 /supervisord-flexibee.sh

CMD ["/usr/bin/supervisord"]
