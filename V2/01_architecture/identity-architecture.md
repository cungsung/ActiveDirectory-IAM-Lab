# Identity Architecture

This document describes the identity architecture implemented for V2 of the Aerotyne Active Directory IAM Lab.

The architecture is intentionally designed as a laboratory environment. Aerotyne is a fictional organization used to provide context for identity and access management exercises.

## Domain

**Domain:** `corp.aerotyne.com`

### Rationale

The domain name was intentionally chosen to distinguish the V2 laboratory from a production enterprise environment.


The domain namespace is also treated as an architectural decision rather than simply a value entered during Active Directory installation. Future hybrid identity work will require evaluating how the on-premises namespace relates to user identities and Microsoft Entra ID.

## Domain Controller

**Domain Controller:** `DC01`

**IP Address:** `192.168.20.10`

### Rationale

The domain controller was originally considered as `DC02` to distinguish V2 from the previous V1 laboratory.

The name was ultimately changed to `DC01`. The V2 directory structure already provides a clear separation between the two iterations, making a different host number unnecessary.

`DC01` provides the core Active Directory Domain Services and DNS functionality required by the current environment.

## Organizational Unit Structure

The V2 environment uses Organizational Units to provide administrative and policy boundaries rather than using OUs as a representation of every possible role or permission.

The current design includes:

```text
aerotyne.local
│
├── Accounts
│   └── Sales
│
├── Devices
│   └── Sales
│
├── Groups
│
├── Admin Accounts
│
└── Domain Controllers
```

Additional departmental and organizational structures will be introduced as the laboratory expands.

### Department-Based Organization

User accounts are organized primarily according to department rather than individual job role.

For example:

```text
Accounts
└── Sales
```

The purpose of this design is to avoid creating an OU for every role within the organization.

A larger environment could contain many job functions. Organizing every role as an OU would create unnecessary administrative complexity and would make the directory structure difficult to manage.

Instead, department membership provides the organizational structure while security groups provide role and entitlement information.

This produces a separation between organizational placement and authorization:

```text
OU
↓
Administrative and policy organization

Security Group
↓
Role and entitlement

Resource ACL
↓
Actual authorization
```

This distinction is an important design principle in the V2 laboratory.

## Accounts

The `Accounts` structure contains user identities organized according to department.

The current Sales structure is:

```text
Accounts
└── Sales
```

The purpose is to provide a predictable location for user objects and establish an appropriate boundary for future Group Policy and administrative delegation.

The OU does not determine what a user is authorized to access. Authorization is handled through security group membership and resource permissions.

## Devices

User devices are separated from user accounts.

The current Sales structure is:

```text
Devices
└── Sales
```

The Windows 11 laboratory workstation is located in the Sales device OU.

This separation allows device-oriented policies and user-oriented policies to evolve independently.

For example, a future GPO may apply to Sales workstations without necessarily applying the same configuration to Sales user accounts.

## Groups

A dedicated `Groups` OU is used for security groups.

The purpose of the OU is organizational and administrative. It provides a predictable location for groups rather than mixing group objects with user or computer objects.

The actual permissions granted by these groups are documented separately in the security group architecture documentation.

## Administrative Accounts

Administrative identities are intentionally separated from normal user identities.

The purpose of the `Admin Accounts` OU is to provide a dedicated location for accounts used for elevated administrative responsibilities.

The design is based on the principle that administrative activity should be separated from ordinary day-to-day user activity.

A future privileged identity model will further develop this concept by distinguishing standard user identities from privileged administrative identities and defining how administrative access is granted, controlled, and audited.

## Disabled Users

A dedicated disabled-user location is planned as part of the identity lifecycle design.

The purpose is to retain disabled user objects in a controlled location after an account is deprovisioned.

The OU itself does not perform deprovisioning. The lifecycle process is responsible for disabling the account and moving the object as appropriate.

This structure will become more important when the Joiner, Mover, and Leaver lifecycle process is implemented.

## Identity and Authorization Separation

One of the primary architectural principles of V2 is that organizational structure should not be confused with authorization.

For example, a Sales user may be located at:

```text
OU=Sales
```

but their access to resources is determined through group membership:

```text
User
↓
GG-Sales-Representatives
↓
DL-Sales-Data
↓
Resource permissions
```

This allows the directory structure to remain relatively stable while roles and resource entitlements can change independently.

## Future Hybrid Identity

V2 is intended to eventually evolve into a hybrid identity environment using Microsoft Entra ID.

The current phase establishes the on-premises identity foundation before introducing cloud synchronization.

The planned progression is:

```text
On-Premises Active Directory
        ↓
Identity and authorization model
        ↓
Validation and testing
        ↓
Microsoft Entra ID
        ↓
Hybrid identity
```

The exact synchronization scope and identity model will be determined during the Entra phase rather than assuming that every on-premises object should automatically be synchronized.

The on-premises architecture should therefore be considered the foundation for future hybrid identity work, not the final state of the V2 environment.
