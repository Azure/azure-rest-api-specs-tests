param([string]$TEST_PROJECT, [string]$TEST_LANG, [string]$TEST_CSM_ORGID_AUTHENTICATION)

Import-Module ".\lib.psm1"

if ($TEST_LANG)
{
    $env:TEST_LANG = $TEST_LANG
}

if ($TEST_PROJECT) 
{
    $env:TEST_PROJECT = $TEST_PROJECT
}

.\common.ps1

.\lang.ps1 -script "test"

"Testing SDK..."

if ($TEST_CSM_ORGID_AUTHENTICATION) 
{
    $env:TEST_CSM_ORGID_AUTHENTICATION = $TEST_CSM_ORGID_AUTHENTICATION
}
If ($env:TEST_CSM_ORGID_AUTHENTICATION)
{
    # Options: None, Record, Playback
    $env:AZURE_TEST_MODE = "None"
}
"Mode: $env:AZURE_TEST_MODE"
$info = Read-SdkInfo
$info
$test = Get-DotNetTest -dotNet $info.dotNet
$test
# dotnet test --filter "(TestType!=InMemory)" -l trx $env:TEST_PROJECT_TEST 
dotnet test -l trx $test 
if (-Not $?)
{
    Write-Error "test errors"
    exit $LASTEXITCODE
}
