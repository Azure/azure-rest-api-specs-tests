"Cloning azure-rest-api-specs..."
Remove-Item azure-rest-api-specs -Recurse -Force
git clone -q https://github.com/Azure/azure-rest-api-specs azure-rest-api-specs

"Cloning azure-sdk-for-net..."
Remove-Item _ -Recurse -Force
git clone -q --branch=sergey-new-autorest-fixes-tests2 https://github.com/sergey-shandar/azure-sdk-for-net _

"Installing..."

.\common.ps1

mkdir $env:TEST_COMMON

"Installing .Net Core..."
$dotnetUrl = "https://download.microsoft.com/download/E/7/8/E782433E-7737-4E6C-BFBF-290A0A81C3D7/dotnet-dev-win-x64.1.0.4.zip"
.\lib\download-and-unzip.ps1 -url $dotnetUrl -zip "dotnet.zip" -dest $env:TEST_DOTNET_FOLDER

"Installing Node..."
$nodeUrl = "https://nodejs.org/dist/" + $env:TEST_NODE_VER + "/" + $env:TEST_NODE + ".zip"
.\lib\download-and-unzip.ps1 -url $nodeUrl -zip "node.zip" -dest $env:TEST_COMMON

"Installing AutoRest..."
npm install -g --silent autorest

"Updating AutoRest..."
autorest --reset --feed=jhendrixMSFT

"Language = $env:TEST_LANG"
"Project = $env:TEST_PROJECT"

.\lang.ps1 -script "install"
