param([string]$TEST_PROJECT, [string]$TEST_LANG)

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

$projectReference.SetAttribute("Version", "1.0.200.182")

$xml.Save($xmlFile)

If ($env:TEST_DOTNET_COMMIT)
{
    "Commit: $env:TEST_DOTNET_COMMIT"
    cd azure-rest-api-specs
    git checkout $env:TEST_DOTNET_COMMIT    
    cd ..
}

"Generating SDK..."

"AutoRest: $env:TEST_DOTNET_AUTOREST"
if ($env:TEST_DOTNET_AUTOREST) {
    $index = $env:TEST_DOTNET_AUTOREST.IndexOf('.')
    $package = $env:TEST_DOTNET_AUTOREST.SubString(0, $index)
    $version = $env:TEST_DOTNET_AUTOREST.SubString($index + 1)
    $autoRestExe = ".\_\packages\$env:TEST_DOTNET_AUTOREST\tools\AutoRest.exe"
    & .\_\tools\nuget.exe install $package -Source "https://www.myget.org/F/autorest/api/v2" -Version $version -o "_\packages\"
}
else {
    $autoRestExe = "autorest"
}

.\lib\remove.ps1 -path $env:TEST_PROJECT_FOLDER
mkdir $env:TEST_PROJECT_FOLDER
"$autoRestExe -LEGACY -Modeler $env:TEST_MODELER -CodeGenerator $env:CODEGEN -Namespace $env:TEST_PROJECT_NAMESPACE -Input $env:TEST_INPUT -outputDirectory $env:TEST_PROJECT_FOLDER  -Header MICROSOFT_MIT -ft $env:TEST_DOTNET_FT"
& $autoRestExe -Modeler $env:TEST_MODELER -CodeGenerator $env:CODEGEN -Namespace $env:TEST_PROJECT_NAMESPACE -Input $env:TEST_INPUT -outputDirectory $env:TEST_PROJECT_FOLDER -Header MICROSOFT_MIT -ft $env:TEST_DOTNET_FT

If ($env:TEST_DOTNET_COMMIT)
{
    "Revert Commit"
    cd azure-rest-api-specs
    git checkout master    
    cd ..
}

"Restoring test project NuGet packages..."
dotnet restore $env:TEST_PROJECT_TEST
dotnet restore $env:TEST_PROJECT_TEST -s "https://ci.appveyor.com/nuget/rest-client-runtime-test-net-p-lft6230b45rt"

dotnet build $env:TEST_PROJECT_TEST
if (-Not $?)
{
    Write-Error "build errors"
    exit $LASTEXITCODE
}