#! /bin/bash
# change the username of a remote github repo

function change_git_username() {
    git remote -v | \
        grep "${1}.*fetch" | \
        awk '{print $2}' | \
        sed -E "s/(.*github.com[:/])(.*)(\/.*)/\1${2}\3/g" | \
        xargs git remote set-url "$1" 
}

function print_usage() {
    echo "Usage: ./ch-github-uname.sh <remote-name> <new-username>"
}

if ! which git >/dev/null 2>&1; then
    echo "Error: Please install git first"
    exit 1
elif ! git status >/dev/null 2>&1; then
    echo "Error: Directory $(pwd) is not a git repo"
    exit 1
elif [ $# != 2 ]; then
    print_usage
elif ! git remote -v | grep -w "$1" >/dev/null; then
    echo "Error: No remote with name '$1'"
    exit 1
else
    remote_name=$1
    new_username=$2
    change_git_username "$remote_name" "$new_username"
fi