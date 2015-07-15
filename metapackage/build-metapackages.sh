#!/bin/bash

if [[ -z "$1" ]]
then
echo Argument 1 must be release version
    exit 1
fi

RELEASE_VERSION=$1

CURDIR="${BASH_SOURCE[0]}";RL="readlink";([[ `uname -s`=='Darwin' ]] || RL="$RL -f")
while([ -h "${CURDIR}" ]) do CURDIR=`$RL "${CURDIR}"`; done
N="/dev/null";pushd .>$N;cd `dirname ${CURDIR}`>$N;CURDIR=`pwd`;popd>$N

echo "Building packages zato-metapackage for all distros"

#systems="redhat-7-64 ubuntu-14.04-64"
systems="ubuntu-14.04-64"


function cleanup {
echo "Cleaning up synced directories..."
for system in $systems
 do
  cd $CURDIR/vm/$system
  vagrant destroy --force
  rm -rf ./.vagrant
  rm -rf ./vagrant*
  rm -rf ./d*
  rm -rf ./synced/*
  rm -rf ./synced/.git*
  rm -f ./Vagrantfile
  rm -f ./Vagrantfile.bak
  echo "$system - done"
 done
}

function checkout_zatomp {

  for system in $systems
   do
    cd $CURDIR/vm/$system
    cp ./Vagrantfile.template ./Vagrantfile
    sed -i.bak "s#ARGS#$RELEASE_VERSION#g" ./Vagrantfile
    git clone https://github.com/andy-wr/zato-build.git ./synced
   done
}

function build_packages {

  for system in $systems
   do
    cd $CURDIR/vm/$system
    vagrant up
    echo "Copying Zato-metapckages packages to output directory"
    if ls $CURDIR/vm/$system/synced/metapackage/deb/*.deb >/dev/null 2>&1; then
	/bin/cp $CURDIR/vm/$system/synced/metapackage/deb/*.deb $CURDIR/output/
    fi
    if ls $CURDIR/vm/$system/synced/metapackage/rpm/*.rpm >/dev/null 2>&1; then
	/bin/cp $CURDIR/vm/$system/synced/metapackage/rpm/*.rpm $CURDIR/output/
    fi
    vagrant halt
   done
}


cleanup
checkout_zatomp
build_packages
