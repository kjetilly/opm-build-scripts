#!/bin/bash
set -e
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -eq 0 ]
then
    >&2 echo "Usage:"
    >&2 echo "    bash $0 <INSTALLDIR>"
    exit 1
fi

if [ -z ${OPM_DEPENDENCIES_DIR+x} ]; then
    >&2 echo "OPM_DEPENDENCIES_DIR is not set. Please set it to the directory where you want to download the OPM dependencies."
    exit 1
fi

mkdir -p $1
installdir=$(realpath $1)
mkdir -p $installdir
cd $installdir
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -z ${OPM_USE_CLANG+x} ]; then
        export OPM_USE_CLANG=true
    fi
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$OPM_USE_CLANG" = true ]]; then
        export CC=$(which clang)
        export CXX=$(which clang++)
    else
        export CC=$(which gcc-11)
        export CXX=$(which g++-11)
    fi
elif [[ $(type -P "gcc-11") ]]; then
    export CC=$(which gcc-11)
    export CXX=$(which g++-11)
else
    export CC=$(which gcc)
    export CXX=$(which g++)
fi

mkdir -p ${installdir}/opm
mkdir -p ${installdir}/opm/.vscode
cp ${SCRIPT_DIR}/vscodesettings.json ${installdir}/opm/.vscode/settings.json

# See https://stackoverflow.com/a/2705678
opmsourcesdirescaped=$(printf '%s\n' $(realpath "$OPM_DEPENDENCIES_DIR") | sed -e 's/\//\\\//g')
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/SOURCES_DIR/${opmsourcesdirescaped}/g" ${installdir}/opm/.vscode/settings.json
else
    sed -i "s/SOURCES_DIR/${opmsourcesdirescaped}/g" ${installdir}/opm/.vscode/settings.json
fi
if [[ "$OSTYPE" == "darwin"* ]]; then
    export CXXFLAGS="-isystem /opt/homebrew/include"
    export CFLAGS="-isystem /opt/homebrew/include"
fi

cd ${installdir}/opm
bash ${SCRIPT_DIR}/fetch_opm.sh
bash ${SCRIPT_DIR}/build_opm.sh
