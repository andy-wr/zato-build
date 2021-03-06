#!/bin/bash

if [[ -z "$1" ]]
then
    echo Argument 1 must be Zato version
    exit 1
fi

if [[ -z "$2" ]]
then
    echo Argument 1 must be package version
    exit 1
fi

ZATO_VERSION=$1
PACKAGE_VERSION=$2

cd /opt/tmp/metapackage/deb

sed "s/ZATO_VERSION/$ZATO_VERSION/g" zato-metapackage.cfg.template > zato-metapackage.cfg
sed "s/ZATO_VERSION/$ZATO_VERSION/g" changelog.template > changelog
sed -i "s/PACKAGE_VERSION/$PACKAGE_VERSION/g" changelog

equivs-build --arch=i386 zato-metapackage.cfg
equivs-build --arch=amd64 zato-metapackage.cfg
