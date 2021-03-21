#!/bin/bash

type joplin > /dev/null 2>&1 || { echo "joplin terminal not installed, please import notebook manually"; exit 1; }

# You don't really have to touch this unless you need to add a directory to the root of the repository
# and that directory is not a Joplin notebook
NOT_NOTEBOOK_DIRS=("." ".git" "bin" "_resources");

#########################################################################################
################## You should not have to modify below this line ########################
#########################################################################################

FIND_EXCLUDE_DIRS="";

JOINSTRING="";
for dir in "${NOT_NOTEBOOK_DIRS[@]}";
do
    FIND_EXCLUDE_DIRS="${FIND_EXCLUDE_DIRS} ${JOINSTRING} -name $dir"
    JOINSTRING="-o";
done

import_notebook() {
    NOTEBOOK="${1}"
    find "${NOTEBOOK}" -type d | while read notebook;
    do
        nb=$(basename "$notebook")
        echo "Renaming notebook '${nb}' to '(review and delete) ${nb}'"
        joplin ren "${nb}" "(review and delete) ${nb}"
    done
    echo "Importing Notebook from directory";
    joplin import --format md "${NOTEBOOK}";
}

for NOTEBOOK in "${NOTEBOOK_LIST[@]}";
find . -maxdepth 1 -type d ! \( ${FIND_EXCLUDE_DIRS} \)| sed 's| |\\ |g' |xargs -i basename {} | while read NOTEBOOK;
do
    import_notebook "${NOTEBOOK}";
done
