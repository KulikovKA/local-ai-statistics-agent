[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$endpoint = 'http://127.0.0.1:11434'

$listener = Get-NetTCPConnection -LocalPort 11434 -State Listen -ErrorAction Stop |
    Where-Object { $_.LocalAddress -eq '127.0.0.1' } |
    Select-Object -First 1
if ($null -eq $listener) {
    throw 'Ollama is not listening at loopback address 127.0.0.1:11434.'
}

$version = Invoke-RestMethod -Uri "$endpoint/api/version" -TimeoutSec 5
$tags = Invoke-RestMethod -Uri "$endpoint/api/tags" -TimeoutSec 5
$openAiJson = & curl.exe -sS --fail "$endpoint/v1/models"
if ($LASTEXITCODE -ne 0) {
    throw 'The OpenAI-compatible endpoint /v1/models is unavailable.'
}
$openAiModels = $openAiJson | ConvertFrom-Json
$localCount = if ($null -eq $tags.models) { 0 } else { @($tags.models).Count }
$openAiCount = if ($null -eq $openAiModels.data) { 0 } else { @($openAiModels.data).Count }

[pscustomobject]@{
    Endpoint = $endpoint
    Version = $version.version
    Listener = "$($listener.LocalAddress):$($listener.LocalPort)"
    LocalModels = $localCount
    OpenAIModels = $openAiCount
    Status = 'OK'
} | Format-List
