# Security Group Architecture

This document describes the security group model implemented in V2 of the Aerotyne Active Directory IAM Lab.

The group architecture separates organizational roles from resource entitlements. This allows users to receive access based on their assigned role without requiring resource permissions to be manually assigned to individual user accounts.

## Design Model

The V2 group model follows this general pattern:

```text
User
  ↓
Global Role Group
  ↓
Domain Local Entitlement Group
  ↓
Resource Permission
```

The Global group represents what the user does.

The Domain Local group represents what the user is allowed to access.

The resource permission is assigned to the Domain Local group rather than directly to the user.

This separates identity management from resource authorization.

## Sales Role Groups

The current Sales role groups are:

| Group                      | Scope  | Purpose                                                    |
| -------------------------- | ------ | ---------------------------------------------------------- |
| `GG-Sales-Representatives` | Global | Represents users assigned to the Sales Representative role |
| `GG-Sales-Supervisors`     | Global | Represents users assigned to the Sales Supervisor role     |

These groups describe roles rather than specific resources.

For example, membership in `GG-Sales-Representatives` indicates that a user is assigned to the Sales Representative role. It does not directly grant access to a file share or application.

## Sales Entitlement Groups

The current Sales entitlement groups are:

| Group                      | Scope        | Purpose                                                        |
| -------------------------- | ------------ | -------------------------------------------------------------- |
| `DL-Salesforce-User`       | Domain Local | Basic Salesforce access for Sales users                        |
| `DL-Salesforce-Management` | Domain Local | Elevated Salesforce permissions intended for Sales Supervisors |
| `DL-Sales-Data`            | Domain Local | Access to Sales data resources                                 |

These groups represent access rather than job roles.

## Group Nesting

The current intended nesting model is:

```text
GG-Sales-Representatives
        │
        ├── DL-Salesforce-User
        │
        └── DL-Sales-Data


GG-Sales-Supervisors
        │
        ├── DL-Salesforce-User
        │
        ├── DL-Salesforce-Management
        │
        └── DL-Sales-Data
```

The supervisor model intentionally includes the basic Salesforce entitlement in addition to the management entitlement.

Management access is additive rather than a replacement for basic application access.

## Why Global Groups Represent Roles

Global groups are used to represent organizational roles.

For example:

```text
GG-Sales-Representatives
```

means:

> This identity is assigned to the Sales Representative role.

The group does not need to know whether the user's access is to a file share, application, database, or another resource.

This keeps role membership separate from the implementation of individual resources.

## Why Domain Local Groups Represent Entitlements

Domain Local groups are used to represent access to resources.

For example:

```text
DL-Sales-Data
```

means:

> Membership in this group grants the permissions associated with Sales data.

The resource administrator can therefore assign permissions to the entitlement group without managing individual user accounts.

## Example Authorization Flow

A Sales representative receives access through the following chain:

```text
Test-Sales-Rep
        ↓
GG-Sales-Representatives
        ↓
DL-Sales-Data
        ↓
NTFS / SMB permissions
        ↓
SalesData
```

The user's identity is therefore separated from the resource ACL.

If the employee changes roles, the role-group membership can be changed without redesigning the resource permissions.

## Test Identity

The V2 lab uses a test identity named:

`testsalesrep`

Display name:

`Test-Sales-Rep`

The account is located in the Sales Accounts OU and is a member of:

```text
GG-Sales-Representatives
```

After logging into the domain-joined Windows 11 workstation, the user's security token reflected both the role group and the nested entitlement groups.

Observed groups included:

```text
CORP\GG-Sales-Representatives
CORP\DL-Sales-Data
CORP\DL-Salesforce-User
```

This demonstrated that nested group membership was being reflected in the user's Windows access token.

## Implementation Notes

The V2 lab also provided several useful PowerShell lessons during group creation.

The accepted Active Directory group scope value for a Domain Local group is:

```powershell
-GroupScope DomainLocal
```

not:

```powershell
-GroupScope Domain-Local
```

Group retrieval also requires the standard Active Directory PowerShell cmdlet syntax:

```powershell
Get-ADGroup
```

rather than:

```powershell
GetADGroup
```

These errors were configuration mistakes rather than architectural problems, but documenting them provides useful troubleshooting evidence for the lab.

## Design Principle

The group model is intended to make access changes predictable:

```text
Role changes
    ↓
Change Global group membership

Resource changes
    ↓
Change Domain Local entitlement membership or resource ACL

Individual user access
    ↓
Avoid direct resource permissions where possible
```

This reduces the need to modify resource ACLs whenever an employee joins, leaves, or changes roles.

The model will be extended as additional applications and resources are introduced into V2.
