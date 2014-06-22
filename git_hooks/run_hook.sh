#!/usr/bin/env bash
#

__FILE__=$(readlink -f "$0")
__DIR__=$(dirname "$__FILE__")

# The name of the hook as called by git, i.e pre-commit
called_hook=$(basename "$0")
# Path to the directory that contains our hooks
hook_dir="${__DIR__}/${called_hook}.d"
# Used for error reporting
last_run_hook=""


function report_error 
{
    echo "Hook failed: ${last_run_hook}"
    exit 1
}


# Lists all executable files in a given directory,
# sorted alpabetically
function list_hooks_in_dir
{
    local path="$1"
    find "$path" -type f -perm +111 | sort
}


if [[ ! -d "${hook_dir}" ]]
then
    # no hooks registered
    exit 0
fi

set -e
list_hooks_in_dir "${hook_dir}" | while read hook
do

    last_run_hook="${hook} $@"
    trap report_error ERR

    if [[ ! -z ${GIT_HOOKS_VERBOSE} ]]
    then
        echo "Running hook: ${last_run_hook}"
    fi

    ${hook} "$@"

    trap - ERR

done
set +e

exit 0
