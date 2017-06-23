param([string]$script)

Import-Module ".\lib.psm1"

$langInfo = Get-LangInfo -lang $env:TEST_LANG

if ($langInfo.script) {
    $scriptFile = ".\" + $env:TEST_LANG + "\" + $script + ".ps1"
    "Running $scriptFile..."
    & $scriptFile
}
