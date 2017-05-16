param([string]$TEST_CSM_ORGID_AUTHENTICATION)

.\common.ps1

.\lang.ps1 -script "test"

"Testing SDK..."

$env:AZURE_TEST_MODE = "Record"
$env:TEST_CSM_ORGID_AUTHENTICATION = $TEST_CSM_ORGID_AUTHENTICATION

dotnet test -l trx $env:TEST_PROJECT_TEST