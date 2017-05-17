param([string]$TEST_PROJECT)

"Building..."

if ($TEST_PROJECT) 
{
    $env:TEST_PROJECT = $TEST_PROJECT
}

.\common.ps1

$current = pwd

.\lang.ps1 -script "build"

"Generating SDK..."
cd $env:TEST_PROJECT_FOLDER
.\generate.cmd
cd $current

"Restoring test project NuGet packages..."
dotnet restore $env:TEST_PROJECT_TEST
