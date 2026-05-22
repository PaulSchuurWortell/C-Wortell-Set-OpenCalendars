## Author                   Date         Comment
##------------------------------------------------------------------------------  
##                           Unknown      Initial Version
## Sander Kok               01-08-2024   Changed logon method to app reg + certificate and changed the ForEach'es to deal with the errors
##                                        Added check for 'kalender' as well
## Paul Schuur              20260205     Changed exclusion list for mailboxes that should not be modified to check on both Name and DisplayName
## Paul Schuur              20260522     Took ownership; moved to version control (GitHub)
## Paul Schuur                           TODO enumerate excluded mailboxes from a group instead of hardcoding them in the script
## Paul Schuur                           TODO enumerate calendar folders instead of trial and error
            

#$Credentials = Get-AutomationPSCredential -Name SVC_Wortell_Online

$Organization          = 'wortell.onmicrosoft.com'
$ApplicationId         = 'b1705508-fcc7-476f-97d8-fe416d3a5ca4'      ## Set-OpenCalendars App Reg
$CertificateThumbPrint = 'A8FA422935ED45568B8A1A7C9371AB8A03D1E586'  ## App Reg Certificate thumbprint

import-module ExchangeOnlineManagement

#Connect naar Exchange Online
#Connect-ExchangeOnline -Credential $Credentials
Connect-ExchangeOnline -AppId $ApplicationId -CertificateThumbPrint $CertificateThumbPrint -Organization $Organization


#Haalt alle UserMailboxes op
$Mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited | Where-Object {$_.Name -notin 'Danny Burlage', 'Luc Joziasse', 'Maarten Goet', 'Brunia van Brakel', 'Vincent Wylenzek', 'Bart Brolsma', 'Joost Dankers', 'Belynda Knight', 'Nynke Veenman', 'Pea Smeets', 'Melvin de Boer' -and $_.DisplayName -notin  'Danny Burlage', 'Luc Joziasse', 'Maarten Goet', 'Brunia van Brakel', 'Vincent Wylenzek', 'Bart Brolsma', 'Joost Dankers', 'Belynda Knight', 'Nynke Veenman', 'Pea Smeets', 'Melvin de Boer'}

ForEach ($Mailbox in $Mailboxes){
    Try {
        Set-MailboxFolderPermission -Identity "$($Mailbox.UserPrincipalName):\Calendar" -User Default -AccessRights LimitedDetails -Erroraction Stop -WarningAction SilentlyContinue
        Write-Output "$($Mailbox.UserPrincipalName):\Calendar `t set"
    }
    Catch {
        Try {
            ##  If the language is NL, use 'Agenda' instead of 'Calendar'
            Set-MailboxFolderPermission -Identity "$($Mailbox.UserPrincipalName):\Agenda" -User Default -AccessRights LimitedDetails -Erroraction Stop -WarningAction SilentlyContinue
            Write-Output "$($Mailbox.UserPrincipalName):\Agenda `t ingesteld"
        }
        Catch {
            ##  If we end up here, neither 'Calendar' nor 'Agenda' worked. Something is wrong.
            ##  UPDATE: it sure is... there seems to be a user with 'kalender'...
            Try {
                Set-MailboxFolderPermission -Identity "$($Mailbox.UserPrincipalName):\Kalender" -User Default -AccessRights LimitedDetails -Erroraction Stop -WarningAction SilentlyContinue
                Write-Output "$($Mailbox.UserPrincipalName):\Kalender `t ingesteld"
            }
            Catch {
                Write-Output "Error setting permissions on mailbox [$($Mailbox.Name)]"
            }
        }
    }
}

#Verbreek de verbinding met Exchange Online
Disconnect-ExchangeOnline -Confirm:$false   