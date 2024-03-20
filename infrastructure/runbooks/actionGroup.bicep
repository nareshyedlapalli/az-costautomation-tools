@description('actionGroupName')
param actionGroupName string

@description('actionGroupName')
param groupshortName string = 'policyalert'

@description('alert reciveer EmailIds')
param emailReceivers array

@description('An action group to be notified of alerts')
resource actionGroup 'microsoft.insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: groupshortName
    enabled: true
    emailReceivers: emailReceivers
  }
}

output actionGroupId string = actionGroup.id
