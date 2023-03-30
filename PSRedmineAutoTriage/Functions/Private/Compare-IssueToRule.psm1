function Compare-IssueToRule {
  param(
    [parameter(mandatory=$true)][OrderedDictionary]$Rule,
    [parameter(mandatory=$true)][pscustomobject]$Issue
  )

  function Test-Match ($issueField, $filterField) {
    return ($null -eq $filterField) -or ($issueField -match $filterField)
  }

  $filter = $Rule.filter

  (Test-Match $Issue.subject $filter.Subject) -and
  (Test-Match $Issue.description $filter.Description) -and
  (Test-Match $Issue.author.id $filter.Author)
}
