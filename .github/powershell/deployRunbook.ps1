param($ResourceGroup, $automationAccountName)

$RemoveDenyPolicyRunbook = 'RemoveDenyPolicy'
$AddDenyResourcePolicyRunbook = 'AddDenyResourcePolicy'
$DeleteOldResourcesRunbook = 'DeleteOldResources'
$SendEmailAlertRunbook = 'SendEmailAlert'

Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $AddDenyResourcePolicyRunbook -Path "./infrastructure/runbooks/AddDenyResourcePolicy.ps1" -Published -Type PowerShell -Force
Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $RemoveDenyPolicyRunbook -Path "./infrastructure/runbooks/RemoveDenyPolicy.ps1" -Published -Type PowerShell -Force
Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $DeleteOldResourcesRunbook -Path "./infrastructure/runbooks/DeleteOldResources.ps1" -Published -Type PowerShell -Force
Import-AzAutomationRunbook -AutomationAccountName $automationAccountName -ResourceGroupName $ResourceGroup -Name $SendEmailAlertRunbook -Path "./infrastructure/runbooks/SendEmailAlert.ps1" -Published -Type PowerShell -Force
