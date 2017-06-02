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

If (-Not $info.dotNetFolder)
{
    $dotNetFolder = If ($info.isArm) { $info.name.SubString(4) } Else { $info.name }
    $dotNetFolderArray = $dotNetFolder.Split("-") | % {$_.SubString(0, 1).ToUpper() + $_.SubString(1)}
    $info | Add-Member -type NoteProperty -name dotNetFolder -value ([string]::Join(".", $dotNetFolderArray))
}

if (-Not $info.output)
{    
    $prefix = If ($info.isArm) { "Management." } Else { "dataPlane\Microsoft.Azure." }
    $info | Add-Member -type NoteProperty -name output -value "$prefix$($info.dotNetFolder)\Generated"
}

if (-Not $info.test)
{
    $test = "$($info.dotNetFolder).Tests"
    $info | Add-Member -type NoteProperty -name test -value "$test\$test.csproj"
}

if (-Not $info.modeler)
{
    $modeler = If ($info.source.StartsWith("composite")) { "CompositeSwagger" } Else { "Swagger" }
    $info | Add-Member -type NoteProperty -name modeler -value $modeler
}

if (-Not $info.namespace)
{
    $prefix = If ($info.isArm) { "Management." } Else { "" }
    $info | Add-Member -type NoteProperty -name namespace -value "Microsoft.Azure.$prefix$($info.dotnetFolder)"
}

$info

$current = pwd

$env:TEST_MODELER = $info.modeler
$env:TEST_INPUT = Join-Path $current "azure-rest-api-specs\$($info.name)"
If ($info.source)
{
    $env:TEST_INPUT = Join-Path $env:TEST_INPUT $info.source
}
$env:TEST_PROJECT_NAMESPACE = $info.namespace

$env:TEST_PROJECT_FOLDER = Join-Path $current "_\src\SDKs\$($info.dotnetFolder)\$($info.output)"
if(-Not (Test-Path $env:TEST_PROJECT_FOLDER))
{
    Write-Error "error: the path dosn't exist $env:TEST_PROJECT_FOLDER"
    exit -1
}

$env:TEST_PROJECT_TEST = Join-Path $current "_\src\SDKs\$($info.dotnetFolder)\$($info.test)"
if(-Not (Test-Path $env:TEST_PROJECT_TEST))
{
    Write-Error "error: the path dosn't exist $env:TEST_PROJECT_TEST"
    exit -1
}
