param([string] $fork = "Azure", [string] $branch = "master")

$fork = if ($fork) { $fork } else { "Azure" }
$branch = if ($branch) { $branch } else { "master" }

Import-Module ".\lib.psm1"

"Cloning azure-sdk-for-net..."
# $sdkFork = "Azure"
$sdkFork = "sergey-shandar"

# $sdkBranch = "psSdkJson6"
$sdkBranch = "gen"

Remove-All -path _
$sdkRep = "https://github.com/$sdkFork/azure-sdk-for-net"
"Azure SDK for .Net repository: $sdkRep"
"Azure SDK for .Net branch: $sdkBranch"
git clone -q --branch=$sdkBranch $sdkRep _
