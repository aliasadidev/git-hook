#! /bin/bash

#logsave -a log.txt  ./bash-ci.sh

#  checkout branch to feature/pre-commit #
echo -e $color"checkout branch to feature/pre-commit"
git checkout feature/pre-commit -f

# removes staged and working directory changes in the server
git reset --hard

#  pull feature/pre-commit branch #
echo "pull feature/pre-commit branch"
git pull

currentLastCommitHash="$(git rev-parse HEAD)"
echo "latest hash code:$currentLastCommitHash"

# read latest commit hash code from last-commit.txt file
lastCommitHash="$(cat ./last-commit.txt)"

# compare the current commit hash with previous the commit hash
isUpdate =  [[  $currentLastCommitHash == $lastCommitHash ]] && echo true || echo false

# pre-commit branch is updated?
echo "is updated: $isUpdate"


if [ isUpdate ]
then

docker-compose config
docker-compose build --no-cache
docker-compose up -d #--force-recreate


# update last-commit.txt file
echo $currentLastCommitHash > ./last-commit.txt
echo "publish finished"

fi