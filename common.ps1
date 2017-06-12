$env:TEST_COMMON = Join-Path (pwd) "x"

$env:TEST_PROJECT = $env:TEST_PROJECT.Replace('_', '/')

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

if (-Not $info.modeler)
{
    $modeler = If ($info.source.StartsWith("composite")) { "CompositeSwagger" } Else { "Swagger" }
    $info | Add-Member -type NoteProperty -name modeler -value $modeler
}

If (-Not $info.dotNet)
{
    $dotNet = New-Object -TypeName PSObject
    $info | Add-Member -type NoteProperty -name dotNet -value $dotNet
}

$dotNet = $info.dotNet

if (-Not $dotNet.ft)
{
    $dotNet | Add-Member -type NoteProperty -name ft -value 0
}

If (-Not $dotNet.name)
{
    $dotNetName = $info.name.Split("/")[0]
    $dotNetName = If ($info.isArm) { $dotNetName.SubString(4) } Else { $dotNetName }
    $dotNetNameArray = $dotNetName.Split("-") | % {$_.SubString(0, 1).ToUpper() + $_.SubString(1)}
    $dotNet | Add-Member -type NoteProperty -name name -value ([string]::Join(".", $dotNetNameArray))
}

If (-Not $dotNet.folder)
{
    $dotNet | Add-Member -type NoteProperty -name folder -value $dotNet.name
}

if (-Not $dotNet.output)
{    
    $prefix = If ($info.isArm) { "Management." } Else { "dataPlane\Microsoft.Azure." }
    $dotNet | Add-Member -type NoteProperty -name output -value "$prefix$($dotNet.name)\Generated"
}

if (-Not $dotNet.test)
{
    $test = "$($dotNet.name).Tests"
    $dotNet | Add-Member -type NoteProperty -name test -value "$test\$test.csproj"
}

if (-Not $dotNet.namespace)
{
    $prefix = If ($info.isArm) { "Management." } Else { "" }
    $dotNet | Add-Member -type NoteProperty -name namespace -value "Microsoft.Azure.$prefix$($dotNet.name)"
}

$info
$dotNet
$autorest

$current = pwd

$env:TEST_DOTNET_FT = $dotNet.ft
$env:TEST_DOTNET_COMMIT = $dotnet.commit
$env:TEST_DOTNET_AUTOREST = $dotnet.autorest

$env:TEST_MODELER = $info.modeler
$env:TEST_INPUT = Join-Path $current "azure-rest-api-specs\$($info.name)"
If ($info.source)
{
    $env:TEST_INPUT = Join-Path $env:TEST_INPUT $info.source
}
$env:TEST_PROJECT_NAMESPACE = $dotNet.namespace

$env:TEST_PROJECT_FOLDER = Join-Path $current "_\src\SDKs\$($dotNet.folder)\$($dotNet.output)"
if(-Not (Test-Path $env:TEST_PROJECT_FOLDER))
{
    Write-Error "error: the path dosn't exist $env:TEST_PROJECT_FOLDER"
    exit -1
}

$env:TEST_PROJECT_TEST = Join-Path $current "_\src\SDKs\$($dotNet.folder)\$($dotNet.test)"
if(-Not (Test-Path $env:TEST_PROJECT_TEST))
{
    Write-Error "error: the path dosn't exist $env:TEST_PROJECT_TEST"
    exit -1
}
