param([string] $project = "*", [string]$lang)

Import-Module ".\lib.psm1"
Import-Module ".\_\tools\autogenForSwaggers\lib.psm1"

$current = (Get-Location)

"Building..."

.\common.ps1
if (-Not $?)
{
    exit $LASTEXITCODE
}

.\lang.ps1 -script "build" -lang $lang

$specs = Join-Path $current "azure-rest-api-specs"
GenerateAndBuild -project $project -specs $specs -sdkDir "_"
