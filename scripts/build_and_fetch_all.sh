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

# We need to fix fmt version
bash ${SCRIPT_DIR}/build_fmt.sh
bash ${SCRIPT_DIR}/clone_and_compile_dune_zoltan.sh
mkdir -p opm
mkdir ${installdir}/opm/.vscode
cp ${SCRIPT_DIR}/vscodesettings.json ${installdir}/opm/.vscode/

# See https://stackoverflow.com/a/2705678
installdirescaped=$(printf '%s\n' $(realpath "$installdir") | sed -e 's/[\/&]/\\&/g')

sed -i "s/SOURCES_DIR/${installdirescaped}/g" ${installdir}/opm/.vscode/setings.json

cd opm
bash ${SCRIPT_DIR}/fetch_opm.sh
bash ${SCRIPT_DIR}/build_opm.sh
