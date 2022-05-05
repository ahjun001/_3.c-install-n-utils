#!/usr/bin/env bash
# shellcheck disable=2016

# 00_model.sh
# repeat description of what the script should do

# -e to exit on error
# -u to exit on unset variables
# -x to echo commands for degub purposes
[[ ${MY_ENV} ]] || MY_ENV=eux
set -"$MY_ENV"

# sed -i '6i\
# # run with arg u  to undo

# # launch after install
[[ ${LAUNCH_APP} ]]  || LAUNCH_APP=true

# info verbose debug trace
[[ $MY_TRACE ]] || MY_TRACE=true
# \[ -n "${LAUNCH_APP+x}"  \] && LAUNCH_APP=true
# ' tmp.txt

files=(
    '01_post_install.sh'
    '02_expressvpn.sh'
    '02_git.sh'
    '02_grub2.sh'
    '02_mount_data.sh'
    '02_shellspec.sh'
    '02_update_repos.sh'
    '03_reset_all_links.sh'
)

lines=(
    '# run with arg u  to undo'
    ''
    '# launch after install
[[ ${LAUNCH_APP} ]]  || LAUNCH_APP=true

# info verbose debug trace
[[ $MY_TRACE ]] || MY_TRACE=true'
    ''
)

# MY_STRING='# run with arg u  to undo\n\n display results or not\n \[ -n "${LAUNCH_APP+x}"  \] && LAUNCH_APP=true'
for line in "${lines[@]}"; do
    MY_STRING+="\n$line"
done
MY_STRING="${MY_STRING:2}"
for file in "${files[@]}"; do
    if [ "$1" == 'u' ]; then
        for line in "${lines[@]}"; do
            sed -i "/$line/d" "$file"
        done
        sed -i "/$MY_STRING/d" "$file"
    else
        sed -i "6i$MY_STRING" "$file"
    fi
    less "$file"
done
