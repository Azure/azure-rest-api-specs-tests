param([string]$path)

If (Test-Path $path){
	Remove-Item $path -Recurse -Force
}