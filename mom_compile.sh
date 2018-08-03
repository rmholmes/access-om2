#!/usr/bin/env sh

# Compile MOM5 code from current state in src/mom and copy executable
# to bin/ with hash.
#
# Adapted from install.sh from Andrew Kiss

set -e

if [[ -z "${ACCESS_OM_DIR}" ]]; then
    echo "Installing ACCESS-OM2 in $(pwd)"
    export ACCESS_OM_DIR=$(pwd)
fi

cd ${ACCESS_OM_DIR}

module purge
module load cmake/3.6.2
module load netcdf/4.4.1.1
module load intel-fc/17.0.1.132
module load openmpi/1.10.2

echo "Compiling MOM5.1..."
cd ${ACCESS_OM_DIR}/src/mom/exp
./MOM_compile.csh --type ACCESS-OM --platform nci

fmspath=${ACCESS_OM_DIR}/src/mom/exec/nci/ACCESS-OM/fms_ACCESS-OM.x
bindir=${ACCESS_OM_DIR}/bin

echo "Getting MOM5 hash..."

cd $(dirname "${fmspath}") && fmshash=`git rev-parse --short=7 HEAD`
test -z "$(git status --porcelain)" || fmshash=${fmshash}-modified # uncommitted changes or untracked files

fmsbn=$(basename "${fmspath}")
fmshashexe="${fmsbn%.*}"_${fmshash}."${fmspath##*.}"
echo "  cp ${fmspath} ${bindir}/${fmshashexe}"
        cp ${fmspath} ${bindir}/${fmshashexe}


exit 0

