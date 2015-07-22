#!/bin/bash

if [[ -z "$1" ]]
then
echo Argument 1 must be Zato version
    exit 1
fi

ZATO_VERSION=$1

CURDIR="${BASH_SOURCE[0]}";RL="readlink";([[ `uname -s`=='Darwin' ]] || RL="$RL -f")
while([ -h "${CURDIR}" ]) do CURDIR=`$RL "${CURDIR}"`; done
N="/dev/null";pushd .>$N;cd `dirname ${CURDIR}`>$N;CURDIR=`pwd`;popd>$N

SOURCE_DIR=$CURDIR
TMP_DIR=/opt/tmp
RPM_BUILD_DIR=/root/rpmbuild

function prepare {
  yum install -y rpm-build rpmdevtools wget
  rpmdev-setuptree
}

function cleanup {
    rm -rf $TMP_DIR
    rm -rf $RPM_BUILD_DIR/BUILDROOT
}

function build_rpm {
    rm -f $SOURCE_DIR/zato.spec
    cp $SOURCE_DIR/zato.spec.template $SOURCE_DIR/zato.spec
    sed -i.bak "s/ZATO_VERSION/$ZATO_VERSION/g" $SOURCE_DIR/zato.spec
    mkdir -p $RPM_BUILD_DIR/SPECS/
    cp $SOURCE_DIR/zato.spec $RPM_BUILD_DIR/SPECS/

    mkdir $RPM_BUILD_DIR/BUILDROOT
    mkdir $RPM_BUILD_DIR/BUILDROOT/zato-metapackage-$ZATO_VERSION
    cd $CURDIR
    cd $RPM_BUILD_DIR/SPECS
    rpmbuild -ba --target=i386 zato.spec
    rpmbuild -ba --target=x86_64 zato.spec
}

prepare
cleanup
build_rpm
