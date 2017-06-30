$project = $env:TEST_PROJECT
$lang = $env:TEST_LANG

$oldCurrent = Get-Location
subst t: /D
subst t: $oldCurrent
Set-Location t:\

.\install.ps1 -lang $lang
.\build.ps1 -project $project -lang $lang
if (-Not $?)
{
    Write-Error "build errors"
    exit $LASTEXITCODE
}

.\test.ps1 -project $project -lang $lang
if (-Not $?)
{
    Write-Error "test errors"
    exit $LASTEXITCODE
}

Set-Location $oldCurrent
subst t: /D
