.\go\common.ps1

mkdir $env:GOPATH

"Installing Go..."
$goUrl = "https://storage.googleapis.com/golang/go1.8.1.windows-amd64.zip"
.\lib\download-and-unzip.ps1 -url $goUrl -zip "go.zip" -dest $env:TEST_COMMON

"Getting glide..."
go get -v github.com/Masterminds/glide

"Getting lint..."
go get -v -u github.com/golang/lint/golint 
