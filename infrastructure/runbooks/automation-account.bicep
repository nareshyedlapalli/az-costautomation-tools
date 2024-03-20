@description('SMTP configuration password')
@secure()
param smtppassword string

@description('automationAccountName')
param automationAccountName string

@description('Subnet Id for private endpoint creation')
param privateEndpointSubnetId string

@description('location')
param location string

@description('Application environment')
param environment string

@description('Application workload type')
param workload string

@description('Deny resource creation Policy ID')
param PolicyId string

@description('Adding resources group to exluded from applying policy')
param ExcludedRGFromDenyPolicyAddition string

@description('Adding resources group to exluded from deletion')
param ExcludedRGFromResourceDeletion string

@description('smtpserver')
param smtpserver string

@description('smtpport')
param smtpport string

@description('Sender')
param sender string

@description('Sandbox subscription ID')
param SubscriptionID string

@description('Automation account private endpoint resource definition')
resource automationAccountPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: 'pep-aa-${workload}-${environment}-${location}-01'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'plconnection-aa-${workload}-${environment}'
        properties: {
          privateLinkServiceId: automationAccount.id
          groupIds: ['Webhook']
        }
      }
    ]
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

@description('Creating Automation account resource ')
resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: false
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {}
    }
  }
}

@description('A resource definition to hold policy varaible id') 
resource automationAccountPolicyIdVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'PolicyId'
  properties: {
    isEncrypted: false
    value: '"${PolicyId}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountSubscriptionIDVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'SubscriptionID'
  properties: {
    isEncrypted: false
    value: '"${SubscriptionID}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountExcludedRgListVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'ExcludedRGFromDenyPolicyAddition'
  properties: {
    isEncrypted: false
    value: '"${ExcludedRGFromDenyPolicyAddition}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountRGExcludedFromDeletionVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'ExcludedRGFromResourceDeletion'
  properties: {
    isEncrypted: false
    value: '"${ExcludedRGFromResourceDeletion}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountsmtpserverVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'smtpserver'
  properties: {
    isEncrypted: false
    value: '"${smtpserver}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountsmtpportVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'smtpport'
  properties: {
    isEncrypted: false
    value: '"${smtpport}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountSenderVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'Sender'
  properties: {
    isEncrypted: true
    value: '"${sender}"'
  }
}

@description('A resource definition to hold excludedRGlist variable') 
resource automationAccountpasswordVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  parent: automationAccount
  name: 'pass'
  properties: {
    isEncrypted: true
    value: '"${smtppassword}"'
  }
}
