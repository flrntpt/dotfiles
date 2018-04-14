# README #

## Local files management
Depending of the system, specific files might be needed. The way we handle this is by creating a .local version of the file
that get sourced by the non-local file.
For example, let's say we want system specific config for .zshrc
**While working locally on master branch**
- create .zshrc.local and init the file with standard content (mostly comments to say what it does)
- source .zshrc.local in .zshrc: ```source ~/.zshrc.local```
- add ``` .zshrc.local merge=ours ``` to .gitattributes
- ```config add ~/.zshrc.local ~/.gitattributes ~/.zshrc```
- ```config commit -m "Add .zshrc.local```
- ```config checkout macos```
- ```config merge master``` _Don't merge directly from github or bitbucket, the merge=ours drivers wouldn't work_

You can now modify the local version of the file inside the macos branch. Modifications won't be erased from a merge from master. For other configurations, do the modifications on master branch then locally merge to local branch on your client.
