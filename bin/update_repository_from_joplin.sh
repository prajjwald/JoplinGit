#!/bin/bash

# You don't really have to touch this unless you need to add a directory to the root of the repository
# and that directory is not a Joplin notebook
NOT_NOTEBOOK_DIRS=("." ".git" "bin");

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

export_all_notebooks() {
    type joplin > /dev/null 2>&1 || { echo "skipping auto-export of $1, joplin terminal not installed.  Please export manually"; return; }
    find . -maxdepth 1 -type d ! \( ${FIND_EXCLUDE_DIRS} \)| sed 's| |\\ |g' |xargs -i basename {} | while read notebook;
    do
        export_notebook "$notebook";
    done
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

export_all_notebooks;

# Move new entries created by export (1), (2), ... - this script assumes you only have one export in flight
# anything with more than one simultaneous entry should be manually checked for file completeness
update_exported_files;
delete_orphaned_resources;

echo "Commiting to git";
git add .;
git commit -am "Update from Joplin Export";
