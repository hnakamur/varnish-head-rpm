#!/bin/bash
set -e
project_name=varnish-head
rpm_name=varnish
topdir=`rpm --eval '%{_topdir}'`
spec_file=${topdir}/SPECS/${rpm_name}.spec

mkdir -p $HOME/.config
cat > $HOME/.config/copr <<EOF
[copr-cli]
login = ${COPR_LOGIN}
username = ${COPR_USERNAME}
token = ${COPR_TOKEN}
copr_url = https://copr.fedoraproject.org
EOF

# See https://urllib3.readthedocs.org/en/latest/security.html#without-modifying-code
export PYTHONWARNINGS="ignore:Unverified HTTPS request"

status=`curl -s -o /dev/null -w "%{http_code}" https://copr.fedoraproject.org/api/coprs/${COPR_USERNAME}/${project_name}/detail/`
if [ $status = "404" ]; then
  copr-cli create --chroot epel-7-x86_64 \
--description \
'HEAD version of Varnish High-performance HTTP accelerator' \
--instructions \
"\`\`\`
sudo curl -sL -o /etc/yum.repos.d/hnakamur-${project_name}.repo https://copr.fedoraproject.org/coprs/hnakamur/${project_name}/repo/epel-7/hnakamur-${project_name}-epel-7.repo
\`\`\`

\`\`\`
sudo yum install ${rpm_name}
\`\`\`" \
${project_name}
fi
version_release=`rpmspec -P ${spec_file} | awk '
$1=="Version:" { version=$2 }
$1=="Release:" { release=$2 }
END { printf("%s-%s", version, release) }'`
srpm_file=${topdir}/SRPMS/${rpm_name}-${version_release}.src.rpm
copr-cli build --nowait ${project_name} ${srpm_file}
rm $HOME/.config/copr
