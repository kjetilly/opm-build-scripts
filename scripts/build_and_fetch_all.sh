#!/bin/bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -eq 0 ]
then
    >&2 echo "Usage:"
    >&2 echo "    bash $0 <INSTALLDIR>"
    exit 1
fi

mkdir -p $1
installdir=$(realpath $1)
mkdir -p $installdir
cd $installdir
export OPM_DEPENDENCIES_DIR=${installdir}

if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$OPM_USE_CLANG" = true ]]; then
        export CC=$(which clang)
        export CXX=$(which clang++)
    else
        export CC=$(which gcc-14)
        export CXX=$(which g++-14)
    fi
elif [[ "$OPM_USE_CLANG" = true ]]; then
    export CC=$(which clang)
    export CXX=$(which clang++)
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
installdirescaped=$(printf '%s\n' $(realpath "$installdir") | sed -e 's/\//\\\//g')
echo "here"
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/SOURCES_DIR/${installdirescaped}/g" ${installdir}/opm/.vscode/settings.json
else
    sed -i "s/SOURCES_DIR/${installdirescaped}/g" ${installdir}/opm/.vscode/settings.json
fi
echo "there"

if [[ "$OSTYPE" == "darwin"* ]]; then
    export CXXFLAGS="-isystem /opt/homebrew/include"
    export CFLAGS="-isystem /opt/homebrew/include"
fi

mkdir -p ${installdir}/zoltan
# We need to fix fmt version
bash ${SCRIPT_DIR}/build_fmt.sh
cd ${installdir}
bash ${SCRIPT_DIR}/compile_metis.sh
cd ${installdir}
bash ${SCRIPT_DIR}/fetch_dune_trilinos.sh
cd ${installdir}/opm
bash ${SCRIPT_DIR}/fetch_opm.sh
cd ${installdir}
bash ${SCRIPT_DIR}/compile_dune_trilinos.sh

cd ${installdir}/opm
bash ${SCRIPT_DIR}/build_opm.sh
