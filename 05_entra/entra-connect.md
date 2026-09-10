 Microsoft Entra Connect Config
 ------------------------------

## AD structure 
The structure I chose to test the Entra sync is as follows:
Aerotyne|
        |
         --Employees
                     |
                     |
                     --Entra Sync|
                                 |
                                  -- jlee
                                     rstone

## Synchronization Configuration

### Directory Connection

- On-premises forest: corp.aerotyne.com
- AD authentication: dedicated Entra Connect-created sync account
- Enterprise/domain administrator account: used only to authorize initial configuration

### Microsoft Entra Sign-in Configuration

- On-premises attribute used for Entra username: userPrincipalName
- User identification: mail
- Source anchor: Microsoft Entra-managed configuration
- UPN suffix mismatch: continued without matching all UPN suffixes to verified domains

### Domain and OU Filtering

Only the following OU is included:

`OU=Entra-Sync,OU=Employees,OU=Aerotyne,DC=corp,DC=aerotyne,DC=com`

Finance, HR, IT, and Sales were intentionally excluded from synchronization.

### Authentication

- Password Hash Synchronization: Enabled
- Password writeback: Disabled
- Group writeback: Disabled
- Directory extension attribute synchronization: Disabled
- Seamless SSO: Enabled

## Synchronization Schedule

- Sync cycle interval: 30 minutes
- Delta synchronization: Enabled
- Scheduler enabled: Yes
- Staging mode: Disabled

## Initial Synchronization

The initial synchronization completed successfully.

The following connectors participated:

- corp.aerotyne.com
- Microsoft Entra ID connector

## Design Decisions

### Why use an Entra-Sync OU?

The dedicated OU provides a simple boundary between accounts that should
synchronize to Entra ID and accounts that should remain on-premises only.

### Why use Password Hash Synchronization?

PHS allows the lab to demonstrate hybrid authentication without requiring
AD FS or another federation infrastructure.

### Why exclude departmental OUs?

This follows least-privilege principles. Only accounts intentionally
selected for the hybrid environment are synchronized.
