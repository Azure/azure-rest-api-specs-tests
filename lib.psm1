function Set-Default {
    param([psobject] $object, [string] $member, $value)

    if (-Not ($object | Get-Member -Name $member))
    {
        $object | Add-Member -type NoteProperty -name $member -value $value
    }
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

    # isArm
    Set-Default -object $info -member isArm -value $info.name.StartsWith("arm-")

    # modeler
    $composite = $info.sources | ? {$_.StartsWith("composite") }
    $modeler = If ($composite) { "CompositeSwagger" } Else { "Swagger" }
    Set-Default -object $info -member modeler -value $modeler

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

    return $info
}

export-modulemember -function Read-SdkInfo