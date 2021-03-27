#!/bin/bash

BIN_DIR=$(dirname $0);

type joplin > /dev/null 2>&1 || { echo "joplin terminal not installed, please import notebook manually"; exit 1; }

source ${BIN_DIR}/config.sh

FIND_EXCLUDE_DIRS="";

JOINSTRING="";
for dir in "${NOT_NOTEBOOK_DIRS[@]}";
do
    FIND_EXCLUDE_DIRS="${FIND_EXCLUDE_DIRS} ${JOINSTRING} -name $dir"
    JOINSTRING="-o";
done

import_notebook() {
    NOTEBOOK="${1}"
    NOTEBOOK_IMPORT_PATH=$NOTEBOOK;

    find "${NOTEBOOK}" -type d | while read notebook;
    do
        nb=$(basename "$notebook")
        echo "Renaming notebook '${nb}' to '(review and delete) ${nb}'"
        joplin ren "${nb}" "(review and delete) ${nb}"
    done

    notebook_prefix_path=${paths["$NOTEBOOK"]};

    if [ ! -z "${notebook_prefix_path}" ];
    then
        echo "Re-arranging ${NOTEBOOK} for Joplin import";
        mkdir -p "${notebook_prefix_path}";
        mv "${NOTEBOOK}" "${notebook_prefix_path}";
        NOTEBOOK_IMPORT_PATH=$(echo ${notebook_prefix_path} | cut -d/ -f1);
    fi

    echo "Importing Notebook from directory";
    joplin import --format md "${NOTEBOOK_IMPORT_PATH}";

    if [ ! -z "${notebook_prefix_path}" ];
    then
        echo "Moving ${NOTEBOOK} back to original location";
        mv "${notebook_prefix_path}/${NOTEBOOK}" .;
        rm -rf "${notebook_prefix_path}";
    fi
}

find . -maxdepth 1 -type d ! \( ${FIND_EXCLUDE_DIRS} \)| sed 's| |\\ |g' |xargs -i basename {} | while read NOTEBOOK;
do
    import_notebook "${NOTEBOOK}";
done
