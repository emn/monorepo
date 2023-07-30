function Invoke-ExampleFunction {
  param(
    [parameter(mandatory=$true)][OrderedDictionary]$Rule,
    [parameter(mandatory=$true)][pscustomobject]$Issue
  )

  try {
    Write-Host "Invoke-ExampleFunction executed successfully!"
    return $Rule
  } catch {
    continue
  }
}
