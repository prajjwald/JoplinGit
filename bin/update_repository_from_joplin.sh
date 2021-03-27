#!/bin/bash

COMMIT_MESSAGE="Update from Joplin Export";
BIN_DIR=$(dirname $0);

optstring="m:h";

usage() {
    cat << EOF 2>&1
Usage: $(basename $0) [-h] [-m commit message]
    -h: show this help message
    -m: Custom git commit message
EOF
    exit;
}

while getopts ${optstring} arg;
do
    case ${arg} in
    h)
        usage
        ;;
    m)
        COMMIT_MESSAGE="${OPTARG}"
        ;;
    ?)
        usage;;
    esac
done

source ${BIN_DIR}/config.sh

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

    notebook_prefix_path=${paths["$NOTEBOOK"]};

    if [ ! -z "${notebook_prefix_path}" ];
    then
        echo "Re-arranging ${NOTEBOOK} for Joplin import";
        mkdir -p "${notebook_prefix_path}";
        mv "${NOTEBOOK}" "${notebook_prefix_path}";
    fi

    joplin export --format md --notebook "$1" "${EXPORT_DIR}" || echo "joplin terminal not installed, please export manually";

    if [ ! -z "${notebook_prefix_path}" ];
    then
        echo "Moving ${NOTEBOOK} back to original location";
        mv "${notebook_prefix_path}/${NOTEBOOK}" .;
        rm -rf "${notebook_prefix_path}";
    fi

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

# exporting notebooks often create empty folders with the name ' (1)' in the notebook directory.
# for top level notebooks - this is not a problem if you go one directory up (weird joplin export bug)
# However, the workaround doesn't seem to prevent zombie creation for subnotebooks
# Hence the nuclear option of manually cleaning them up after export
cleanup_joplin_export_zombie_folders() {
    echo "Cleaning up stray directories from export"
    find . -type d -empty -name ' (1)' | while read zombie_dir;
    do
        rm -rf "${zombie_dir}";
    done
}

export_all_notebooks;

# Move new entries created by export (1), (2), ... - this script assumes you only have one export in flight
# anything with more than one simultaneous entry should be manually checked for file completeness
update_exported_files;
delete_orphaned_resources;
cleanup_joplin_export_zombie_folders;

echo "Commiting to git";
git add .;
git commit -am "${COMMIT_MESSAGE}";
