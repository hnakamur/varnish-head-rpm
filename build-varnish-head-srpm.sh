#!/bin/bash
set -eu
topdir=`rpm --eval '%{_topdir}'`
spec_file=${topdir}/SPECS/varnish.spec
VARNISH_HEAD_GIT_COMMIT=`awk '/^%define\s+varnish_git_commit/ {print $3}' ${spec_file}`
cd ${topdir}/SOURCES
curl -sLO https://github.com/varnish/Varnish-Cache/archive/${VARNISH_HEAD_GIT_COMMIT}.tar.gz#/Varnish-Cache-${VARNISH_HEAD_GIT_COMMIT}.tar.gz
rpmbuild -bs ${spec_file}
