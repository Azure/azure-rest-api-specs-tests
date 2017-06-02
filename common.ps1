$env:TEST_COMMON = Join-Path (pwd) "x"

$env:TEST_NODE_VER = "v7.10.0"
$env:TEST_NODE = "node-" + $env:TEST_NODE_VER + "-win-x64"
$env:TEST_NODE_FOLDER = Join-Path $env:TEST_COMMON $env:TEST_NODE
$env:Path = $env:TEST_NODE_FOLDER + ";" + $env:Path

$env:TEST_DOTNET_FOLDER = Join-Path $env:TEST_COMMON "dn"
$env:Path = $env:TEST_DOTNET_FOLDER + ";" + $env:Path

# Project

# A VSTS Build name can't contain '/' so the TEST_PROJECT parameter uses '_' 
# instead.
$env:TEST_PROJECT = $env:TEST_PROJECT.Replace('_', '/')

$sdkInfo = Get-Content 'sdkinfo.json' | Out-String | ConvertFrom-Json

$info = ($sdkInfo | ? {$_.name -eq $env:TEST_PROJECT})[0]

if (-Not $info)
{
    Write-Error "unknown project $env:TEST_PROJECT"
    exit -1
}

$info | Add-Member -type NoteProperty -name isArm -value $info.name.StartsWith("arm-")

$sdk = If ($info.isArm) { $info.name.SubString(4) } Else { $info.name }
$sdk = $sdk.Replace("-", ".")

if (-Not $info.output)
{    
    $prefix = If ($info.isArm) { "Management." } Else { "dataPlane\Microsoft.Azure." }
    $info | Add-Member -type NoteProperty -name output -value "$sdk\$prefix$sdk\Generated"
}

if (-Not $info.test)
{
    $test = "$sdk.Tests"
    $info | Add-Member -type NoteProperty -name test -value "$sdk\$test\$test.csproj"
}

if (-Not $info.modeler)
{
    $modeler = If ($info.source.StartsWith("composite")) { "CompositeSwagger" } Else { "Swagger" }
    $info | Add-Member -type NoteProperty -name modeler -value $modeler
}

if (-Not $info.namespace)
{
    $prefix = If (info.isArm) { "Management." } Else { "" }
    $info | Add-Member -type NoteProperty -name namespace -value "Microsoft.Azure.$prefix$sdk"
}

$info

$current = pwd

$env:TEST_MODELER = $info.modeler
$env:TEST_INPUT = Join-Path (Join-Path $current "azure-rest-api-specs\$($info.name)") $info.source
$env:TEST_PROJECT_NAMESPACE = $info.namespace

$env:TEST_PROJECT_FOLDER = Join-Path $current "_\src\SDKs\$($info.output)"
if(-Not (Test-Path $env:TEST_PROJECT_FOLDER))
{
    Write-Error "error: the path dosn't exist $env:TEST_PROJECT_FOLDER"
    exit -1
}

$env:TEST_PROJECT_TEST = Join-Path $current "_\src\SDKs\$($info.test)"
if(-Not (Test-Path $env:TEST_PROJECT_TEST))
{
    Write-Error "error: the path dosn't exist $env:TEST_PROJECT_TEST"
    exit -1
}
