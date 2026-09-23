# Joiner-Mover-Leaver (JML)

## Purpose

This phase defines how employee identities and their access should change throughout the employment lifecycle.

The objective is to establish a predictable lifecycle model before implementing PowerShell automation. The automation developed in the following phase should enforce the decisions and rules established here rather than define them.

The JML model covers three primary lifecycle events:

* Joiner — creation and initial provisioning of an employee identity.
* Mover — modification of an employee's identity and access when their department, role, or responsibilities change.
* Leaver — removal or deactivation of access when employment ends.

The lifecycle model is based on the RBAC architecture established in Phase 2:

```text
User → Global Role Group → Domain Local Entitlement Group → Resource Permission
```

JML therefore operates primarily on the employee's identity state and business role. Resulting access should be determined by the established RBAC model rather than by manually assigning individual resource permissions.

---

## Lifecycle Model

The lifecycle process separates an employee's **identity state** from their **access state**.

### Identity State

Identity state describes the employee's organizational and account information.

Examples include:

* Account status
* Department
* Job title
* Manager
* Organizational Unit
* Employment status
* Employee ID
* Device association

### Access State

Access state describes the authorization resulting from the employee's business role.

Examples include:

* Global Role Group membership
* Domain Local Entitlement Group membership
* Resource access
* Application access
* Privileged access

For example:

```text
Identity State:
Enabled
Department = Sales
Job Title = Sales Representative
Employment Status = Active

Access State:
GG-Sales-Representatives
DL-Salesforce-User
DL-Sales-Data
```

A lifecycle event may therefore change both identity state and access state.

A role change should not be treated as simply adding another group. The resulting access state must correspond to the employee's new role.

---

# Joiner

## Objective

A Joiner event occurs when a new employee enters the organization and requires an identity and initial access.

The Joiner process should establish the employee's identity state first and then assign the appropriate business role.

### Initial Identity

The employee record should contain sufficient information to establish:

* Employee identity
* Employee ID
* Department
* Job title
* Manager
* Employment status
* Organizational Unit
* Account state
* Assigned device, where applicable

The employee should be placed into the appropriate Accounts OU based on their department.

For example:

```text
Department: Sales
OU: Accounts/Sales
```

### Initial Role

The employee's job responsibilities determine the appropriate Global Role Group.

For a Sales Representative:

```text
GG-Sales-Representatives
```

The role group then establishes the appropriate entitlements:

```text
GG-Sales-Representatives
    ↓
DL-Salesforce-User
DL-Sales-Data
```

The Joiner process should not directly assign NTFS or application permissions to the user when those permissions can be represented through the existing group architecture.

### Joiner Validation

After provisioning, the resulting state should be validated.

At minimum, validation should confirm:

1. The employee account exists.
2. The account is in the correct OU.
3. Required identity attributes are present.
4. The account is in the correct employment state.
5. The correct Global Role Group is assigned.
6. The expected Domain Local Entitlement Groups are effective.
7. Required resource access is available.
8. Unauthorized role-specific access is not available.
9. The provisioning event has appropriate evidence.

---

# Mover

## Objective

A Mover event occurs when an employee's organizational role or responsibilities change while they remain employed.

The Mover process is an **access reconciliation process**, not simply an access addition process.

The employee's previous role must be replaced by the new role where the roles are mutually exclusive.

This directly follows the RBAC decision established in Phase 2:

> Role changes should remove the old role's entitlements and establish the new role's entitlements.

### Example: Sales Representative → Sales Supervisor

Before the role change:

```text
GG-Sales-Representatives
    ↓
DL-Salesforce-User
DL-Sales-Data
```

After the role change:

```text
GG-Sales-Supervisors
    ↓
DL-Salesforce-User
DL-Sales-Data
DL-Salesforce-Management
```

The previous Global Role Group should be removed:

```text
Remove:
GG-Sales-Representatives

Add:
GG-Sales-Supervisors
```

The employee should not permanently retain both Sales role groups.

### Resulting Access

The resulting access should be derived from the new role.

For the Sales Supervisor role:

| Entitlement              | Expected |
| ------------------------ | -------- |
| DL-Salesforce-User       | Yes      |
| DL-Sales-Data            | Yes      |
| DL-Salesforce-Management | Yes      |

The purpose of this model is to avoid privilege accumulation. A user should not retain access simply because that access was granted under a previous role.

### Example: Sales Supervisor → Sales Representative

The reverse transition follows the same principle.

```text
Remove:
GG-Sales-Supervisors

Add:
GG-Sales-Representatives
```

The resulting entitlement set should be:

```text
DL-Salesforce-User
DL-Sales-Data
```

`DL-Salesforce-Management` should no longer be available through the employee's permanent role.

### Mover Approval

Role changes require documented approval before the corresponding access change is performed.

The appropriate approving authority may depend on the organizational situation, but the IAM process should enforce the approved organizational decision rather than independently determine whether an employee qualifies for a role.

The change record should establish:

* Who requested the change
* Who approved the change
* Employee affected
* Previous role
* New role
* Reason for the change
* Effective date and time
* Resulting access changes
* Identity of the person or process that performed the change

### Mover Validation

A successful Mover process should validate both the new state and the removal of the previous state.

Validation should confirm:

1. The employee's identity attributes reflect the new organizational state.
2. The previous Global Role Group has been removed.
3. The new Global Role Group has been assigned.
4. The expected Domain Local Entitlement Groups are effective.
5. Entitlements belonging exclusively to the previous role are no longer effective.
6. Resource access corresponds to the new role.
7. No unintended direct permissions were introduced.
8. The role change has an auditable record.

---

# Leaver

## Objective

A Leaver event occurs when an employee's employment ends and their access must no longer remain available.

The primary objective is to prevent the former employee from retaining effective access after their employment has ended.

### Account State

The employee account should be disabled as part of the termination process.

Disabling the account is an important control, but it should not be considered the only Leaver action.

The process must also account for the employee's existing authorization state.

### Access State

The Leaver process should identify and address:

* Global Role Groups
* Domain Local Entitlement Groups
* Privileged group memberships
* Application access
* Resource access
* Administrative accounts
* Device associations
* Other authentication or authorization mechanisms

The final state should not depend solely on the account being disabled.

For example, a user who has been terminated should not retain privileged group membership merely because the account has been disabled.

### Disabled Users OU

After the appropriate deprovisioning actions have occurred, the employee account may be moved to:

```text
Disabled Users
```

The OU provides an administrative location for disabled accounts and helps distinguish inactive identities from active employees.

Moving an account to the Disabled Users OU should not be treated as the mechanism that disables access. Account state and authorization state must still be validated independently.

### Data and Devices

Termination also requires consideration of organizational data and assigned devices.

The lifecycle process should establish how the organization handles:

* Files owned or used by the employee
* Department data
* Device recovery
* Device reassignment
* Application sessions
* Service credentials
* Administrative accounts
* Data retention requirements

The exact retention and deletion rules are intentionally separated from the initial AD RBAC implementation and will be refined as the lab expands.

### Leaver Validation

A successful Leaver process should validate:

1. The employee account is disabled.
2. Active employee role membership has been removed or otherwise rendered ineffective.
3. Privileged memberships have been addressed.
4. Application access is no longer effective.
5. Resource access is no longer effective.
6. Assigned devices have been accounted for.
7. Administrative accounts have been addressed.
8. The identity has been moved to the appropriate inactive state where applicable.
9. The termination event has an auditable record.

---

# Lifecycle Authority

A lifecycle process requires an authoritative source for determining that a lifecycle event has actually occurred.

The lab distinguishes between:

```text
Identity Source
        ↓
Lifecycle Event
        ↓
IAM Action
        ↓
Authorization State
        ↓
Validation / Audit Evidence
```

The identity source contains the organizational information used to determine the employee's intended state.

Examples include:

* Employee identity
* Department
* Job title
* Manager
* Employment status

The lifecycle event represents the organizational change.

Examples:

```text
New Hire
Promotion
Demotion
Department Transfer
Termination
```

The IAM action implements the corresponding identity and access change.

For the initial lab, lifecycle events will be simulated through a controlled administrative process rather than through a production HR system.

This allows the JML model to be designed and validated before introducing an external authoritative system.

A future implementation could use an HR system as the source of authoritative employee lifecycle information.

---

# Lifecycle Timing

Not every lifecycle action necessarily occurs on the same schedule.

The lifecycle model distinguishes between:

### Immediate

Actions that should occur as soon as the lifecycle event becomes effective.

Examples:

* Account disablement following termination
* Removal of elevated access following a demotion
* Removal of obsolete role membership following a role change

### Scheduled

Actions that can occur through a defined scheduled process.

Examples:

* Periodic reconciliation
* Access review
* Cleanup of inactive identities
* Validation jobs

### Manual

Actions that require an administrator or authorized operator.

Examples:

* Initial approval
* Exceptional access handling
* Data ownership decisions
* Device recovery procedures

### Automated

Actions that will eventually be performed by the Phase 4 automation system.

The initial implementation should not automate a lifecycle decision until the expected state and validation criteria have been established.

---

# Lifecycle Invariants

The following conditions should remain true throughout the IAM environment.

1. An employee's access corresponds to their current approved business role.

2. A permanent role change replaces the previous permanent role rather than accumulating additional roles.

3. Role changes remove access that is no longer justified by the employee's responsibilities.

4. Users receive standard access through the established RBAC group architecture rather than direct resource permissions.

5. Domain Local Entitlement Groups represent specific access capabilities.

6. `DL-Salesforce-Management` is only available to employees with an authorized supervisory requirement.

7. Temporary elevated access does not require permanent membership in a higher-privilege business role.

8. Temporary elevated access has a defined activation period and automatic expiration.

9. A terminated employee must not retain effective access through unrelated group memberships or authorization paths.

10. Account disablement and authorization state should both be considered during termination.

11. Privileged access must be explicitly addressed during lifecycle changes.

12. Lifecycle operations must produce a predictable final state.

13. Incomplete lifecycle operations must be detectable.

14. Lifecycle changes must be traceable to an approved business event.

15. Validation must evaluate effective access rather than relying solely on group membership.

16. Inherited permissions must be considered when validating resource authorization.

---

# Lifecycle Validation

JML validation should compare the employee's **actual state** against the **expected state** defined by the lifecycle event.

The validation process should examine both identity and authorization.

```text
Expected State
      ↓
Lifecycle Operation
      ↓
Actual State
      ↓
Compare
      ↓
Pass / Failure
```

For example, a Sales Representative promoted to Sales Supervisor should not be considered successful merely because `GG-Sales-Supervisors` was added.

The validation must also confirm that:

```text
GG-Sales-Representatives
```

was removed and that the resulting effective access corresponds to:

```text
DL-Salesforce-User
DL-Sales-Data
DL-Salesforce-Management
```

This is important because IAM failures can occur when one part of a lifecycle operation succeeds while another part fails.

---

# Failure Conditions

The JML model must account for incomplete operations.

Examples include:

### Failed Mover

```text
New Role Added
        ↓
Old Role Not Removed
```

The employee could then retain access from both roles.

This violates the role transition model and creates unnecessary privilege accumulation.

### Failed Leaver

```text
Account Disabled
        ↓
Privileged Membership Still Present
```

The account may currently be unable to authenticate, but the identity remains incorrectly configured and could present a security problem if the account is later re-enabled or if another authorization path exists.

The eventual automation should therefore detect and report incomplete lifecycle states rather than assuming that every operation succeeded.

---

# Phase 3 Scope

This phase establishes the JML design and validation model.

It does not implement PowerShell automation.

The current scope is:

* Define Joiner behavior.
* Define Mover behavior.
* Define Leaver behavior.
* Establish lifecycle authority.
* Establish lifecycle timing.
* Establish lifecycle invariants.
* Define expected identity and access states.
* Define validation requirements.
* Define failure conditions.
* Establish the design that Phase 4 automation will enforce.

PowerShell automation will be introduced only after the lifecycle model has been designed and validated.

---

# Relationship to Previous Phases

Phase 1 established the identity architecture:

```text
Domain
OU Structure
Administrative Model
```

Phase 2 established the authorization architecture:

```text
Business Role
      ↓
Global Role Group
      ↓
Domain Local Entitlement Group
      ↓
Resource Permission
```

Phase 3 establishes how identities move through their employment lifecycle while preserving those architectural rules:

```text
Joiner
  ↓
Mover
  ↓
Leaver
```

Phase 4 will automate these lifecycle operations.

The automation should enforce the model established in Phases 1–3 rather than introduce new authorization decisions during execution.
