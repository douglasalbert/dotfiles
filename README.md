# dotfiles

[![works badge](https://cdn.jsdelivr.net/gh/nikku/works-on-my-machine@v0.2.0/badge.svg)](https://github.com/nikku/works-on-my-machine)

## About

### Installation

```console
$ make
```

### Configuration

Sensitive environment variables and other configuration are sourced out of a
`.bash_profile.local` file

```bash
### git
GIT_AUTHOR_NAME="Unknown Author"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL=""
GIT_COMMITER_EMAIL="$GIT_AUTHOR_EMAIL"
GH_USER="handle"

git config --global user.email "$GIT_AUTHOR_EMAIL"
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global github.user "$GH_USER"
```

## Notes

As the above badge notes, this has only been tested on my own machines.
