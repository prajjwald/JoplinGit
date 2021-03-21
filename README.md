# Joplin Git
### A Joplin based Git workflow

## Brief Overview

This repository aims to solve my problem of being able to maintain my notes in [Joplin](https://joplinapp.org/), while still being able to share certain notebooks (along with subnotebooks) with others via Github (or any other git provider).

It also enables me to collaborate with others if so desired, by providing a separate import into Joplin script.

If Joplin Terminal (the command lin Joplin interface) is also installed, this script can automatically import/export from Joplin.  If not - you will have to manually do the import/export.

Note that unless you are collaborating with other folks, you will probably just be using the export workflow (no need to git pull or import, just export and git push is fine).

## Visual Overview

For **visual overview** with more details, you can read [the overview](Joplin%20Git/Visual%20Overview.md)

### Word of Caution for those with Joplin Terminal Installed (Along with Joplin Desktop)

Joplin Desktop stores it's data in **$HOME/.config/joplin-desktop**.  On the other hand - Joplin Terminal sotres its data in **$HOME/.config/joplin**.  These folders are the corresponding profile directories for the two apps.

This makes sense - running two different apps simultaneously could potentially cause issues.

However, I took the easy way out (I primarily use Joplin Desktop - Joplin Terminal just for sync)

```bash
mv ~/.config/joplin ~/.config/joplin.bak
ln -s ~/.config/joplin-desktop ~/.config/joplin
```

At this point - everything works well with the scripts.

## The scripts you want to use

- bin
  - **update_repository_from_joplin.sh** - you will most likely want to use this script most often.  Run from the base of your repository
  - *update_joplin_deskop_notebooks.sh* - only use this if you are collaborating with others, and want to import merged changes from upstream back into Joplin.  It takes care of the hassle of recursively renaming your notebooks, and creates a nice backup notebook for the copy before you import.

