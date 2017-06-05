"Cloning azure-rest-api-specs..."
.\lib\remove.ps1 -path azure-rest-api-specs
if (!$env:TEST_FORK)
{
    $env:TEST_FORK = "Azure"
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
    # $env:TEST_DOTNETSDK_FORK = "Azure"
    $env:TEST_DOTNETSDK_FORK = "sergey-shandar"
}
if(-Not $env:TEST_DOTNETSDK_BRANCH)
{
    # $env:TEST_DOTNETSDK_BRANCH = "vs17Dev"
    $env:TEST_DOTNETSDK_BRANCH = "sergey-isolation"
}
.\lib\remove.ps1 -path _
$sdkRep = "https://github.com/$env:TEST_DOTNETSDK_FORK/azure-sdk-for-net"
"Azure SDK for .Net repository: $testRep"
"Azure SDK for .Net branch: $env:TEST_DOTNETSDK_BRANCH"
git clone -q --branch=$env:TEST_DOTNETSDK_BRANCH $sdkRep _

"Installing..."

.\common.ps1
.\lib\remove.ps1 -path $env:TEST_COMMON
mkdir $env:TEST_COMMON

"Installing .Net Core SDK..."
$dotnetSdkUrl = "https://download.microsoft.com/download/E/7/8/E782433E-7737-4E6C-BFBF-290A0A81C3D7/dotnet-dev-win-x64.1.0.4.zip"
.\lib\download-and-unzip.ps1 -url $dotnetSdkUrl -zip "dotnetsdk.zip" -dest $env:TEST_DOTNET_FOLDER

"Installing Node..."
$nodeUrl = "https://nodejs.org/dist/" + $env:TEST_NODE_VER + "/" + $env:TEST_NODE + ".zip"
.\lib\download-and-unzip.ps1 -url $nodeUrl -zip "node.zip" -dest $env:TEST_COMMON

"Installing AutoRest..."
npm install -g --silent autorest

"Updating AutoRest..."
(autorest --reset --feed=sergey-shandar) 2> $null
$LASTEXITCODE = 0

"Fixing AutoRest..."
$dnUrl = "https://download.microsoft.com/download/2/4/A/24A06858-E8AC-469B-8AE6-D0CEC9BA982A/dotnet-win-x64.1.0.5.zip"
$dnOutput = "~\.autorest\frameworks"
.\lib\remove.ps1 -path $dnOutput
.\lib\download-and-unzip.ps1 -url $dnUrl -zip "dotnet.zip" -dest $dnOutput

"Language = $env:TEST_LANG"
"Project = $env:TEST_PROJECT"

.\lang.ps1 -script "install"
