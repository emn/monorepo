using namespace 'System.Collections.Specialized'

param(
  [parameter()]$Configuration
)

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'

Import-Module PSYaml
Import-Module PSRedmine

$functions = Get-ChildItem -Recurse '.\Functions\*.psm1'
$functions.FullName | Import-Module

[OrderedDictionary]$config = Get-Content -Raw $Configuration | ConvertFrom-Yaml

Connect-Redmine $config.Server $config.ApiKey

$issues = Get-RedmineResourceList issue $config.Queue

foreach ($issue in $issues.Issues) {
  foreach ($rule in $config.Rules) {
    # Use a copy to avoid changing the dict we are iterating over
    # Deep copy because OrderedDictionary is a Reference type
    [OrderedDictionary]$ruleCopy = Copy-Rule -Rule $rule

    if (-not (Compare-IssueToRule -Issue $issue -Rule $ruleCopy)) {
      continue
    }

    if ($ruleCopy.Contains("Function")) {
      $ruleCopy = &$ruleCopy.Function -Rule $ruleCopy -Issue $issue
    }

    Edit-RedmineResource issue $issue.Id -Notes $ruleCopy.Action.Notes

    break
  }
}
