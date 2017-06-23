param([string]$TEST_PROJECT, [string]$TEST_LANG)

Import-Module ".\lib.psm1"

function Generate-Sdk {
    param([psobject] $info)

    $dotNet = $info.dotNet

    $info

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
        $r = @(
            "install",
            $package,
            "-Version",
            $version,
            "-o",
            "_\packages\"
        )
        if ($version.Contains("-"))
        {
            $r += "-Source"
            $r += "https://www.myget.org/F/autorest/api/v2"
        }
        $r
        & .\_\tools\nuget.exe $r
        if (-Not $?) {
            Write-Error "autorest restore errors"
            exit $LASTEXITCODE
        }
    } else {
        $autoRestExe = "autorest"
    }

    $langInfo = Get-LangInfo -lang $env:TEST_LANG

    if ($dotNet.autorest -or $info.isComposite -or $info.isLegacy) {
        # Run AutoRest for all sources.
        $info.sources | % {
            $modeler = If ($info.isComposite) { "CompositeSwagger" } Else { "Swagger" }
            $input = Get-SourcePath -info $info -source $_
            $r = @(
                "-Modeler",
                $modeler,
                "-CodeGenerator",
                $langInfo.legacyCodeGen,
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
            if (-Not $?) {
                Write-Error "generation errors"
                exit $LASTEXITCODE
            }
        }                     
    } else {
        $autoRestExe = "autorest"
        $r = @(
            $langInfo.lang,
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
        if (-Not $?) {
            Write-Error "generation errors"
            exit $LASTEXITCODE
        }        
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
