logFile=("./git-log-file-$(date '+%Y-%m-%d-%H-%M-%S').log")
color="\e[1;35m"
script $logFile

# container name
$WORKER_SERVICE_NAME = '{container id}'

#  checkout branch to feature/pre-commit #
echo -e $color"checkout branch to feature/pre-commit"
#(git checkout feature/pre-commit -f)

exit