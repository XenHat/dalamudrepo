#!/usr/bin/env bash

failed () { echo "Failed:" >&2 "$@" && exit 1; }

GIT_USER=$1
GIT_EMAIL=$2
GIT_COMMIT_MESSAGE=$3

[[ -z "${CI_SERVER_HOST}" ]] && failed "The environment variable CI_SERVER_HOST is not set, this is needed to configure git and ssh to be enable to write back to the repository."
[[ -z "${CI_COMMIT_REF_NAME}" ]] && failed "The environment variable CI_COMMIT_REF_NAME is not set, this is needed to configure git and ssh to be enable to write back to the repository."
[[ -z "${DEPLOY_SSH_KEY}" ]] && failed "The environment variable DEPLOY_SSH_KEY is not set, this is needed to configure git to be enable to write back to the repository."
[[ ! -f "${DEPLOY_SSH_KEY}" ]] && failed "The ${DEPLOY_SSH_KEY} is not available on the filesystem, this is needed to configure git to be enable to write back to the repository."
[[ -z "${GIT_USER}" ]] && failed "Please use: ./commit-changes.sh '<USER NAME>' '<EMAIL>' '<COMMIT MESSAGE>'"
[[ -z "${GIT_EMAIL}" ]] && failed "Please use: ./commit-changes.sh '<USER NAME>' '<EMAIL>' '<COMMIT MESSAGE>'"
[[ -z "${GIT_COMMIT_MESSAGE}" ]] && failed "Please use: ./commit-changes.sh '<USER NAME>' '<EMAIL>' '<COMMIT MESSAGE>'"

run_function () {
    GREEN='\033[1;32m'
    RED='\033[1;31m'
    NC='\033[0m' # No Color

    echo -n "Running $1 "
    ERROR=$( $1 2>&1 )
    [ $? -eq 0 ] && echo -e "[ ${GREEN}DONE${NC} ]" ||  (echo -e "[ ${RED}FAILED${NC} ]" && failed "Unexpected error occurred: ${ERROR}")
}

configure_git_client() {
    git config user.name "${GIT_USER}"
    git config user.email "${GIT_EMAIL}"
}

cleanup_ssh_client() {
    rm -rf ~/.ssh
    mkdir ~/.ssh
}

configure_ssh_client() {
    local KNOWN_HOSTS=~/.ssh/known_hosts
    local CONFIG_FILE=~/.ssh/config

    ssh-keyscan $CI_SERVER_HOST > $KNOWN_HOSTS
    chmod 0644 $KNOWN_HOSTS
    echo "Host $CI_SERVER_HOST" > $CONFIG_FILE
    echo "    IdentityFile $DEPLOY_SSH_KEY" >> $CONFIG_FILE
    chmod 0600 "$DEPLOY_SSH_KEY"
}

configure_git_remote () {
    git remote remove update 2>/dev/null || echo "update remote was not present yet"
    git remote add update git@$CI_SERVER_HOST:$CI_PROJECT_PATH.git
}

commit_and_push_changes () {
    git fetch update
    git branch -D $CI_COMMIT_REF_NAME || echo "branch does not exist"
    git switch -c $CI_COMMIT_REF_NAME update/$CI_COMMIT_REF_NAME
    git diff --quiet && git diff --staged --quiet || (git commit -am "${GIT_COMMIT_MESSAGE}" && git push --set-upstream update $CI_COMMIT_REF_NAME)
}

run_function "configure_git_client"
run_function "cleanup_ssh_client"
run_function "configure_ssh_client"
run_function "configure_git_remote"
run_function "commit_and_push_changes"
