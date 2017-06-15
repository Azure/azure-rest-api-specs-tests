param([string] $TEST_PROJECT, [string]$TEST_FORK, [string] $TEST_BRANCH)

if ($TEST_PROJECT)
{
    $env:TEST_PROJECT = $TEST_PROJECT
}

"Cloning azure-rest-api-specs..."
.\lib\remove.ps1 -path azure-rest-api-specs

if ($TEST_FORK)
{
    $env:TEST_FORK = $TEST_FORK
}
if (!$env:TEST_FORK)
{
    $env:TEST_FORK = "Azure"
}

if ($TEST_BRANCH)
{
    $env:TEST_BRANCH = $TEST_BRANCH
}
if (!$env:TEST_BRANCH)
{
    $env:TEST_BRANCH = "master"
}

$testRep = "https://github.com/$env:TEST_FORK/azure-rest-api-specs"
"Azure REST API Specs repository: $testRep"
"Azure REST API Specs branch: $env:TEST_BRANCH"
git clone -q --branch=$env:TEST_BRANCH $testRep azure-rest-api-specs

"Cloning azure-sdk-for-net..."
if(-Not $env:TEST_DOTNETSDK_FORK)
{
    $env:TEST_DOTNETSDK_FORK = "Azure"
    # $env:TEST_DOTNETSDK_FORK = "sergey-shandar"
}
if(-Not $env:TEST_DOTNETSDK_BRANCH)
{
    $env:TEST_DOTNETSDK_BRANCH = "psSdkJson6"
    # $env:TEST_DOTNETSDK_BRANCH = "new-autorest"
}
.\lib\remove.ps1 -path _
$sdkRep = "https://github.com/$env:TEST_DOTNETSDK_FORK/azure-sdk-for-net"
"Azure SDK for .Net repository: $sdkRep"
"Azure SDK for .Net branch: $env:TEST_DOTNETSDK_BRANCH"
git clone -q --branch=$env:TEST_DOTNETSDK_BRANCH $sdkRep _

