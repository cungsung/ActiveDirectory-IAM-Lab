# Sales Role Model

## Purpose

The Sales role model defines the business roles used to determine access for Sales employees.

Sales authorization follows the AGDLP model:

User → Global Role Group → Domain Local Entitlement Group → Resource Permission

Global groups represent the employee's business role. Domain Local groups represent the access entitlements associated with that role.

## Role Design Principles

### Role and Entitlement Separation

Business roles are represented by Global Security Groups.

Resource and application permissions are represented by Domain Local Security Groups.

Users should receive access through their assigned business role rather than through direct membership in entitlement groups.

### Shared Baseline Access

Sales Representatives and Sales Supervisors require the same baseline Sales access.

Both roles therefore receive:

* `DL-Salesforce-User`
* `DL-Sales-Data`

These entitlements represent normal Sales responsibilities and are not supervisory privileges.

### Supervisory Access

Sales Supervisors additionally receive:

* `DL-Salesforce-Management`

This entitlement provides management capabilities within Salesforce, including supervisory functions such as assigning work, moving agents, and modifying tickets.

`DL-Salesforce-Management` is exclusive to the Sales Supervisor role.

### Role Transition

A promotion from Sales Representative to Sales Supervisor is treated as a role change.

The employee's previous Global Role Group should be removed and the new Global Role Group should be assigned.

The resulting entitlement set is determined by the new role rather than by manually adding or removing individual entitlement groups.

---

## Sales Representative

**Business Purpose:**

Perform standard Sales responsibilities and interact with Salesforce and Sales data without supervisory management capabilities.

**Responsibilities:**

* Perform normal Sales activities.
* Work with assigned Salesforce records and tickets.
* Access information required for Sales operations.
* Perform tasks associated with the Sales Representative position.

**Required Access:**

* Standard Salesforce access.
* Sales data access.

**Prohibited Access:**

* Salesforce supervisory and management capabilities.
* Administrative functions reserved for Sales Supervisors.

**Global Role Group:**

`GG-Sales-Representatives`

**Entitlement Groups:**

* `DL-Salesforce-User`
* `DL-Sales-Data`

**Approval Authority:**

To be defined by the organization's access approval process.

**Lifecycle Behavior:**

New Sales Representatives receive `GG-Sales-Representatives`.

When promoted to Sales Supervisor, the Representative role is removed and replaced with `GG-Sales-Supervisors`.

---

## Sales Supervisor

**Business Purpose:**

Perform Sales responsibilities while exercising supervisory management capabilities within Salesforce.

**Responsibilities:**

* Perform standard Sales activities.
* Manage Sales work and assignments.
* Perform supervisory actions within Salesforce.
* Assign or move work between agents.
* Modify tickets and other records where supervisory authority is required.

**Required Access:**

* Standard Salesforce access.
* Sales data access.
* Salesforce supervisory management capabilities.

**Prohibited Access:**

* Access outside the Supervisor's defined business responsibilities.
* Administrative privileges not required for Sales supervision.

**Global Role Group:**

`GG-Sales-Supervisors`

**Entitlement Groups:**

* `DL-Salesforce-User`
* `DL-Sales-Data`
* `DL-Salesforce-Management`

**Approval Authority:**

To be defined by the organization's access approval process.

**Lifecycle Behavior:**

When an employee is promoted from Sales Representative to Sales Supervisor:

1. Remove `GG-Sales-Representatives`.
2. Add `GG-Sales-Supervisors`.
3. Verify that the resulting entitlement set contains the three Supervisor entitlements.
4. Verify that the employee no longer receives the Representative role directly.

---

## Role-to-Entitlement Matrix

| Business Role        | Salesforce User | Sales Data | Salesforce Management |
| -------------------- | --------------- | ---------- | --------------------- |
| Sales Representative | Yes             | Yes        | No                    |
| Sales Supervisor     | Yes             | Yes        | Yes                   |

## Authorization Invariants

The following conditions should remain true:

1. Every Sales Representative receives standard Salesforce access.
2. Every Sales Representative receives Sales data access.
3. Every Sales Supervisor receives standard Salesforce access.
4. Every Sales Supervisor receives Sales data access.
5. `DL-Salesforce-Management` is assigned only through the Sales Supervisor role.
6. A Sales Representative must not receive `DL-Salesforce-Management`.
7. A promotion from Representative to Supervisor must result in the Supervisor entitlement set.
8. A demotion from Supervisor to Representative must remove supervisory management access.

# Open Design Questions

## What authority approves a Sales Supervisor promotion?
### Decision:
 A Sales Supervisor promotion should be approved by HR or an existing Sales Supervisor/department leader.
When an existing Supervisor is available, the Supervisor should be able to identify and approve Representatives who are ready for promotion.
 If there is no current Supervisor, HR should handle the approval as part of the hiring or organizational process.
### Rationale:
The authority approving the role change should understand the employee's responsibilities and whether the employee is being formally assigned supervisory
responsibilities. IAM should enforce the approved organizational decision rather than independently determining whether an employee qualifies for the role.

  All role changes should require approval. Even if that approval just comes from the supervisor
 or leader of that department, there should be some documentation that proves there was formal
 agreement on a promotion or change in access. 
  
## Should role changes require an approval record before access changes occur?
### Decision:
 Yes. All role changes should require documented approval before the corresponding access change is performed.
The approval may come from the appropriate department Supervisor, department leader, or HR depending on the circumstances, 
but there should be a record demonstrating that the organization formally approved the role change.
### Rationale:
 Role changes can modify an employee's level of authority. Requiring an approval record establishes accountability and provides
 evidence that access was granted because of a legitimate business decision.

## How should a Supervisor demotion be handled?
### Decision:
 A Supervisor demotion should generate a documented change request and should be processed with expedited priority.
The employee's supervisory role should be removed as soon as the demotion becomes effective. GG-Sales-Supervisors
should be removed and the employee should receive the appropriate replacement role, such as GG-Sales-Representatives,
if they remain in a Sales Representative position.
The resulting access should be validated to ensure that DL-Salesforce-Management is no longer available.
### Rationale:
 A demotion removes previously authorized supervisory responsibilities. The associated elevated access should therefore 
be removed promptly rather than waiting for a normal access-change cycle.

## How should temporary supervisory assignments be represented, if they exist?
### Decision:
Temporary supervisory assignments should not automatically result in assignment to the permanent GG-Sales-Supervisors role.
A temporary assignment should require a documented change request identifying the temporary responsibilities and the access
 required to perform them. Only the necessary Domain Local entitlement groups should be granted for the duration of the assignment.
 The temporary access should have a defined expiration or removal process.
### Rationale:
A temporary assignment may require only a subset of the permissions associated with the permanent Supervisor role. Granting the complete Supervisor 
role could provide unnecessary access. Temporary access should therefore be scoped to the actual business requirement and should not become 
permanent through administrative oversight.
### Design consideration:

Direct membership in Domain Local entitlement groups creates an exception to the normal:

User → Global Role Group → Domain Local Entitlement Group

authorization model.

If this exception is permitted, it must be explicitly governed, documented, time-limited, and auditable

## How frequently should supervisory access be reviewed?
### Decision:
Supervisory access should be reviewed quarterly.
The review should verify that the employee's current responsibilities continue to justify the access assigned
to the Supervisor role and that unnecessary permissions have not accumulated.
### Rationale:
Supervisory access provides capabilities beyond standard Sales responsibilities. Periodic review provides an 
opportunity to identify access that is no longer justified by the employee's current duties.

  
## What evidence should be retained when a role changes?
### Decision
 An auditable record should be retained for each role assignment or role change.

The record should establish:

Who requested the change.
Who approved the change.
Which employee was affected.
Previous role.
New role.
Reason for the change.
Date and time of the change.
Access changes resulting from the role change.
Identity of the person or automation process that performed the change.

### Rationale:
Role changes affect authorization and therefore should be traceable.
Maintaining an audit trail allows the organization to reconstruct why access was granted, changed, or 
removed and provides evidence for troubleshooting, access reviews, and security investigations.
