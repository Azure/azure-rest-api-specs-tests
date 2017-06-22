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

    "AutoRest: $($dotNet.autorest)"
    if ($dotNet.autorest) {
        $index = $dotNet.autorest.IndexOf('.')
        $package = $dotNet.autorest.SubString(0, $index)
        $version = $dotNet.autorest.SubString($index + 1)
        $autoRestExe = ".\_\packages\$($dotNet.autorest)\tools\AutoRest.exe"
        & .\_\tools\nuget.exe install $package -Source "https://www.myget.org/F/autorest/api/v2" -Version $version -o "_\packages\"
    } else {
        $autoRestExe = "autorest"
    }

    $output = Get-DotNetPath -dotNet $dotNet -folder $dotNet.output
    Clear-Dir -path $output

    # Run AutoRest for all sources.
    $inputs = $info.sources
    $inputs | ForEach-Object {
        $input = Get-SourcePath -info $info -source $_
        "$autoRestExe -Modeler $($info.modeler) -CodeGenerator $env:CODEGEN -Namespace $($dotNet.namespace) -Input $input -outputDirectory $output -Header MICROSOFT_MIT -ft $($dotNet.ft)"
        & $autoRestExe -Modeler $info.modeler -CodeGenerator $env:CODEGEN -Namespace $dotNet.namespace -Input $input -outputDirectory $output -Header MICROSOFT_MIT -ft $dotNet.ft
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

"Adding a project reference..."
$xmlns = "http://schemas.microsoft.com/developer/msbuild/2003"
$namespace = @{x=$xmlns}

$xmlFile = Join-Path $current "_/src/SDKs/AzSdk.reference.props"

[xml]$xml = Get-Content $xmlFile

$projectReferenceList = Select-Xml -Xml $xml -XPath "//x:Project/x:ItemGroup/x:PackageReference[@Include='Microsoft.Rest.ClientRuntime.Test']" -Namespace $namespace
$projectReference = $projectReferenceList.Node

If (-Not $projectReference)
{
    $projectReference = $xml.CreateElement("PackageReference", $xmlns)
    $projectReference.SetAttribute("Include", "Microsoft.Rest.ClientRuntime.Test")

    $itemGroupList = Select-Xml -Xml $xml -XPath "//x:Project/x:ItemGroup[not(@*)][1]" -Namespace $namespace
    $itemGroup = $itemGroupList.Node
    $itemGroup.AppendChild($projectReference)
}

$projectReference.SetAttribute("Version", "1.0.200.188")

# $xml.Save($xmlFile)

# Reading SDK Info

$infoList = Read-SdkInfoList -prefix $env:TEST_PROJECT

$infoList | % { Generate-Sdk -info $_ }

$testProjectList = Get-DotNetTestList $infoList | Get-Unique

$testProjectList | % { Build-Project -project $_ }
