param(
    [switch] $ReachabilityOnly = $true,
    [int] $TimeoutSecs = 60,
    [string] $Endpoints = ''
)

# Convenience PowerShell wrapper to run the smoke-test with sensible defaults.
$env:REACHABILITY_ONLY = if ($ReachabilityOnly) { '1' } else { '0' }
$env:TIMEOUT_SECS = $TimeoutSecs.ToString()

Write-Host "Running smoke-test (REACHABILITY_ONLY=$($env:REACHABILITY_ONLY), TIMEOUT_SECS=$($env:TIMEOUT_SECS))"
if ($Endpoints -ne '') {
    Write-Host "  Checking endpoints: $Endpoints"
    docker compose run --rm -e ENDPOINTS="$Endpoints" smoke-test
} else {
    docker compose run --rm smoke-test
}

exit $LASTEXITCODE
