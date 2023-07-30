function Copy-Rule {
  param(
    [parameter(mandatory=$true)][OrderedDictionary]$Rule
  )

  $memoryStream = New-Object IO.MemoryStream
  $binaryFormatter = New-Object Runtime.Serialization.Formatters.Binary.BinaryFormatter
  $binaryFormatter.Serialize($memoryStream, $Rule)
  $memoryStream.Position = 0
  return $binaryFormatter.Deserialize($memoryStream)
}
