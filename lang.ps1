param([string]$script)

if ($env:TEST_LANG -eq "go")
{
    $env:CODEGEN = "Azure.JsonRpcClient"
    $scriptFile = ".\" + $env:TEST_LANG + "\" + $script + ".ps1"
    "Running $scriptFile..."
    & $scriptFile
}