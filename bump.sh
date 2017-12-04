#!/bin/sh

BITBUCKET_PASSWORD="$(cat /home/phuslu/.BITBUCKET_PASSWORD)"
CURRENT_COMMIT=$(git ls-remote "https://phuslu:${BITBUCKET_PASSWORD}@bitbucket.org/phuslu/promvps" | grep refs/heads/master | awk '{print $1}')
ORIGINAL_COMMIT=$(git log -1 --format="%s %b" | grep -oE '[0-9a-z]{40}' | tail -1)

if [ "${CURRENT_COMMIT}" = "${ORIGINAL_COMMIT}" ]; then
	exit 0
fi

COMMIT_MESSAGE=$(curl -v -u "phuslu:${BITBUCKET_PASSWORD}" "https://api.bitbucket.org/2.0/repositories/phuslu/promvps/commits/master"|python -c 'import sys,json; print(json.load(sys.stdin)["values"][0]["message"])')

git commit --amend --allow-empty -m "${COMMIT_MESSAGE}

${CURRENT_COMMIT}"
git push origin master -f

