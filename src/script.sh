#!/bin/bash

RHEL_DIR=/rhel
JEDI=0

LANG="--setopt=override_install_langs=en"
DOCS="--setopt tsflags=nodocs"

mkdir -p ${RHEL_DIR}/var/lib/rpm ${RHEL_DIR}/etc/yum.repos.d/

rpm --root ${RHEL_DIR} --initdb

if [ -f "/mnt/JEDI.tgz" ]; then
    BASE="/mnt/Packages/rhel-x86_64-server-6/getPackage"
else
    BASE="/mnt/Packages"
fi

rpm --root ${RHEL_DIR} -ihv ${BASE}/redhat-release*

cp -v /scripts/rhel-dvd.repo ${RHEL_DIR}/etc/yum.repos.d/
cat ${RHEL_DIR}/etc/yum.repos.d/rhel-dvd.repo

yum -y --installroot=${RHEL_DIR} $LANG $DOCS install yum rpm

if [ -f "/mnt/RPM-GPG-KEY-redhat-release" ]; then
    keyfile="/mnt/RPM-GPG-KEY-redhat-release"
else
    keyfile="/mnt/RPM-GPG-KEY-CentOS-7"
fi

rpm --root=${RHEL_DIR} --import $keyfile

echo ""
echo "installing extra software"
yum -y --installroot=${RHEL_DIR} $LANG $DOCS localinstall ${BASE}/unzip*rpm

echo ""
echo "updating software"
yum -y --installroot=${RHEL_DIR} $LANG $DOCS update

echo "RHEL Docker Image" > ${RHEL_DIR}/etc/motd

##echo "Something Something JEDI"
##tar -C ${RHEL_DIR}/opt -xpf /scripts/JEDI.tgz
##chroot ${RHEL_DIR} /opt/JEDI/Scripts/config.Lockdown -s /opt/JEDI/config


echo "cleanup"
rm ${RHEL_DIR}/etc/yum.repos.d/rhel-dvd.repo
rm -rf ${RHEL_DIR}/var/cache/yum/*

echo "creating image tarball"
tar -C ${RHEL_DIR} -cpf /output/rhel_base.tgz .
du -sh /output/rhel_base.tgz 

grep -i centos $RHEL_DIR/etc/redhat-release
if [ $? -eq 0 ]; then
    os=centos
    vers=$(awk '{print $4}' $RHEL_DIR/etc/redhat-release | awk -F . '{printf ("%d.%d", $1, $2)}')
else
    os=rhel
    vers=$(awk '{print $7}' $RHEL_DIR/etc/redhat-release)
fi

cat $RHEL_DIR/etc/redhat-release
echo $os
echo $vers

echo ""
echo "---------------------------------------------------------"
echo ""
echo "run --> docker import - base/${os}:${vers} < output/rhel_base.tgz"
echo ""
