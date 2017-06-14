$env:GOROOT = Join-Path $env:TEST_COMMON "go"
$env:GOPATH = Join-Path $env:TEST_COMMON "gosrc"
$env:Path = (Join-Path $env:GOROOT "bin") + ";" + $env:Path
$env:GOPATHSRC = Join-Path $env:GOPATH "src"

$env:GOSERVER = "github.com\sergey-shandar\gosdkserver"
$env:GOSERVERFOLDER = Join-Path $env:GOPATHSRC $env:GOSERVER
$env:SDK_REMOTE_SERVER = Join-Path $env:GOSERVERFOLDER "gosdkserver.exe"

