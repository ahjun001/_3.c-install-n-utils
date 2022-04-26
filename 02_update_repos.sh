#!/usr/bin/env bash
# shellcheck disable=

# 02_update_repos.sh
# update repositories, possibly on data partition

# -e to exit on error
# -u to exit on unset variables
# -x to echo commands for debut purposes
set -eux

# set environment: ID, SOURCE_DIR
# shellcheck source=/dev/null
if [ -z ${ID+x} ]; then . /etc/os-release; fi

# set scripts & resources directory
if [ -z ${SOURCE_DIR+x} ]; then
    # SOURCE_DIR='/run/media/perubu/data/Local resources TBU/'
    # SOURCE_DIR='/media/perubu/data/Local resources TBU/'
    SOURCE_DIR='/media/perubu/data_ntfs/3.c-install-n-utils/'
    # SOURCE_DIR="$HOME/Documents/Github/3.c-install-n-utils/"
fi

# make directories that will contain repositories files (not links to files)
case $ID in
fedora | ubuntu)
    REPOS_DIR='/run/media/perubu/data/'
    LINK_DIR="$HOME/Documents/Github/"
    [ ! -d "$LINK_DIR" ] && mkdir -v "$LINK_DIR"

    ;;
linuxmint)
    # REPOS_DIR="$HOME/Documents/Github/"
    REPOS_DIR="/media/perubu/data_ntfs/"
    ;;
*)
    echo "Distribution $ID not recognized, exiting ..."
    exit 1
    ;;
esac

[ ! -d "$REPOS_DIR" ] && mkdir -v "$REPOS_DIR"

old_pwd="$(pwd)"
cd "$REPOS_DIR" || exit 1

repos=(
    '3.c-install-n-utils'
    '3.a.2-vsCode'
    '3.a.1-linux'
)
for repo in "${repos[@]}"; do
    if [ ! -d "$repo" ] || [ ! -e "$repo" ]; then
        rm -rfv "$repo"
        ! git clone 'https://github.com/ahjun001/'"$repo" && exit 1
    else
        cd "$repo" || exit 1
        ! git fetch 'https://github.com/ahjun001/'"$repo" && exit 1
        ! git pull 'https://github.com/ahjun001/'"$repo" && exit 1
        cd ..
    fi
done
cd "$old_pwd" || exit 1

# for ThinkBook, make links from Fedora or Kubuntu partition to data
if [ "$ID" == 'ubuntu' ] || [ "$ID" == 'fedora' ]; then
    for repo in ${repos[0]}; do
        my_orig="$REPOS_DIR"repo
        my_link="$LINK_DIR"repo
        if ! ln -fs "$my_orig" "$my_link" || [ ! -e "${my_link}" ]; then
            exit 1
        fi
    done
fi

echo " $0 : Exiting ..."
