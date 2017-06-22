param([string]$TEST_PROJECT, [string]$TEST_LANG)

Import-Module ".\lib.psm1"

function Generate-Sdk {
    param([psobject] $info)

    $dotNet = $info.dotNet

    "Generating SDK..."

    If ($dotNet.commit) {
        "Commit: $($dotNet.commit)"
        cd azure-rest-api-specs
        git checkout $dotNet.commit    
        cd ..
    }

    "Clear $output"
    $output = Get-DotNetPath -dotNet $dotNet -folder $dotNet.output
    Clear-Dir -path $output    

    "AutoRest: $($dotNet.autorest)"
    if ($dotNet.autorest) {
        # get a specific version of AutoRest
        $index = $dotNet.autorest.IndexOf('.')
        $package = $dotNet.autorest.SubString(0, $index)
        $version = $dotNet.autorest.SubString($index + 1)
        $autoRestExe = ".\_\packages\$($dotNet.autorest)\tools\AutoRest.exe"
        & .\_\tools\nuget.exe install $package -Source "https://www.myget.org/F/autorest/api/v2" -Version $version -o "_\packages\"

        # Run AutoRest for all sources.
        $info.sources | % {
            $input = Get-SourcePath -info $info -source $_
            $r = @(
                "-Modeler",
                $info.modeler,
                "-CodeGenerator",
                $env:CODEGEN,
                "-Namespace",
                $dotNet.namespace,
                "-outputDirectory",
                $output,
                "-Header",
                "MICROSOFT_MIT",
                "-ft",
                $dotNet.ft,
                "-Input",
                $input
            )
            if ($dotNet.client) {
                $r += "-name"
                $r += $dotNet.client
            }
            $r
            & $autoRestExe $r
        }                     
    } else {
        $autoRestExe = "autorest"
        $r = @(
            "--csharp.azure-arm",
            "--namespace=$($dotNet.namespace)",
            "--output-folder=$output",
            "--license-header=MICROSOFT_MIT",
            "--payload-flattening-threshold=$($dotNet.ft)"
        )
        $info.sources | % {
            $input = Get-SourcePath -info $info -source $_
            $r += "--input-file=$input"
        }
        if ($dotNet.client) {
            $r += "--override-info.title=$($dotNet.client)"
        }
        $r
        & $autoRestExe $r
    }

    If ($dotNet.commit)
    {
        "Revert Commit"
        cd azure-rest-api-specs
        git checkout master    
        cd ..
    }    
}

function Build-Project {
    param([string] $project)

    $p = Join-Path (pwd) "common.targets"

    "Restoring test project NuGet packages..."
    dotnet restore $project
    dotnet restore $project -s "https://ci.appveyor.com/nuget/rest-client-runtime-test-net-p-lft6230b45rt" /p:CustomAfterMicrosoftCommonTargets=$p
        
    "& dotnet build $project /p:CustomAfterMicrosoftCommonTargets=$p"
    & dotnet build $project /p:CustomAfterMicrosoftCommonTargets=$p
    if (-Not $?) {
        Write-Error "build errors"
        exit $LASTEXITCODE
    }
}

$current = (pwd)

"Building..."

if ($TEST_LANG)
{
    $env:TEST_LANG = $TEST_LANG
}

if ($TEST_PROJECT) 
{
    $env:TEST_PROJECT = $TEST_PROJECT
}
 
.\common.ps1
if (-Not $?)
{
    exit $LASTEXITCODE
}

.\lang.ps1 -script "build"

# Reading SDK Info

$infoList = Read-SdkInfoList -project $env:TEST_PROJECT

$infoList | % { Generate-Sdk -info $_ }

$testProjectList = Get-DotNetTestList $infoList | Get-Unique

$testProjectList | % { Build-Project -project $_ }
