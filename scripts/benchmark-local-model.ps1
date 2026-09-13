[CmdletBinding()]
param(
    [int[]]$Contexts = @(4096, 8192, 16384),
    [int]$NumPredict = 128
)

$ErrorActionPreference = 'Stop'
$endpoint = 'http://127.0.0.1:11434/api/generate'
$model = 'qwen3-coder:30b'
$prompt = @'
Write a Python function named mean_or_none(values) that returns None for an empty list and otherwise returns the arithmetic mean. Include type hints and no explanation outside the code.
'@

try {
    Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/version' -TimeoutSec 5 | Out-Null
}
catch {
    throw "Ollama endpoint is unavailable: $($_.Exception.Message)"
}

$results = foreach ($context in $Contexts) {
    # A cold load makes load_duration comparable for every requested context.
    $savedErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & ollama stop $model 2>$null | Out-Null
    $ErrorActionPreference = $savedErrorActionPreference

    $payload = @{
        model = $model
        prompt = $prompt
        stream = $false
        keep_alive = '0'
        options = @{
            num_ctx = $context
            num_predict = $NumPredict
            temperature = 0
            seed = 42
        }
    } | ConvertTo-Json -Depth 6 -Compress

    $job = Start-Job -ScriptBlock {
        param($requestBody, $uri)
        Invoke-RestMethod -Uri $uri -Method Post -ContentType 'application/json' -Body $requestBody -TimeoutSec 900
    } -ArgumentList $payload, $endpoint

    $peakWorkingSet = 0L
    $peakPrivate = 0L
    do {
        foreach ($process in Get-Process -Name ollama -ErrorAction SilentlyContinue) {
            $peakWorkingSet = [Math]::Max($peakWorkingSet, $process.WorkingSet64)
            $peakPrivate = [Math]::Max($peakPrivate, $process.PrivateMemorySize64)
        }
        Start-Sleep -Milliseconds 200
        $state = $job.State
    } while ($state -eq 'Running' -or $state -eq 'NotStarted')

    $response = Receive-Job -Job $job -Wait -AutoRemoveJob
    if (-not $response.done) {
        throw "Ollama did not complete the request for context $context."
    }

    $promptSeconds = $response.prompt_eval_duration / 1e9
    $generationSeconds = $response.eval_duration / 1e9
    [pscustomobject]@{
        context_tokens = $context
        load_seconds = [Math]::Round($response.load_duration / 1e9, 3)
        prompt_tokens = $response.prompt_eval_count
        prompt_seconds = [Math]::Round($promptSeconds, 3)
        prompt_tokens_per_second = [Math]::Round($response.prompt_eval_count / $promptSeconds, 3)
        generated_tokens = $response.eval_count
        generation_seconds = [Math]::Round($generationSeconds, 3)
        generation_tokens_per_second = [Math]::Round($response.eval_count / $generationSeconds, 3)
        total_seconds = [Math]::Round($response.total_duration / 1e9, 3)
        peak_working_set_gib = [Math]::Round($peakWorkingSet / 1GB, 3)
        peak_private_gib = [Math]::Round($peakPrivate / 1GB, 3)
    }
}

$results | ConvertTo-Json -Depth 4
