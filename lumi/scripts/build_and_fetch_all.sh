#!/bin/bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -eq 0 ]
then
    >&2 echo "Usage:"
    >&2 echo "    bash $0 <INSTALLDIR>"
    exit 1
fi


installdir=$(realpath $1)
mkdir -p $installdir
cd $installdir


export CC=$(which mpicc)
export CXX=$(which mpicxx)

mkdir -p ${installdir}/opm
mkdir -p ${installdir}/opm/.vscode
cp ${SCRIPT_DIR}/vscodesettings.json ${installdir}/opm/.vscode/settings.json

# See https://stackoverflow.com/a/2705678
installdirescaped=$(printf '%s\n' $(realpath "$installdir") | sed -e 's/[\/&]/\\&/g')
sed -i "s/SOURCES_DIR/${installdirescaped}/g" ${installdir}/opm/.vscode/settings.json


# We need to fix fmt version
bash ${SCRIPT_DIR}/build_fmt.sh
cd ${installdir}
bash ${SCRIPT_DIR}/fetch_dune_trilinos.sh
cd ${installdir}/opm
bash ${SCRIPT_DIR}/fetch_opm.sh
cd ${installdir}
bash ${SCRIPT_DIR}/compile_dune_trilinos.sh

cd ${installdir}/opm
bash ${SCRIPT_DIR}/build_opm.sh
