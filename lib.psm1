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

# Export-ModuleMember -Function Set-Default
# Export-ModuleMember -Function Read-SdkInfoList
# Export-ModuleMember -Function Read-SdkInfo
# Export-ModuleMember -Function Get-SourcePath
# Export-ModuleMember -Function Get-DotNetPath
# Export-ModuleMember -Function Get-DotNetTest
# Export-ModuleMember -Function Get-DotNetTestList
Export-ModuleMember -Function Get-LangInfo