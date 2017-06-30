param ([string] $lang)

Import-Module ".\lib.psm1"

"Installing..."
.\common.ps1

Clear-Dir -path $env:TEST_COMMON

"Installing .Net Core SDK..."
$dotnetSdkUrl = "https://download.microsoft.com/download/E/7/8/E782433E-7737-4E6C-BFBF-290A0A81C3D7/dotnet-dev-win-x64.1.0.4.zip"
.\lib\download-and-unzip.ps1 -url $dotnetSdkUrl -zip "dotnetsdk.zip" -dest $env:TEST_DOTNET_FOLDER

"Installing Node..."
$nodeUrl = "https://nodejs.org/dist/" + $env:TEST_NODE_VER + "/" + $env:TEST_NODE + ".zip"
.\lib\download-and-unzip.ps1 -url $nodeUrl -zip "node.zip" -dest $env:TEST_COMMON

"Installing AutoRest..."
npm install -g --silent autorest

"Updating AutoRest..."
# (autorest --reset --feed=sergey-shandar --version=".....") 2> $null
(autorest --reset --feed=sergey-shandar) 2> $null
$LASTEXITCODE = 0

# "Fixing AutoRest..."
# $dnUrl = "https://download.microsoft.com/download/2/4/A/24A06858-E8AC-469B-8AE6-D0CEC9BA982A/dotnet-win-x64.1.0.5.zip"
# $dnOutput = "~\.autorest\frameworks"
# .\lib\remove.ps1 -path $dnOutput
# .\lib\download-and-unzip.ps1 -url $dnUrl -zip "dotnet.zip" -dest $dnOutput

"Language = $lang"

.\lang.ps1 -script "install" -lang $lang

.\init.ps1