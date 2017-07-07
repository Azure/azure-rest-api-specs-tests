param([string] $project = $env:TEST_PROJECT, [string]$lang = $env:TEST_LANG)

Import-Module ".\lib.psm1"
Import-Module ".\_\tools\autogenForSwaggers\lib.psm1"

"Building..."

.\common.ps1
if (-Not $?)
{
    exit $LASTEXITCODE
}

.\lang.ps1 -script "build" -lang $lang

$langInfo = Get-LangInfo -lang $lang

GenerateAndBuild -project $project -specs "https://github.com/Azure/azure-rest-api-specs" -sdkDir "_" -jsonRpc $langInfo.jsonRpc
