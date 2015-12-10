FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum -y install epel-release \
 && yum -y install rpmdevtools rpm-build patch python-pip \
 && pip install copr-cli \
 && rpmdev-setuptree

ADD SPECS/ /root/rpmbuild/SPECS/
ADD SOURCES/ /root/rpmbuild/SOURCES/

RUN spec_file=/root/rpmbuild/SPECS/varnish.spec \
 && VARNISH_HEAD_GIT_COMMIT=`awk '/^%define\s+varnish_git_commit/ {print $3}' ${spec_file}` \
 && cd /root/rpmbuild/SOURCES \
 && curl -sLO https://github.com/varnish/Varnish-Cache/archive/${VARNISH_HEAD_GIT_COMMIT}.tar.gz#/Varnish-Cache-${VARNISH_HEAD_GIT_COMMIT}.tar.gz \
 && rpmbuild -bs ${spec_file}

ADD copr-build.sh /root/
ENTRYPOINT ["/bin/bash", "/root/copr-build.sh"]
