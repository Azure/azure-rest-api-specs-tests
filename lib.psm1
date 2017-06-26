function Remove-All {
    param([string]$path)

    If (Test-Path $path){
	    Remove-Item $path -Recurse -Force
    }
}

function New-Dir {
    param([string]$path)

    New-Item -Path $path -ItemType Directory | Out-Null
} 

function Clear-Dir {
    param([string]$path)

    Remove-All -path $path
    New-Dir -path $path
}

function Set-Default {
    param([psobject] $object, [string] $member, $value)

    if (-Not ($object | Get-Member -Name $member))
    {
        $object | Add-Member -type NoteProperty -name $member -value $value
    }
}

function Update-SdkInfo {
    param([psobject] $info)

    # isArm
    Set-Default -object $info -member isArm -value $info.name.StartsWith("arm-")

    # isComposite
    $isComposite = $info.sources | ? {$_.StartsWith("composite") }
    Set-Default -object $info -member isComposite -value $isComposite

    # dotNet
    $dotNet = New-Object -TypeName PSObject
    Set-Default -object $info -member dotNet -value $dotNet
    $dotNet = $info.dotNet

    # dotNet.ft
    Set-Default -object $dotNet -member ft -value 0

    # dotNet.name
    $dotNetName = $info.name.Split("/")[0]
    $dotNetName = If ($info.isArm) { $dotNetName.SubString(4) } Else { $dotNetName }
    $dotNetNameArray = $dotNetName.Split("-") | % {$_.SubString(0, 1).ToUpper() + $_.SubString(1)}
    Set-Default -object $dotNet -member name -value ([string]::Join(".", $dotNetNameArray))

    # dotNet.folder
    Set-Default -object $dotNet -member folder -value $dotNet.name

    # dotNet.output
    $prefix = If ($info.isArm) { "Management." } Else { "dataPlane\Microsoft.Azure." }
    Set-Default -object $dotNet -member output -value "$prefix$($dotNet.name)\Generated"

    # dotNet.test
    $test = "$($dotNet.name).Tests"
    Set-Default -object $dotNet -member test -value "$test\$test.csproj"

    # dotNet.namespace
    $prefix = If ($info.isArm) { "Management." } Else { "" }
    Set-Default -object $dotNet -member namespace -value "Microsoft.Azure.$prefix$($dotNet.name)"    
}

function Read-SdkInfoList {
    param([string] $project)

    $array = Get-Content 'sdkinfo.json' | Out-String | ConvertFrom-Json

    Write-Host "project: $project"
    $array = $array | ? { $_.name -like $project }

    Write-Host "array: $array"

    if (-Not $array)
    {
        Write-Error "unknown project $project"
        exit -1
    }

    $array | % { Update-SdkInfo $_ }

    return $array
}

function Read-SdkInfo {

    $array = Get-Content 'sdkinfo.json' | Out-String | ConvertFrom-Json

    $array = $array | ? {$_.name -eq $env:TEST_PROJECT}

    if (-Not $array)
    {
        Write-Error "unknown project $env:TEST_PROJECT"
        exit -1
    }

    $info = $array[0]

    Update-SdkInfo -info $info

    return $info
}

function Get-SourcePath {
    param([psobject]$info, [string]$source)

    $current = pwd
    $specs = Join-Path $current "azure-rest-api-specs"
    $specs = Join-Path $specs $info.name
    return Join-Path $specs $source
}

function Get-DotNetPath {
    param([psobject]$dotNet, [string]$folder)
    
    $current = pwd
    return Join-Path $current "_\src\SDKs\$($dotNet.folder)\$folder"
}

function Get-DotNetTest {
    param([psobject]$dotNet)

    return Get-DotNetPath -dotNet $dotNet -folder $dotNet.test
}

function Get-DotNetTestList {
    param([psobject] $infoList)

    return $infoList | % { Get-DotNetTest $_.dotNet } | Get-Unique
}

function Get-LangInfo {
    param([psobject] $lang)

    if (-Not $lang) {
        [PSCustomObject] @{ 
            jsonRpc = $false
            script = $false
        }
    } else {
        [PSCustomObject] @{
            jsonRpc = $true            
            script = $lang -ne "json-rpc"
        }
    }    
}

Export-ModuleMember -Function Remove-All
Export-ModuleMember -Function New-Dir
Export-ModuleMember -Function Clear-Dir

Export-ModuleMember -Function Set-Default
Export-ModuleMember -Function Read-SdkInfoList
Export-ModuleMember -Function Read-SdkInfo
Export-ModuleMember -Function Get-SourcePath
Export-ModuleMember -Function Get-DotNetPath
Export-ModuleMember -Function Get-DotNetTest
Export-ModuleMember -Function Get-DotNetTestList
Export-ModuleMember -Function Get-LangInfo