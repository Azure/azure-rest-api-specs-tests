param([string]$TEST_PROJECT, [string]$TEST_CSM_ORGID_AUTHENTICATION)

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
    $env:AZURE_TEST_MODE = "Record"
}
"Mode: $env:AZURE_TEST_MODE"
dotnet test -l trx $env:TEST_PROJECT_TEST
if (-Not $?)
{
    Write-Error "test errors"
    exit $LASTEXITCODE
}
