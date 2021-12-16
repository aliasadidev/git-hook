# simple ci with powershell
# log everything in git-log-file-{datetime}.log
$logFile = ".\git-log-file-$([System.Datetime]::Now.ToString("yyyy-MM-dd-HH-mm-ss")).log"

Start-Transcript -Path $logFile

# app pool name
$WORKER_SERVICE_NAME = '{App_Pool_Name}'

# app directory path
$WORKER_SERIVCE_PATH = 'D:\wwwroot\{App_Pool_Name}'

# project root directory path
$ProjectPath = '.\ShopApi\'

# project publish directory path
$ProjectPublishPath = Join-Path -Path '.\' -ChildPath "publish" 

# go to the project directory
cd $ProjectPath

#  checkout branch to dev #
write-host "checkout branch to dev" -ForegroundColor Cyan
(git checkout dev -f)

# removes staged and working directory changes in the server
(git reset --hard)

#  pull dev branch #
write-host "pull dev branch" -ForegroundColor Cyan
(git pull)

# get latest commit hash code
$currentLastCommitHash = (git log dev -1 --pretty=format:"%H")
write-host "latest hash code:$currentLastCommitHash" -ForegroundColor Cyan

# move to ci root directory
cd ..

# read latest commit hash code from last-commit.txt file
$lastCommitHash = Get-Content .\last-commit.txt

# compare the current commit hash with previous the commit hash
$isUpdate = $currentLastCommitHash -eq $lastCommitHash

# dev branch is updated?
write-host "is updated: $isUpdate" -ForegroundColor Cyan;


# publish new version
if($isUpdate -eq $false) {

	# remove the publish directory in the project
	if(Test-Path $ProjectPublishPath){	
		Remove-Item -path $ProjectPublishPath -r -ErrorAction SilentlyContinue
	} 

	# go to the project directory
        cd $ProjectPath

	# run dotnet restore
        dotnet restore  --disable-parallel 
        write-host "restore finished"  -ForegroundColor green
    

	# publish api project to publish directory
	dotnet publish -c Release -o ./publish 
        write-host "publish finished"  -ForegroundColor green


	# check app pool is running
	# if service is running, then stop it
	if((Get-WebAppPoolState -Name $WORKER_SERVICE_NAME).Value -ne 'Stopped'){
		write-host "sevice is running"  -ForegroundColor green
		# stop the app pool
		Stop-WebAppPool -Name $WORKER_SERVICE_NAME
		write-host "sevice is stopped"  -ForegroundColor green
		
		# make a delay 
    	        Start-Sleep -s 7
	}

	
	#start syncing files
        write-host "start syncing files" -ForegroundColor green
       (robocopy $ProjectPublishPath $WORKER_SERIVCE_PATH /s /mir /purge);
       if ($lastexitcode -eq 0) {
         write-host 'Robocopy succeeded'
       }
       else {
         write-host $lastexitcode
       }

	# check app pool is running
	# if service is stoped, then run it
	if((Get-WebAppPoolState -Name $WORKER_SERVICE_NAME).Value -ne 'Started'){
		Start-WebAppPool -Name $WORKER_SERVICE_NAME
		write-host "service is started"  -ForegroundColor green
	}

	# back to root directory
	cd ..
	
	# update last-commit.txt file
	Set-Content .\last-commit.txt $currentLastCommitHash

        write-host "publish finished"  -ForegroundColor green

}

Stop-Transcript
