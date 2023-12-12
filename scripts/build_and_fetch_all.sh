#!/bin/bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -eq 0 ]
then
    >&2 echo "Usage:"
    >&2 echo "    bash $0 <INSTALLDIR>"
    exit 1
fi


installdir=$1
mkdir -p $installdir
cd $installdir

if [[ $(type -P "gcc-11") ]]
then
    export CC=$(which gcc-11)
    export CXX=$(which g++-11)
else
    export CC=$(which gcc)
    export CXX=$(which g++)
fi

bash ${SCRIPT_DIR}/clone_and_compile_dune_zoltan.sh
mkdir -p opm
cd opm
bash ${SCRIPT_DIR}/fetch_opm.sh
bash ${SCRIPT_DIR}/build_opm.sh