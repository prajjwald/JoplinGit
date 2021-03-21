#!/bin/bash

# Make sure you have joplin terminal installed in order to use terminal auto-export
# You can see examples in the comments below
NOTEBOOK_LIST=("Joplin Git");

# To Skip auto-export (e.g. if you don't have joplin terminal installed, uncomment line below
# NOTEBOOK_LIST=()

# Example to export two Joplin notebooks
# NOTEBOOK_LIST=("Notebook 1" "Notebook 2");

#########################################################################################
################## You should not have to modify below this line ########################
#########################################################################################

export_notebook() {
    
    export NOTEBOOK="$1";
    export EXPORT_DIR=$PWD;

    echo "Will attempt to export notebook ${NOTEBOOK}";

    ( 
# Joplin terminal has a weird bug where it creates mysterious, blank, ' (1)'... folders if you run from the destination folder.  Go one step up.  Using subshell to simplify this
        cd ..;
        joplin export --format md --notebook "$1" "${EXPORT_DIR}" || echo "joplin terminal not installed, please export manually";
    )

}

update_exported_files() {

    echo "Updating with Joplin Exported Files";
    echo "Note that this WILL NOT DELETE deleted/renamed notes/notebooks - you should manually do that";

    find . -name "* (1).md" | while read file;
    do
        tail -n +3 "$file" > "${file// \(1\).md/.md}";
        rm -f "$file";
    done

}

delete_orphaned_resources() {

    echo "Deleting unreferenced attachments";

    for resource in _resources/*;
    do
        grep -r --include="*.md" "$resource" > /dev/null 2>&1 || rm -f "$resource";
    done

}

for NOTEBOOK in "${NOTEBOOK_LIST[@]}";
do
    export_notebook "${NOTEBOOK}";
done

# Move new entries created by export (1), (2), ... - this script assumes you only have one export in flight
# anything with more than one simultaneous entry should be manually checked for file completeness
update_exported_files;
delete_orphaned_resources;

echo "Commiting to git";
git add .;
git commit -am "Update from Joplin Export";
