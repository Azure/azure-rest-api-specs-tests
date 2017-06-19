$oldCurrent = pwd
subst t: /D
subst t: $oldCurrent
cd t:\

.\install.ps1
.\build.ps1
if (-Not $?)
{
    Write-Error "build errors"
    exit $LASTEXITCODE
}

.\test.ps1
if (-Not $?)
{
    Write-Error "test errors"
    exit $LASTEXITCODE
}

cd $oldCurrent
subst t: /D
