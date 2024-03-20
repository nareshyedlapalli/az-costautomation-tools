@description('Workload name')
param workload string

@description('Environment name')
param environment string

@description('Resource Group location')
param location string

@description('AddDenyResourcePolicy Runbook Name')
var AddDenyResourcePolicyRunbook = 'AddDenyResourcePolicy'

@description('RemoveDenyPolicy Runbook Name')
var RemoveDenyPolicyRunbook = 'RemoveDenyPolicy'

@description('Delete old resources Runbook Name')
var DeleteOldResourcesRunbook = 'DeleteOldResources'

@description('Send Email Alert')
var SendEmailAlertRunbook = 'SendEmailAlert'

var automationAccountName = 'aa-${workload}-${environment}-${location}-01'

@description('Parameter to store the curent time')
param Time string = utcNow()

@description('Creating Automation account resource ')
resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

@description('Creating a schedule for Add deny Resource policy')
resource AddDenyResourcePolicySchedule 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: 'AddDenyResourcePolicySchedule'
  properties: {
    description: 'Run every day once'
    startTime: '2024-01-24T22:19:00-05:00'
    expiryTime: '9999-12-31T17:59:00-06:00'
    interval: 1
    frequency: 'Day'
    timeZone: 'America/Chicago'
  }
}

@description('Creating a job schedule for Add deny Resource policy')
resource AddDenyResourcePolicyjobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
  parent: automationAccount
  // name: guid(resourceGroup().id, 'AddDenyResourcePolicyjobSchedule')
  name: guid(Time,'AddDenyResourcePolicyjobSchedule')
  properties: {
    runbook: {
      name: AddDenyResourcePolicyRunbook
    }
    schedule: {
      name: 'AddDenyResourcePolicySchedule'
    }
  }
}

@description('Creating a schedule to run for removing deny resource creation policy at the start of every month')
resource RemoveDenyPolicystartOfMonthSchedule 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: 'RemoveDenyPolicySchedule'
  properties: {
    description: 'start of every month'
    startTime: '2024-01-24T21:13:00-05:00'
    expiryTime: '9999-12-31T17:59:00-06:00'
    interval: 1
    frequency: 'Month'
    timeZone: 'America/Chicago'
    advancedSchedule: {
      monthDays: [
        1
      ]
    }
  }
}

@description('Creating a job schedule for removing deny resource creation policy runbook') 
resource RemoveDenyPolicyjobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
  parent: automationAccount
  name: guid(Time, 'RemoveDenyPolicyjobSchedule')

  properties: {
    runbook: {
      name: RemoveDenyPolicyRunbook 
    }
    schedule: {
      name: 'RemoveDenyPolicySchedule'
    }
  }
}

@description('Creating a schedule for delete old resources runbook')
resource DeleteOldResourcesSchedule 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: 'DeleteOldResourcesSchedule'
  properties: {
    description: 'Run every day once'
    startTime: '2024-01-24T22:19:00-05:00'
    expiryTime: '9999-12-31T17:59:00-06:00'
    interval: 1
    frequency: 'Day'
    timeZone: 'America/Chicago'
  }
}

@description('Creating a job schedule for delete old resources runbook')
resource DeleteOldResourcesjobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
  parent: automationAccount
  name: guid(Time, 'DeleteOldResourcesjobSchedule')
  properties: {
    runbook: {
      name: DeleteOldResourcesRunbook
    }
    schedule: {
      name: 'DeleteOldResourcesSchedule'
    }
  }
}

@description('Creating a schedule for delete old resources runbook')
resource SendEmailAlertSchedule 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: 'SendEmailAlertSchedule'
  properties: {
    description: 'Run every day once'
    startTime: '2024-01-24T22:19:00-05:00'
    expiryTime: '9999-12-31T17:59:00-06:00'
    interval: 1
    frequency: 'Day'
    timeZone: 'America/Chicago'
  }
}

@description('Creating a job schedule for delete old resources runbook')
resource SendEmailAlertjobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
  parent: automationAccount
  name: guid(Time, 'SendEmailAlertjobSchedule')
  properties: {
    runbook: {
      name: SendEmailAlertRunbook
    }
    schedule: {
      name: 'SendEmailAlertSchedule'
    }
  }
}
