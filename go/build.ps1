.\go\common.ps1

$current = Get-Location

"Downloading azure-sdk-for-go..."
$azureSdkPath = Join-Path $env:GOPATHSRC "github.com\Azure\azure-sdk-for-go"
git clone -q --branch=master https://github.com/sergey-shandar/azure-sdk-for-go $azureSdkPath
# go get github.com/Azure/azure-sdk-for-go

"Installing azure-sdk-for-go..."
Set-Location $azureSdkPath
$glide = Join-Path $env:GOPATH "bin\glide"
# $glide up
& $glide install
go get gopkg.in/godo.v2
Set-Location $current

$gen = Join-Path $azureSdkPath "gododir\gen.go"

"---------------"
"Building SDK..."
"---------------"
go run $gen -- --sdk 10.0.0 --sw $current

"-----------------"
"Building tests..."
"-----------------"
go run $gen -- --sdk 10.0.0 --sw $current -t

"Updating go-autorest..."
Remove-Item (Join-Path $azureSdkPath "vendor\github.com\Azure\go-autorest") -Recurse -Force
go get github.com/Azure/go-autorest

"Building server..."
go get $env:GOSERVER
cd $env:GOSERVERFOLDER
go build
cd $current
