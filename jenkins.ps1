$current = pwd
subst t: /D
subst t: $current
cd t:\

.\install.ps1
.\build.ps1
.\test.ps1

cd $current
subst t: /D
