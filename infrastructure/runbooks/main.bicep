@description('Workload name')
param workload string

@description('Environment name')
param environment string

@description('Resource Group location')
param location string

@description('SMTP configuration password')
@secure()
param smtppassword string

@description('A module that defines all the environment specific configuration')
module configModule './configuration.bicep' = {
  name: '${resourceGroup().name}-config-module'
  scope: resourceGroup()
  params: {
    environment: environment
  }
}

@description('A variable to hold all environment specific variables')
var config = configModule.outputs.settings

@description('Obtaining reference to the virtual network subnet for the private endpoints')
resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  name: '${config.privateEndpointVnet.virtualNetworkName}/${config.privateEndpointVnet.subnetName}'
  scope: resourceGroup(config.privateEndpointVnet.resoureGroupName)
}

@description('Module to create automation-account')
module automationAccountModule './automation-account.bicep' = {
  name:  'aa-${workload}-${environment}-${location}-01'
  params: {
    automationAccountName: 'aa-${workload}-${environment}-${location}-01'
    location: location
    PolicyId: config.PolicyId
    ExcludedRGFromDenyPolicyAddition: config.ExcludedRGFromDenyPolicyAddition
    ExcludedRGFromResourceDeletion: config.ExcludedRGFromResourceDeletion
    SubscriptionID: config.SubscriptionID
    smtpserver: config.smtpserver
    smtpport: config.smtpport
    sender: config.sender
    privateEndpointSubnetId: privateEndpointSubnet.id
    workload: workload
    environment: environment
    smtppassword: smtppassword
  }    
}

@description('Module to create actions resources')
module actionGroupModule 'actionGroup.bicep' = {
  name: 'ag-${workload}-${environment}-${location}-01'
  params: {
    actionGroupName: 'ag-${workload}-${environment}-${location}-01'
    emailReceivers: config.emailReceivers
  }
}

@description('Module to create alert resources')
module alertRuleModule 'alertRule.bicep' = {
  name: 'ar-${workload}-${environment}-${location}-01'
  params: {
    alertRuleName: 'ar-${workload}-${environment}-${location}-01'
    location: location
    managementSubscriptionId: config.logAnalyticsWorkspace.subscriptionId
    logAnalyticsWorkspaceRg: config.logAnalyticsWorkspace.resoureGroupName
    logAnalyticsWorkspaceName: config.logAnalyticsWorkspace.workspaceName
    actionGroupId: actionGroupModule.outputs.actionGroupId
  }
  dependsOn: [
    actionGroupModule
  ]
}
