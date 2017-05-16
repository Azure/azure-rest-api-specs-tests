"Cloning azure-rest-api-specs..."
git clone -q https://github.com/Azure/azure-rest-api-specs azure-rest-api-specs

"Cloning azure-sdk-for-net..."
git clone -q --branch=sergey-new-autorest-fixes-tests2 https://github.com/sergey-shandar/azure-sdk-for-net _

"Installing..."

.\common.ps1

mkdir $env:TEST_COMMON

"Downloading .Net Core ..."
$dotnetZip = "dotnet.zip"
$dotnetUrl = "https://download.microsoft.com/download/E/7/8/E782433E-7737-4E6C-BFBF-290A0A81C3D7/dotnet-dev-win-x64.1.0.4.zip"
$client = new-object System.Net.WebClient
$client.DownloadFile($dotnetUrl, $dotnetZip)

"Expanding .Net Core ..."
Expand-Archive $dotnetZip -DestinationPath $env:TEST_DOTNET_FOLDER

"Downloading Node..."
$nodeZip = Join-Path ($env:TEST_COMMON) "node.zip"
$nodeUrl = "https://nodejs.org/dist/" + $env:TEST_NODE_VER + "/" + $env:TEST_NODE + ".zip"
$client = new-object System.Net.WebClient
$client.DownloadFile($nodeUrl, $nodeZip)

"Expanding Node..."
Expand-Archive $nodeZip -DestinationPath $env:TEST_COMMON

"Installing AutoRest..."
npm install -g --silent autorest

"Updating AutoRest..."
autorest --reset --feed=jhendrixMSFT

"Language = $env:TEST_LANG"
"Project = $env:TEST_PROJECT"

.\lang.ps1 -script "install"
