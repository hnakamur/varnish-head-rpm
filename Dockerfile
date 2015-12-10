FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum -y install epel-release \
 && yum -y install rpmdevtools rpm-build patch python-pip \
 && pip install copr-cli \
 && rpmdev-setuptree

ADD SPECS/ /root/rpmbuild/SPECS/
ADD SOURCES/ /root/rpmbuild/SOURCES/

ADD build-varnish-head-srpm.sh /root/rpmbuild/
RUN chmod +x /root/rpmbuild/build-varnish-head-srpm.sh
# NOTE: I had to separate commands in two RUN's here.
# RUN chmod +x /root/rpmbuild/build-varnish-head-srpm.sh  && /root/rpmbuild/build-varnish-head-srpm.sh
# causes the following error:
#   /bin/sh: /root/rpmbuild/build-varnish-head-srpm.sh: /bin/bash: bad interpreter: Text file busy
RUN /root/rpmbuild/build-varnish-head-srpm.sh

ADD copr-build.sh /root/rpmbuild/
RUN chmod +x /root/rpmbuild/copr-build.sh
CMD ["/root/rpmbuild/copr-build.sh"]
