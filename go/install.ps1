.\go\common.ps1

mkdir $env:GOPATH

"Downloading Go..."
$goZip = Join-Path $env:TEST_COMMON "go.zip"
$client = new-object System.Net.WebClient
$client.DownloadFile("https://storage.googleapis.com/golang/go1.8.1.windows-amd64.zip", $goZip)

"Expanding Go..."
Expand-Archive $goZip -DestinationPath $env:TEST_COMMON

"Getting glide..."
go get -v github.com/Masterminds/glide

"Getting lint..."
go get -v -u github.com/golang/lint/golint 
