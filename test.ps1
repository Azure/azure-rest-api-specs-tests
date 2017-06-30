param([string] $project = "*", [string] $lang, [string] $TEST_CSM_ORGID_AUTHENTICATION)

Import-Module ".\_\tools\autogenForSwaggers\lib.psm1"

.\common.ps1

.\lang.ps1 -script "test" -lang $lang

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

TestSdk -project $project -sdkDir "_"