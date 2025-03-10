param (
    [string]$command
)

# Split the command and arguments into an array
$commandParts = $command -split ' '

# Run the command 5 times and measure the time
$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $start = Get-Date

    # Use Start-Process to run the command as an external process
    Start-Process -FilePath $commandParts[0] -ArgumentList $commandParts[1..($commandParts.Length - 1)] -Wait

    $end = Get-Date
    $executionTime = ($end - $start).TotalSeconds
    $times += $executionTime

    # Log the time for each execution
    Write-Host "Execution $($i+1) took $executionTime seconds"
}

# Calculate the average time
$averageTime = ($times | Measure-Object -Average).Average
Write-Host "Average execution time: $averageTime seconds"