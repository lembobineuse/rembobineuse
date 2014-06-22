#!/usr/bin/env bash

__FILE__=$(readlink -f "$0")
__DIR__=$(dirname "$__FILE__")

GIT_HOOKS=(
    update
    applypatch-msg
    commit-msg
    pre-applypatch
    pre-auto-gc
    pre-commit
    prepare-commit-msg
    pre-rebase
    pre-receive
    pre-push
    post-applypatch
    post-checkout
    post-commit
    post-merge
    post-receive
)


pushd "${__DIR__}/../.git/hooks" >/dev/null

for hook in "${GIT_HOOKS[@]}"
do
    echo "Installing hook ${hook} in ${GITDIR}..."
    ln -sf -T "../../git_hooks/run_hook.sh" ${hook}
done

popd >/dev/null

exit 0
