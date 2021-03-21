#!/bin/bash

# Make sure you have joplin terminal installed in order to use terminal auto-import
# Use with caution - close joplin-desktop before using
NOTEBOOK_LIST=("Joplin Git");

#########################################################################################
################## You should not have to modify below this line ########################
#########################################################################################

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
do
    import_notebook "${NOTEBOOK}";
done
