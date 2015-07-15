#!/bin/bash

if [[ -z "$1" ]]
then
    echo Argument 1 must be Zato version
    exit 1
fi

ZATO_VERSION=$1
cd /opt/tmp/metapackage/deb

sed "s/ZATO_VERSION/$ZATO_VERSION/g" zato-metapackage.cfg.template > zato-metapackage.cfg
sed "s/ZATO_VERSION/$ZATO_VERSION/g" changelog.template > changelog

equivs-build --arch=i386 zato-metapackage.cfg
equivs-build --arch=amd64 zato-metapackage.cfg
