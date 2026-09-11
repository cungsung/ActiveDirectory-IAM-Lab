# Active Directory & IAM Lab

A hands-on Identity and Access Management lab designed to simulate identity lifecycle and access-control processes in an enterprise environment.

The project demonstrates practical experience with Active Directory, Microsoft Entra ID, RBAC, least privilege, Joiner-Mover-Leaver (JML) workflows, PowerShell automation, and hybrid identity synchronization.

## Project Overview

The goal of this project was to build an enterprise-style identity environment and model common IAM responsibilities such as:

* User provisioning and deprovisioning
* Role and access changes
* Role-Based Access Control (RBAC)
* Least-privilege access
* Joiner-Mover-Leaver (JML) workflows
* Access reviews
* PowerShell-based provisioning automation
* Hybrid Active Directory and Microsoft Entra ID identity synchronization

This project was built as a lab environment and is not intended to represent production infrastructure. The configurations and workflows are designed to demonstrate practical understanding of IAM concepts and administrative processes.

## Environment

| Component       | Technology                       |
| --------------- | -------------------------------- |
| Server          | Windows Server 2025 Evaluation   |
| Directory       | Active Directory Domain Services |
| Cloud Identity  | Microsoft Entra ID               |
| Synchronization | Microsoft Entra Connect          |
| Authentication  | Password Hash Synchronization    |
| SSO             | Seamless SSO                     |
| Automation      | PowerShell                       |
| Data Source     | CSV / HR-style employee data     |
| Identity Model  | RBAC / Least Privilege           |
| Lifecycle       | Joiner-Mover-Leaver              |

## Architecture

The lab uses Active Directory as the primary identity directory with a dedicated organizational structure for users, computers, departments, and disabled accounts.

A dedicated OU is synchronized to Microsoft Entra ID using Microsoft Entra Connect, allowing the environment to demonstrate a basic hybrid identity architecture.

```text
                    HR-Style CSV
                         │
                         ▼
                 PowerShell Script
                         │
                         ▼
              Active Directory Domain
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
       Users         Security Groups   Computers
          │              │
          │              ▼
          │        RBAC / Least Privilege
          │
          ▼
    Microsoft Entra Connect
          │
          ▼
    Microsoft Entra ID
          │
          ▼
     Microsoft 365
```

## Active Directory Structure

The OU structure separates identities and resources according to their administrative purpose.

Example structure:

```text
Domain
│
├── Employees
│   ├── Department A
│   ├── Department B
│   └── Department C
│
├── Computers
│
├── Disabled Users
│
└── Groups
```

The structure provides a consistent location for managing identities and supports the lifecycle processes implemented throughout the lab.

## RBAC and Least Privilege

Access is assigned through security groups rather than directly assigning permissions to individual users.

Users are placed into groups based on their department and job role. Additional groups are used when users require access to specific resources.

Example:

```text
User
 │
 ├── Department Group
 │
 ├── Role Group
 │
 └── Additional Access Group
       ├── VPN
       └── Payroll
```

This approach separates identity from permissions and allows access to be managed through group membership.

The lab follows the principle of least privilege by assigning users only the access required for their simulated job responsibilities.

## Joiner-Mover-Leaver Workflow

The project models the identity lifecycle from onboarding through offboarding.

### Joiner

When a new employee is added to the HR-style CSV:

1. The employee record is processed by PowerShell.
2. An Active Directory account is created.
3. The account is placed into the appropriate OU.
4. Department and role-based group memberships are assigned.
5. Additional access is assigned when required.
6. The resulting account is validated.

### Mover

When an employee changes departments or roles:

1. Existing access is reviewed.
2. Outdated role or department access is removed.
3. New group memberships are assigned.
4. The user's effective access is validated.

This helps reduce the risk of privilege accumulation when employees change roles.

### Leaver

When an employee leaves:

1. The account is disabled.
2. Active access is removed.
3. The account is moved to the disabled-user OU.
4. The account can be retained for administrative or audit purposes according to the simulated organization's retention process.

## PowerShell Automation

The project includes a PowerShell provisioning script that processes HR-style CSV data and automates portions of the user onboarding process.

The script can:

* Import employee records from CSV
* Create Active Directory user accounts
* Place users into appropriate OUs
* Assign department-based groups
* Assign role-based groups
* Apply additional access requirements
* Support repeatable provisioning rather than manually creating each account

Example input:

```csv
FirstName,LastName,Department,Role,VPN,Payroll
John,Doe,Finance,Analyst,Yes,Yes
Jane,Smith,HR,Coordinator,No,No
```

The purpose of the automation is to demonstrate how structured HR data could be used to reduce repetitive identity provisioning tasks.

## Microsoft Entra ID Integration

The lab includes a hybrid identity configuration using Microsoft Entra Connect.

The environment was configured to:

* Synchronize a dedicated Active Directory OU with Microsoft Entra ID
* Use Password Hash Synchronization
* Configure Seamless SSO
* Validate synchronized identities
* Test authentication through Microsoft 365

This demonstrates the relationship between an on-premises Active Directory identity source and cloud identity services.

## Access Reviews

Access reviews are performed as part of the simulated IAM lifecycle.

The review process focuses on identifying:

* Users with inappropriate group memberships
* Access remaining after role changes
* Excessive permissions
* Access that is no longer required

The objective is to reduce privilege creep and maintain alignment between user responsibilities and assigned access.

## Skills Demonstrated

### Identity & Access Management

* Active Directory
* Microsoft Entra ID
* Identity lifecycle management
* RBAC
* Least privilege
* User provisioning
* User deprovisioning
* JML workflows
* Access reviews

### Automation

* PowerShell
* CSV processing
* User provisioning automation
* Group membership automation

### Infrastructure

* Windows Server
* Active Directory Domain Services
* Microsoft Entra Connect
* Password Hash Synchronization
* Seamless SSO

## What I Learned

This project helped me develop practical experience with the relationship between identity lifecycle processes, access control, and enterprise security.

A major focus was understanding that provisioning an account is only one part of IAM. Access must also be changed when users move roles and removed when users leave. Designing the lab around JML workflows helped demonstrate how identity processes can reduce excessive access and privilege creep. A core principle of security.

The project also gave me experience with automation and hybrid identity, particularly how PowerShell can reduce repetitive provisioning work and how on-premises Active Directory identities can be synchronized with Microsoft Entra ID. It also taught me some basic PowerShell and some of the cmdlets involved in automating things like this.

## Future Improvements

Potential future improvements include:

* Implementing more granular access-review automation
* Expanding privileged access management scenarios
* Adding additional enterprise applications
* Implementing MFA scenarios
* Building more detailed audit/evidence workflows
* Adding automated deprovisioning logic
* Expanding logging and monitoring of identity events
* Adding my own PKI infrastructure
* FIDO2 Passkeys

