.\go\common.ps1

$current = pwd

"Downloading azure-sdk-for-go..."
$azureSdkPath = Join-Path $env:GOPATHSRC "github.com\Azure\azure-sdk-for-go"
# git clone -q --branch=testgen https://github.com/jhendrixmsft/azure-sdk-for-go $azureSdkPath
go get github.com/Azure/azure-sdk-for-go

"Installing azure-sdk-for-go..."
cd $azureSdkPath
$glide = Join-Path $env:GOPATH "bin\glide"
& $glide install
cd $current

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

