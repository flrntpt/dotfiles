# README #

Influenced by this post on HackerNews:
[https://news.ycombinator.com/item?id=11070797](Link URL)

## Local files management
Depending of the system, specific files might be needed. The way we handle this is by creating a .local version of the file
that get sourced by the non-local file.
For example, let's say we want system specific config for .zshrc
**While working locally on master branch**
- create .zshrc.local and init the file with standard content.
- add ``` .zshrc.local merge=ours ``` to our .gitattributes file
- config add ~/.zshrc, commit
- config checkout macos
- config merge master
_Don't merge directly from github or bitbucket, the merge=ours drivers wouldn't work_
