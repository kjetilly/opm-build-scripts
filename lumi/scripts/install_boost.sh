#!/bin/bash
INSTALL_PREFIX=$1
set -e
BOOST_MAJOR_VERSION=1
BOOST_MINOR_VERSION=87
BOOST_RELEASE_VERSION=0
old_dir=$(pwd)

wget https://archives.boost.io/release/1.87.0/source/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.gz
tar xf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.gz
cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}
./bootstrap.sh --with-libraries=program_options,filesystem,system,regex,thread,chrono,date_time,log,test,python --prefix=$INSTALL_PREFIX
./b2 -d0 --link=static threading=multi --layout=tagged --cxx=$CXX install
./b2 --link=static threading=multi --layout=tagged --cxx=$CXX install
cd ..
rm -rf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}
rm -rf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.bz2
cd $old_dir
