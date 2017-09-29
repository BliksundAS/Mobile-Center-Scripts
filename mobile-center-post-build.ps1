$password = ConvertTo-SecureString -String "_PASSWORD_" -AsPlainText -Force
$username = "_USERNAME_"
$owner = "_REPO-OWNER_"
$repo = "_REPO_"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password
$commit = git rev-parse HEAD
$uri = "https://api.bitbucket.org/2.0/repositories/{0}/{1}/commit/{2}/statuses/build" -f $owner, $repo, $commit
$status = $env:AGENT_JOBSTATUS

$state = "FAILED"
if ($status -eq "Succeeded") {
	$state = "SUCCESSFUL"
}

$body = @{
    state = $state
    key = $env:MOBILECENTER_BUILD_ID
    url = "https://mobile.azure.com/"
    name = "Mobile Center"
}

Invoke-RestMethod -Method Post -Credential $cred -Uri $uri -Body $body -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}