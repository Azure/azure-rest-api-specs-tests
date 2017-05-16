"Building..."

.\common.ps1

$current = pwd

.\lang.ps1 -script "build"

"Generating SDK..."
cd $env:TEST_PROJECT_FOLDER
.\generate.cmd
cd $current

"Restoring test project NuGet packages..."
dotnet restore $env:TEST_PROJECT_TEST
