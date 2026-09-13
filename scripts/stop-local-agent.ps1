[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$stateDirectory = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'local-ai-statistics-agent'
$pidFile = Join-Path $stateDirectory 'ollama.pid'

if (-not (Test-Path -LiteralPath $pidFile)) {
    Write-Host 'No project-owned PID was found. Existing Ollama was not changed.'
    exit 0
}

$processId = [int](Get-Content -Raw -LiteralPath $pidFile)
$process = Get-Process -Id $processId -ErrorAction SilentlyContinue
if ($null -eq $process -or $process.ProcessName -ne 'ollama') {
    Remove-Item -LiteralPath $pidFile -Force
    Write-Host 'The project-owned PID was stale; its state file was removed. No process was stopped.'
    exit 0
}

Stop-Process -Id $processId
Remove-Item -LiteralPath $pidFile -Force
Write-Host "Stopped project-owned Ollama PID $processId."
