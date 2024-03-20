@description('Resource Group location')
param location string

@description('managementSubscriptionId')
param managementSubscriptionId string

@description('logAnalyticsWorkspace resourceGroup name')
param logAnalyticsWorkspaceRg string

@description('logAnalyticsWorkspaceName to query the alret')
param logAnalyticsWorkspaceName string

@description('actionGroupName')
param actionGroupId string


@description('alertRuleName')
param alertRuleName string


@description('An alert rule')
resource alertRule 'Microsoft.Insights/scheduledQueryRules@2022-08-01-preview' = {
  name: alertRuleName
  location: location
  properties: {
    displayName: alertRuleName
    severity: 2
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      resourceId(managementSubscriptionId, logAnalyticsWorkspaceRg, 'microsoft.operationalinsights/workspaces', logAnalyticsWorkspaceName)
    ]
    targetResourceTypes: [
      'microsoft.operationalinsights/workspaces'
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          query: 'AzureDiagnostics | where ResourceProvider == "MICROSOFT.AUTOMATION" and Category == "JobStreams" and StreamType_s == "Error" | project TimeGenerated , RunbookName_s , StreamType_s , _ResourceId , ResultDescription , JobId_g'
          timeAggregation: 'Count'
          dimensions: [
            {
              name: 'Resource_Id'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          operator: 'GreaterThan'
          threshold: 0
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
    autoMitigate: false
    actions: {
      actionGroups: [
        actionGroupId
      ]
      customProperties: {}     
    }  
  }
}
