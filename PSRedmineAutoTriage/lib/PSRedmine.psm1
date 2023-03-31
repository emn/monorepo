#An API wrapper for Redmine in PowerShell.
#Forked from https://github.com/hamletmun/PSRedmine and customised for my own needs.
#Designed to be used by other PowerShell scripts, not interactively.

Add-Type -TypeDefinition @'
public enum ResourceType {
    project,
    version,
    issue,
    membership,
    user
}
public enum StatusType {
    open,
    locked,
    closed
}
public enum SharingType {
    none,
    descendants,
    hierarchy,
    tree,
    system
}
'@

function Connect-Redmine {
  param(
    [parameter(mandatory = $true)][string]$script:Server,
    [parameter(mandatory = $true)][string]$script:ApiKey
  )

  $irmParams = @{
    Headers = @{ 'X-Redmine-API-Key' = $script:ApiKey }
    Method  = 'GET'
    Uri     = $script:Server + '/users/current.json'
  }

  Invoke-RestMethod @irmParams > $null

  return
}

function Disconnect-Redmine {
  Remove-Variable -Name Server -Scope script
  Remove-Variable -Name ApiKey -Scope script
  return
}

function Send-HTTPRequest {
  param(
    [parameter(mandatory = $true)][string]$Method,
    [parameter(mandatory = $true)][string]$Uri,
    [parameter()][string]$Body
  )

  $irmParams = @{
    Headers = @{ "X-Redmine-API-Key" = $script:ApiKey }
    Method  = $Method
    Uri     = $script:Server + $Uri
  }

  if ($Body) {
    $utf8 = [System.Text.Encoding]::UTF8
    $irmParams += @{
      ContentType = 'application/json'
      Body        = $utf8.GetBytes($Body)
    }
  }

  return Invoke-RestMethod @irmParams

}

function New-RedmineResource {
  param(
    [parameter(mandatory = $true)][ResourceType]$Type,
    [string]$ProjectId,
    [string]$Identifier,
    [string]$Name,
    [string]$Description,
    [int]$DefaultVersionId,
    [int]$TrackerId,
    [string]$StatusId,
    [int]$VersionId,
    [string]$Subject,
    [string]$Notes,
    [datetime]$DueDate,
    [StatusType]$Status,
    [SharingType]$Sharing
  )

  if ($Type -eq 'issue') {
    $json = @{ issue = @{ } }
    if ($ProjectId) { $json.issue.Add( 'project_id', $ProjectId ) }
    if ($TrackerId) { $json.issue.Add( 'tracker_id', $TrackerId ) }
    if ($StatusId) { $json.issue.Add( 'status_id', $StatusId ) }
    if ($VersionId) { $json.issue.Add( 'fixed_version_id', $VersionId ) }
    if ($Subject) { $json.issue.Add( 'subject', $Subject ) }
    if ($Description) { $json.issue.Add( 'description', $Description ) }
    if ($Notes) { $json.issue.Add( 'notes', $Notes ) }
    $json = $json | ConvertTo-Json

    $response = Send-HTTPRequest -Method 'POST' -Uri /issues.json -Body $json
  }
  elseif ($Type -eq 'version') {
    $json = @{ version = @{ } }
    if ($Name) { $json.version.Add( 'name', $Name ) }
    if ($Description) { $json.version.Add( 'description', $Description ) }
    if ($DueDate) { $json.version.Add( 'due_date', $DueDate.ToString("yyyy-MM-dd") ) }
    if ($Status) { $json.version.Add( 'status', $Status.ToString() ) }
    if ($Sharing) { $json.version.Add( 'sharing', $Sharing.ToString() ) }
    $json = $json | ConvertTo-Json

    $response = Send-HTTPRequest -Method 'POST' -Uri /projects/$ProjectId/versions.json -Body $json
  }
  elseif ($Type -eq 'project') {
    $json = @{ project = @{ } }
    if ($Name) { $json.project.Add( 'name', $Name ) }
    if ($Description) { $json.project.Add( 'description', $Description ) }
    if ($Identifier) { $json.project.Add( 'identifier', $Identifier ) }
    if ($DefaultVersionId) { $json.project.Add( 'default_version_id', $DefaultVersionId ) }
    $json = $json | ConvertTo-Json

    $response = Send-HTTPRequest -Method 'POST' -Uri "/projects.json" -Body $json
  }

  return $response
}

function Get-RedmineResourceList {
  param(
    [parameter(mandatory = $true)][ResourceType]$Type,
    [parameter()][string]$AssignedToId
  )

  return Send-HTTPRequest -Method 'GET' -Uri "/$Type`s.json?limit=100&assigned_to_id=$AssignedToId"
}

function Get-RedmineResource {
  Param(
    [Parameter(Mandatory = $true)][ResourceType]$Type,
    [Parameter(Mandatory = $true)][String]$Id
  )

  Switch -Regex ($Type) {
    '\A(issue)\Z' { $response = (Send-HTTPRequest -Method 'GET' -Uri "/$Type`s/$Id.json?include=journals,watchers").issue }
    '\A(user)\Z' { $response = (Send-HTTPRequest -Method 'GET' -Uri "/$Type`s/$Id.json?include=memberships,groups").user }
    default { $response = (Send-HTTPRequest -Method 'GET' -Uri "/$Type`s/$Id.json").$Type }
  }

  return $response
}

function Edit-RedmineResource {
  param(
    [parameter(Mandatory = $true)][ResourceType]$Type,
    [parameter(Mandatory = $true)][string]$Id,
    [string]$ProjectId,
    [string]$Name,
    [string]$Description,
    [int]$DefaultVersionId,
    [int]$TrackerId,
    [string]$StatusId,
    [int]$VersionId,
    [string]$Subject,
    [string]$Notes,
    [datetime]$DueDate,
    [StatusType]$Status,
    [SharingType]$Sharing
  )

  if ($Type -eq 'issue') {
    $json = @{ issue = @{ } }
    if ($ProjectId) { $json.issue.Add( 'project_id', $ProjectId ) }
    if ($TrackerId) { $json.issue.Add( 'tracker_id', $TrackerId ) }
    if ($StatusId) { $json.issue.Add( 'status_id', $StatusId ) }
    if ($VersionId) { $json.issue.Add( 'fixed_version_id', $VersionId ) }
    if ($Subject) { $json.issue.Add( 'subject', $Subject ) }
    if ($Description) { $json.issue.Add( 'description', $Description ) }
    if ($Notes) { $json.issue.Add( 'notes', $Notes ) }
    $json = $json | ConvertTo-Json

    $response = Send-HTTPRequest -Method 'PUT' -Uri "/issues/$Id.json" -Body $json

  }
  elseif ($Type -eq 'version') {
    $json = @{ version = @{ } }
    if ($Name) { $json.version.Add( 'name', $Name ) }
    if ($Description) { $json.version.Add( 'description', $Description ) }
    if ($DueDate) { $json.version.Add( 'due_date', $DueDate.ToString("yyyy-MM-dd") ) }
    if ($Status) { $json.version.Add( 'status', $Status.ToString() ) }
    if ($Sharing) { $json.version.Add( 'sharing', $Sharing.ToString() ) }
    $json = $json | ConvertTo-Json

    $response = Send-HTTPRequest -Method 'PUT' -Uri "/versions/$Id.json" -Body $json

  }
  elseif ($Type -eq 'project') {
    $json = @{ project = @{ } }
    if ($Name) { $json.project.Add( 'name', $Name ) }
    if ($Description) { $json.project.Add( 'description', $Description ) }
    if ($DefaultVersionId) { $json.project.Add( 'default_version_id', $DefaultVersionId ) }
    $json = $json | ConvertTo-Json

    $response = Send-HTTPRequest -Method 'PUT' -Uri "/projects/$Id.json" -Body $json
  }

  return $response
}

function Remove-RedmineResource {
  param(
    [parameter(mandatory = $true)][ResourceType]$Type,
    [parameter(mandatory = $true)][string]$Id
  )

  return Send-HTTPRequest -Method 'DELETE' -Uri "/$Type`s/$Id.json"
}
