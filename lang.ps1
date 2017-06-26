param([string]$script, [string] $lang)

Import-Module ".\lib.psm1"

$langInfo = Get-LangInfo -lang $lang

if ($langInfo.script) {
    $scriptFile = ".\" + $lang + "\" + $script + ".ps1"
    "Running $scriptFile..."
    & $scriptFile
}
