# C-Wortell-Set-OpenCalendars

PowerShell script to configure open calendar permissions for Wortell users in Exchange Online. Runs as an **Azure Automation runbook**, authenticating via a certificate stored in the Automation Account.

## Prerequisites

- [ExchangeOnlineManagement](https://www.powershellgallery.com/packages/ExchangeOnlineManagement) module
- An Azure Automation Account with:
  - A certificate asset for authentication
  - An app registration in Entra ID with Exchange Online permissions

## Authentication

The script connects to Exchange Online using certificate-based authentication (no interactive login):

```powershell
Connect-ExchangeOnline -CertificateThumbprint $CertThumbprint `
                       -AppId $AppId `
                       -Organization "wortell.nl"
```

The certificate thumbprint and app ID are retrieved from Azure Automation variables/assets at runtime.

## Testing

Because authentication relies on a certificate stored in Azure Automation, local testing requires one of:

- **Run in Azure Automation**: publish the script as a runbook and trigger a test job in the portal.
- **Local certificate**: export the certificate from the Automation Account and install it locally, then run with the same `Connect-ExchangeOnline` parameters.

## Repository

[PaulSchuurWortell/C-Wortell-Set-OpenCalendars](https://github.com/PaulSchuurWortell/C-Wortell-Set-OpenCalendars)
