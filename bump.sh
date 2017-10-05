#!/bin/sh

GITHUB_TOKEN=$(cat /home/phuslu/.GITHUB_TOKEN)
CURRENT_COMMIT=$(git ls-remote https://phuslu:${GITHUB_TOKEN}@github.com/phuslu/promvps | grep refs/heads/master | awk '{print $1}')
ORIGINAL_COMMIT=$(git log -1 --format="%s %b" | grep -oE '[0-9a-z]{40}' | tail -1)

if [ "${CURRENT_COMMIT}" = "${ORIGINAL_COMMIT}" ]; then
	exit 0
fi

COMMIT_MESSAGE=$(curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/phuslu/promvps/commits/${CURRENT_COMMIT} | python -c 'import sys,json; print(json.load(sys.stdin)["commit"]["message"])')

git commit --amend --allow-empty -m "${COMMIT_MESSAGE}

${CURRENT_COMMIT}"
git push origin master -f

