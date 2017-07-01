param([string] $project = $env:TEST_PROJECT, [string]$lang = $env:TEST_LANG)

Import-Module ".\lib.psm1"
Import-Module ".\_\tools\autogenForSwaggers\lib.psm1"

$current = (Get-Location)

"Building..."

.\common.ps1
if (-Not $?)
{
    exit $LASTEXITCODE
}

UpdateSdkInfo -specs $specs -sdkDir "_"

.\lang.ps1 -script "build" -lang $lang

$langInfo = Get-LangInfo -lang $lang

$specs = Join-Path $current "azure-rest-api-specs"
GenerateAndBuild -project $project -specs $specs -sdkDir "_" -jsonRpc $langInfo.jsonRpc
