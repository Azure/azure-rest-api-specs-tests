param([string]$TEST_PROJECT, [string]$TEST_LANG)

Import-Module ".\lib.psm1"
Import-Module ".\_\tools\autogenForSwaggers\lib.psm1"

$current = (Get-Location)

"Building..."

if ($TEST_PROJECT)
{
    $env:TEST_PROJECT = $TEST_PROJECT
}

.\common.ps1
if (-Not $?)
{
    exit $LASTEXITCODE
}

.\lang.ps1 -script "build" -lang $TEST_LANG

$specs = Join-Path $current "azure-rest-api-specs"
GenerateAndBuild -project $env:TEST_PROJECT -specs $specs -sdkDir "_"

# Reading SDK Info

# $infoList = Read-SdkInfoList -project $env:TEST_PROJECT

# $infoList | ForEach-Object { Generate-Sdk -info $_ }

# $testProjectList = Get-DotNetTestList $infoList

# $testProjectList | ForEach-Object { Build-Project -project $_ }
