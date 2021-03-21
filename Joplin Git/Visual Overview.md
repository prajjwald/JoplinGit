# Visual Workflow


![workflow.svg](../_resources/6490101f3c514a95b6406adbc5cb5410.svg)


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

![visualoverview.svg](../_resources/aae9163e109a4d6696bc2f05c82e739c.svg)

# Single User, Joplin Terminal **Not Installed**

![singleUserNoJoplinTerminal.svg](../_resources/f34e129856474b7f9ca742cd494960ef.svg)

# With Collaborators

- Refer to the export part of the workflow in diagrams above

**Caution:**  If you do not have Joplin Terminal Installed and are manually importing, **you will not need the import script**.  However, make sure you import from the subfolder (the one that has the name of your notebook, not the one that has \_resources).  This is a bit different from export, where you import to the root of the repository (I found that slightly confusing when doing manual workflow).

![collaboratorsSimple.svg](../_resources/6d178de1b3ad4142833d3aeaf36e97e6.svg)