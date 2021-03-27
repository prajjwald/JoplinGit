#!/bin/bash

# You don't really have to touch this unless you need to add a directory to the root of the repository
# and that directory is not a Joplin notebook
NOT_NOTEBOOK_DIRS=("." ".git" "bin" "_resources");

# Dictionary (associative array) for if you have certain notebooks that you would like to use without worrying about the parent folder
# an example would be: Public/Notebook1 -> I would only like to keep it in my repository as Notebook1
# Joplin export creates the whole path, so the script tries to simplify that
# You would not need this much unless you were collaborating (I think)

declare -A paths;
paths["test"]="Public";

export paths NOT_NOTEBOOK_DIRS;