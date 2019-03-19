#!/bin/bash -eux

echo "==> Clear out machine id"
rm -f /etc/machine-id
touch /etc/machine-id
find /var/log/ -name *.log -exec rm -f {} \;
yum install -y yum-utils
package-cleanup --oldkernels --count=1 -y

echo "==> Removing tools used to build virtual machine drivers"
yum -y remove gcc libmpc mpfr cpp kernel-devel kernel-headers expect

echo "==> Clean up yum cache of metadata and packages to save space"
yum -y --enablerepo='*' clean all

echo "==> Removing temporary files used to build box"
rm -rf /tmp/*

echo "==> Rebuild RPM DB"
rpmdb --rebuilddb
rm -f /var/lib/rpm/__db*
