#!/bin/bash
INSTALL_PREFIX=$1
set -e
BOOST_MAJOR_VERSION=1
BOOST_MINOR_VERSION=83
BOOST_RELEASE_VERSION=0
old_dir=$(pwd)

wget https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0_rc2.tar.gz
tar xf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}_rc2.tar.gz
cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}
export CXX=$(which CC)
./bootstrap.sh --with-libraries=program_options,filesystem,system,regex,thread,chrono,date_time,log,test,python --prefix=$INSTALL_PREFIX
./b2 -d0 --link=static threading=multi --layout=tagged --cxx=$(which CC) install
./b2 --link=static threading=multi --layout=tagged --cxx=$(which CC) install
cd ..
rm -rf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}
rm -rf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}_rc2.tar.bz2
cd $old_dir
