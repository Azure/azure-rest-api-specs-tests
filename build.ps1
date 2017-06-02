param([string]$TEST_PROJECT)

"Building..."

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

"Generating SDK..."
autorest -Modeler $env:TEST_MODELER -CodeGenerator $env:CODEGEN -Namespace $env:TEST_PROJECT_NAMESPACE -Input $env:TEST_INPUT -Output $env:TEST_PROJECT_FOLDER

"Restoring test project NuGet packages..."
dotnet restore $env:TEST_PROJECT_TEST
