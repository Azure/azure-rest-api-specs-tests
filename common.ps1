$env:TEST_COMMON = Join-Path (pwd) "x"

$env:TEST_NODE_VER = "v7.10.0"
$env:TEST_NODE = "node-" + $env:TEST_NODE_VER + "-win-x64"
$env:TEST_NODE_FOLDER = Join-Path $env:TEST_COMMON $env:TEST_NODE
$env:Path = $env:TEST_NODE_FOLDER + ";" + $env:Path

$env:TEST_DOTNET_FOLDER = Join-Path $env:TEST_COMMON "dn"
$env:Path = $env:TEST_DOTNET_FOLDER + ";" + $env:Path

$testFolder = Join-Path (Join-Path (pwd) "_\src\SDKs") $env:TEST_PROJECT

"TestFolder = $testFolder"

$env:TEST_PROJECT = $env:TEST_PROJECT.Replace('_', '\')

$env:TEST_PROJECT_FOLDER = (Get-ChildItem -Path $testFolder -Filter "generate.cmd" -Recurse).Directory.FullName
"env:TEST_PROJECT_FOLDER = $env:TEST_PROJECT_FOLDER"
$env:TEST_PROJECT_TEST = (Get-ChildItem -Path $testFolder -Filter "*.Tests.csproj" -Recurse).FullName
"env:TEST_PROJECT_TEST = $env:TEST_PROJECT_TEST"