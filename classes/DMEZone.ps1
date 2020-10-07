class DMEZone {
    [int]$id
    [string]$name
    [Int64]$created
    [Int64]$updated
    [int]$folderId
    [int]$pendingActionId
    [bool]$gtdEnabled
    [bool]$processMulti
    [psobject[]]$activeThirdParties
}