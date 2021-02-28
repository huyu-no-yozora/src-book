#!/bin/bash
# 
# MIT License
# 
# tool/setup.sh
# 
# Copyright (c) 2020 冬ノ夜空
# 

# = settings ==============================
REPONAME="src-article" # reository name
OUTNAME="example"      # basename of output pdf
SUBDIR="note"          # directory name(jsarticle->[SUBDIR])
# =========================================


# =========================================
# function

function replaceName() {
    
    # definition original string
    local target_str="template"
    local subdir="jsarticle"

    # replace text in each file and rename directory
    replaceString

    # replace a string in Makefile
    replaceNameForMakefile

}

function replaceString() {

    # change directory name
    mv "${subdir}" "${SUBDIR}" 1> /dev/null
    mv "${SUBDIR}/${target_str}.tex" "${SUBDIR}/${OUTNAME}.tex" 1> /dev/null

    # replace a string in each file
    sed -i -e "s@${target_str}@${OUTNAME}@" "${SUBDIR}/${OUTNAME}.tex"
    sed -i -e "1,10s@src-article@${REPONAME}@g" README.md

}

function replaceNameForMakefile() {

    # definition target files of Replacement
    local target_files=("Makefile" "${SUBDIR}/Makefile")

    # Replacement
    for file in "${target_files[@]}"
    do
        sed -i -e "s@${target_str}@${OUTNAME}@g" ${file} \
          || { echo -e "Error: fail to replace file name\n"; exit; }
        sed -i -e "s@${subdir}@${SUBDIR}@g" ${file} \
          || { echo -e "Error: fail to replace subdirectory name in some Makefile\n"; exit; }
    done

}

function deleteExcessMakefile() {

    local target_files=("README.md-e" "Makefile-e" "${SUBDIR}/Makefile-e" "${SUBDIR}/${OUTNAME}.tex-e")

    local file
    for file in "${target_files[@]}"
    do
        if [ -e ${file} ]; then rm -f ${file}; fi
    done

}

# =========================================


# =========================================

# Pre-Processing
PARENTDIR=".."
cd ${PARENTDIR}

# Main-Processing
replaceName

# Post-Processing
deleteExcessMakefile

# =========================================
exit


