# Pre-requisites

If you are using Joplin Terminal - then make sure you are able to see the same notebooks as Joplin Desktop (assuming you use both).

Here's my workaround (use at your own risk):

```bash
cd $HOME/.config;
mv joplin joplin.bak;
ln -s joplin-desktop joplin;
```


# Simple Case - single user, Joplin Terminal Installed

- relevant script: **bin/update_repository_from_joplin.sh**

![visualoverview.svg](../_resources/fb62dd45f02b4349a81684b926f18433.svg)

# Single User, Joplin Terminal **Not Installed**

![singleUserNoJoplinTerminal.svg](../_resources/fcb05fbc379a40fcb30b99e4a3d44f69.svg)

# With Collaborators

- Refer to the export part of the workflow in diagrams above

**Caution:**  If you do not have Joplin Terminal Installed and are manually importing, **you will not need the import script**.  However, make sure you import from the subfolder (the one that has the name of your notebook, not the one that has \_resources).  This is a bit different from export, where you import to the root of the repository (I found that slightly confusing when doing manual workflow).

![collaboratorsSimple.svg](../_resources/fdedef0e98c34801bbb8ae81467a2c17.svg)