# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

PowerShell automation script to configure open calendar permissions for Wortell users in a Microsoft 365 / Exchange Online environment.

Main script: [C-Wortell-Set-OpenCalendars.ps1](C-Wortell-Set-OpenCalendars.ps1)

## Execution Model

This script runs as an **Azure Automation runbook**. It authenticates to Exchange Online using a certificate stored in the Automation Account — there is no interactive login. The script uses `Connect-ExchangeOnline` with `-CertificateThumbprint`, `-AppId`, and `-Organization`.

## Testing Iterations

Local testing is not straightforward because the certificate lives in Azure Automation. Options:

1. **Azure portal test pane**: publish to the Automation Account and use "Test" in the runbook editor — fastest for quick iteration.
2. **Local certificate**: export the cert from the Automation Account, install it locally, and run with the same connection parameters.

## Environment

- Microsoft 365 / Exchange Online tenant: wortell.nl
- Required module: `ExchangeOnlineManagement`
- Runtime: Azure Automation (PowerShell 7.2 runbook)
