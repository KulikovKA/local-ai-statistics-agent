[CmdletBinding()]
param(
    [string]$OllamaPath
)

$ErrorActionPreference = 'Stop'
$endpoint = 'http://127.0.0.1:11434'
$stateDirectory = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'local-ai-statistics-agent'
$pidFile = Join-Path $stateDirectory 'ollama.pid'

if (-not $OllamaPath) {
    $command = Get-Command ollama -ErrorAction Stop
    $OllamaPath = $command.Source
}

try {
    $version = Invoke-RestMethod -Uri "$endpoint/api/version" -TimeoutSec 3
    Write-Host "Ollama already responds at $endpoint (version $($version.version)). Existing process was not changed."
    exit 0
}
catch {
    # The endpoint is absent: only a new project-owned process may be started.
}

New-Item -ItemType Directory -Force -Path $stateDirectory | Out-Null
$previousNoCloud = $env:OLLAMA_NO_CLOUD
$previousHost = $env:OLLAMA_HOST

try {
    $env:OLLAMA_NO_CLOUD = '1'
    $env:OLLAMA_HOST = '127.0.0.1:11434'
    $process = Start-Process -FilePath $OllamaPath -ArgumentList 'serve' -PassThru -WindowStyle Hidden
}
finally {
    $env:OLLAMA_NO_CLOUD = $previousNoCloud
    $env:OLLAMA_HOST = $previousHost
}

$process.Id | Set-Content -Encoding ascii -NoNewline -LiteralPath $pidFile
for ($attempt = 1; $attempt -le 15; $attempt++) {
    Start-Sleep -Seconds 1
    try {
        $version = Invoke-RestMethod -Uri "$endpoint/api/version" -TimeoutSec 2
        Write-Host "Started project-owned Ollama PID $($process.Id) at $endpoint (version $($version.version))."
        exit 0
    }
    catch {
        # Wait for the endpoint to start.
    }
}

throw "Ollama PID $($process.Id) did not become available at $endpoint within 15 seconds."
