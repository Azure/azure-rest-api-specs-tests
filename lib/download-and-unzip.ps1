param([string]$url, [string]$zip, [string]$dest)

$zip = Join-Path $env:TEST_COMMON $zip

"Downloading $zip"
$client = new-object System.Net.WebClient
$client.DownloadFile($url, $zip)

"Expanding $zip to $output"
Expand-Archive $zip -DestinationPath $dest
