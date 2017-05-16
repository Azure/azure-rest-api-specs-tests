param([string]$script)

if ($env:TEST_LANG -eq "go")
{
    $scriptFile = ".\" + $env:TEST_LANG + "\" + $script + ".ps1"
    "Running $scriptFile..."
    & $scriptFile
}