# Hybrid Authentication

## Authentication Flow

The lab uses Password Hash Synchronization (PHS).

The authentication flow is:

Active Directory
        ↓
User password changed
        ↓
Entra Connect
        ↓
Password Hash Synchronization
        ↓
Microsoft Entra ID
        ↓
Microsoft 365
        ↓
User authentication succeeds

## Example Account

Test account:

- AD username: jlee
- AD UPN: jlee@corp.aerotyne.com
- Entra UPN: [exact UPN shown in Entra]
- On-premises sync: Enabled
- Authentication method: Password Hash Synchronization

## Test Procedure

1. Reset the password for `jlee` in Active Directory.
2. Allow Entra Connect to synchronize the password hash.
3. Sign in to Microsoft 365 using the synchronized account.
4. Confirm that authentication succeeds.

## Result

PASS

The `jlee` account successfully authenticated to Microsoft 365 using
the password associated with the on-premises Active Directory account.

## IAM Concepts Demonstrated

- Hybrid identity
- Password Hash Synchronization
- Identity synchronization
- Cloud authentication
- On-premises identity as the source
- Separation between identity synchronization and authorization

  ## Evidence

The following screenshot demonstrates successful Microsoft 365
authentication using the synchronized `jlee` account.

![Successful Microsoft 365 login](04_screenshots/jlee-m365.png)
