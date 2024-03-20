@description('Environment name')
@allowed([
  'sndbx'
])
param environment string

var environmentConfigurationMap = {
  sndbx: {
    PolicyId: '/providers/Microsoft.Management/managementGroups/fbitn-sandboxes/providers/Microsoft.Authorization/policyDefinitions/dabb6b24-a690-4925-932e-2c35b13432b8'
    ExcludedRGFromDenyPolicyAddition: 'fbitn-vnet-eastus2,rg-costautomation-sndbx-eastus2-01'
    ExcludedRGFromResourceDeletion: 'fbitn-vnet-eastus2,rg-costautomation-sndbx-eastus2-01'
    SubscriptionID: '2f9fe748-a441-4789-98c8-c3d92b6a054e'
    smtpserver: 'smtp-relay.sendinblue.com'
    smtpport: '587'
    sender: 'fbsender@fbitn.com'
    privateEndpointVnet: { // Private endpoint VNet settings
      resoureGroupName: 'fbitn-vnet-eastus2'
      virtualNetworkName: 'vnet-sandbox-01-eastus2-01' // Name of the VNet
      subnetName: 'snet-sandbox-01-privateendpoint-eastus2-01'
    }
    managementGroupName: 'ucanr' 
    tenantId: '95933331-9c40-4ebf-9199-cd4c72f03a84'
    logAnalyticsWorkspace: {
      subscriptionId: '58092e4c-ca70-46e0-b4e6-99bb5c99e2e1' // Management subscription
      resoureGroupName: 'ucanr-mgmt'
      workspaceName: 'ucanr-law'
    }
    emailReceivers:[
      {
        name: 'Test Email'
        emailAddress: 'nyedlapalli@ucanr.org'
        useCommonAlertSchema: false
      }
    ]
  }
}

output settings object = environmentConfigurationMap[environment]
