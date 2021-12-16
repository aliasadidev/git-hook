logFile=("./git-log-file-$(date '+%Y-%m-%d-%H-%M-%S').log")
color="\e[1;35m"
script logFile

# container name
$WORKER_SERVICE_NAME = '{container id}'

#  checkout branch to dev #
echo -e $color"checkout branch to dev"
(git checkout dev -f)

exit