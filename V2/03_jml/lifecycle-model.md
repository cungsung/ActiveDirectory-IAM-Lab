# JML Lifecycle Model

## Purpose

This document defines the expected identity and authorization state of an employee throughout the Joiner-Mover-Leaver lifecycle.

The purpose of the model is to establish the rules that future automation must enforce.

---

# 1. Identity Source and Authority

## Source of Truth

**Decision: HR **

### Where does a new employee originate?
New employees should originate from HR databases following a new hire process. 

###  Who is authorized to declare an employee active?
HR and supervisors/authoritative figures for each department are allowed to decide who is active and who is not.
Following a resignation or demotion, the role change should be immediate within the department. HR data should mirror departmental
data after proper paperwork has been documented for changes in role. The opposite is true as well, department data should mirror 
HR data if there is an internal affair the results in termination or demotion. Both departmental data and HR data will converge
when formal documentation is created. In the sense of actual productivity, that should be decided by supervisors and leaders.

### Who is authorized to declare a role change?
Role changes can be declared by HR or an authority within the department. What I mean by that is, a supervisor or
leader in the department can initiate or reccomend the promotion, demotion, or termination of an individual.
The actual authoritative power comes from HR. They are the only department that can approve and initiate the change
process.

### Who is authorized to declare a termination?
Supervisory authorities are allowed to declare a termination. This includes resignation scenarios. But only when the
formal documentation is completed.

### What information is considered authoritative?
Authoritative information can be sourced directly from HR. Although supervisors can declare resignation, termination,
promotions, only HR can cement those decisions through a formal change request for personnel. HR is also the source of 
new hire data meant for the joiner process. Also the source of leaver data as a result of termination, resignation, etc.

## Lifecycle Events
### New Hire
The creation and assignment of permissions in relation to an employees scope of work.
### Promotion
During a promotion, the employee's current Global Role Group and the permissions derived from that role must first be removed. 
A privilege attestation is then performed to verify that the previous role no longer provides effective authorization and that
no unintended authorization paths remain.

Once the previous authorization state has been successfully reconciled, the employee is added to the corresponding Global 
Role Group for their new position. The resulting permissions are inherited through the established RBAC model. 
A permission attestation is then performed to verify that the employee's effective authorization matches the approved new role
and that the previous role's privileges have not been retained.

Completion of the permission attestation marks the end of the promotion lifecycle event.

### Demotion
An employee's current role must be removed as well as all permissions granted through their current security group. This should
be attested to and then the user can be moved to the security group where their new role lies. Their privilege will be attested to 
once more to make sure all permissions are coming from the places their supposed to.
### Department Transfer
Similarly, to a promotion, the default process follows documentation from HR with the proper authoritative figure approval received
from department leaders, then a user is removed from all old responsibilities and privilege attestation is completed. Then, the user is added
to the new security group as applies to new position where privilege attestation is completed again after being moved to the new security group.
### Termination
This occurs when the documentation is received from HR where the account can then be disabled and removed from all responsibilities/groups,
privilege attestation occurs. The user is then moved to an OU where it will sit for forensic and auditing purposes
for a period of time.


###  IAM Responsibility
IAM is the framework that is responsible for the identity lifecycle as well as managing these identities as well as AuthZ. 
All authoritative data comes from HR, where the permissions and responsibilities are managed through IAM. IAM itself is not
responsible for any decision making on whether or not an employee is hired nor fired. Just the framework that organizes these identities.
---

# 2. Joiner

## Trigger
The joiner process is triggered when HR sends out any sort of data that confirms a new employee, as well as their attributes and role.
This could be a .csv file with names along with documentation in an email with more information. It could also just be the name of a singular
person being added to the company rather than a batch. Information that lists sufficient attributes to start identity creation and access management
functions as authoritative data as long as it comes from HR. No other department can send this data for the provisioning of new users.

## Required Identity Attributes

```text
Employee ID
First Name
Last Name
Department
Job Title
Manager
Start Date
```

## Initial Identity State

### Account enabled or disabled before start date
Users can be provisioned before their start date, but the account created must not be enabled until the day given for "Start Date".  
### OU placement
  Users should be put in the department OU as listed in whatever data is listed for "Job Title" and "Department". 
  This allows users to be placed in the departmental OU that is determined by the job role the employee has.
### Username convention
My original idea for username convention was something like: John Smith---> Jsmith
I realized that any users with similar first letter and last name would be confusing to look at. I now opt for a simple : john.smith convention.
That should reduce the confusion to admins by eliminating the ambiguous first letter. This way a collision between users with the same first and last
name as far less likely than one to occur with users that have the same last name, different first name. This eliminates the need to have
jsmith and jsmith2 if jsmith2 is jane smith and not john smith. I'd be much more willing to add unique identifiers for collisions between
employees with exact same first and last name. Perhaps a number following "first.last".
### Department
Users should be placed in the department as listed in the data HR that lists the attributes of new users. Their department and job title should be included
in the data received.
### Job title
Job title should be listed in data HR sends out. Should match the department listed in the data as well. 
### Manager
New users should have their assigned manager listed in identity properties for provisioning to give administrators or identity specialists a point of contact
to reach out to supervisors or managers regarding users. 
### Employee status
Employee status should be set to active as long as the user is an active employee. The only reason for an employee to be set to inactive would be because of 
inherent termination or resignation from the company.
### Device assignment
Users should be assigned a device in the matching department OU in the higher level "Devices" OU. This OU was specifically created to place devices like laptops,
switches, IoT devices, etc. 
## Initial Role Assignment
Before any role is assigned to a new employee, the data such as, department, job title, first and last name, amongst the other required identifiers should be 
given via the HR department. Then, the identity specialist or system administrator can use the provided data to add new employees to their role.
These roles are separated departmentally as discussed in my identity infrastructure documentation. All attributed need to be provided and their 
position will already have a corresponding security group, meaning all permissions are already predetermined by the scope of each role in Aerotyne.

If a new employee was to be added as a Sales Representative, the data HR provides must include all identifiers.


## Initial Access
## Initial Access

Initial access is determined by the employee's approved business role and the access requirements associated with that role. Additional access requirements, such as VPN access,
are determined separately based on the employee's approved work arrangement.

The department determines whether a position requires remote network access and requests that HR record the employee's work arrangement as `Remote`, `Hybrid`, or `On-Site` 
during the hiring process. This attribute becomes part of the authoritative HR record and allows administrators to distinguish between employees who require VPN access 
and those who do not.

VPN access is represented by a separate Domain Local security group and is not automatically included in an employee's baseline role permissions. 
Employees whose approved work arrangement requires VPN access are assigned to the corresponding Domain Local group.

If an employee's work arrangement changes after onboarding, the department must submit a change request and receive HR approval before the employee's HR record is updated. 
IAM administrators then use the updated authoritative record to assign or remove the employee's VPN entitlement.

## Joiner Validation

A successful Joiner results in an identity that matches the authoritative HR record and has only the access authorized for the employee's approved role and additional requirements.

The expected final state is:

```text
Identity State:
Employee ID = Matches HR
First Name = Matches HR
Last Name = Matches HR
Department = Matches HR
Job Title = Matches HR
Manager = Matches HR
Start Date = Matches HR
Employment Status = Active
Work Arrangement = Matches HR

Account State:
Account exists
Account is enabled only when Start Date has been reached
Account is placed in the appropriate departmental OU
Username follows the approved naming convention

Access State:
Exactly one approved permanent Global Role Group
Corresponding Domain Local entitlement groups
No obsolete role memberships
No unauthorized direct permissions
VPN entitlement matches the approved work arrangement

Device State:
Device assignment/placement matches the organization's device assignment policy

Expected Validation:
HR attributes match the resulting identity attributes
The employee has the correct Global Role Group
Expected Domain Local groups are present
Unexpected role or entitlement memberships are absent
VPN access matches the approved work arrangement
The account state matches the employee's start-date status
Effective resource access corresponds to the approved role
No unintended direct or inherited authorization is present
Validation results are recorded as audit evidence
```

If the HR-provided job title or position does not map to an approved IAM role, the Joiner must not automatically assign access. The identity may be provisioned into a pending state, but authorization requiring a role assignment must wait until the employee's responsibilities are reviewed and an appropriate IAM role is formally established.

The Joiner process may then restart using the newly approved role.

---

# 3. Mover

## Trigger

A Mover event occurs when an authoritative HR change alters an employee's identity attributes or approved responsibilities in a way that may affect their authorization.

Examples include:

```text
Department Change
Job Title Change
Manager Change
Role Change
Work Arrangement Change
```

Not every attribute change requires an authorization recalculation.

A change to an employee's name or other non-authorization attribute does not by itself require a role change.

A change to department, job responsibilities, approved role, or work arrangement may require access reconciliation.

Manager changes require additional consideration. A manager change should update the employee's identity attributes, but should only cause an authorization change if the organization's approved role model makes managerial responsibility an authorization-bearing attribute.

A work-arrangement change requires reconciliation of VPN access.

The Mover process must determine whether the change affects:

```text
Identity State
Role State
Entitlement State
Account State
```

and reconcile only the states affected by the authoritative change.

## Core Rule

The Mover process must reconcile the employee to the new authorized state.

It must not simply add new access to the existing access state.

For permanent role changes, the previous permanent Global Role Group must be removed before the new permanent Global Role Group is assigned.

The standard transition is:

```text
Approved Change
      ↓
Remove Previous Role
      ↓
Privilege Attestation
      ↓
Assign New Role
      ↓
Permission Attestation
      ↓
Mover Complete
```

This deliberately creates a temporary availability gap rather than allowing old and new permanent roles to overlap.

The design prevents:

```text
Old Role
    +
New Role
    =
Privilege Accumulation
```

The expected authorization model is:

```text
One Approved Permanent Role
        ↓
Corresponding Entitlements
        ↓
Expected Resource Access
```

Additional entitlements, such as VPN access, are evaluated separately according to their approved requirements.

## Example: Sales Representative → Sales Supervisor

### Before

```text
Identity State:
Department = Sales
Role = Sales Representative
Status = Active

Access State:
GG-Sales-Representatives
DL-Salesforce-User
DL-Sales-Data
```

### Transition

The promotion must be authorized through the established HR process before access changes occur.

The previous Global Role Group is removed first.

```text
Remove:
GG-Sales-Representatives
```

Privilege attestation then verifies that the employee no longer receives authorization through the previous role.

The new Global Role Group is then assigned:

```text
GG-Sales-Supervisors
```

The resulting authorization is evaluated through the existing RBAC structure.

### Expected Final State

```text
Identity State:
Department = Sales
Role = Sales Supervisor
Status = Active

Access State:
GG-Sales-Supervisors
DL-Salesforce-User
DL-Sales-Data
DL-Salesforce-Management

Account State:
Enabled
```

The employee must no longer have:

```text
GG-Sales-Representatives
```

and must not retain obsolete permissions resulting from the previous role.

The final validation must verify both that the new management access exists and that the previous representative role no longer contributes to effective authorization.

## Example: Sales Supervisor → Sales Representative

The same remove-first process applies to a demotion.

The previous role is removed:

```text
Remove:
GG-Sales-Supervisors
```

Privilege attestation verifies removal of the previous role and its associated authorization.

The new role is then assigned:

```text
GG-Sales-Representatives
```

### Expected Final State

```text
Identity State:
Department = Sales
Role = Sales Representative
Status = Active

Access State:
GG-Sales-Representatives
DL-Salesforce-User
DL-Sales-Data

Account State:
Enabled
```

The employee must not retain:

```text
GG-Sales-Supervisors
DL-Salesforce-Management
```

The final permission attestation verifies that the employee's effective authorization corresponds to the Sales Representative role.

## Department Transfer

A department transfer is treated as a Mover event because the employee's responsibilities and authorization scope may change.

Example:

```text
Sales Representative
        ↓
Finance Analyst
```

The HR-authorized department and role change must be processed before the new authorization state is established.

The previous Sales role is removed first:

```text
Remove:
GG-Sales-Representatives
```

Privilege attestation verifies that Sales authorization has been removed.

The employee's identity attributes are then updated:

```text
Department = Finance
Job Title = Finance Analyst
Manager = New Manager
```

The corresponding Finance Global Role Group is then assigned.

The final state must contain only the approved Finance role and its corresponding entitlements.

Sales-specific authorization must no longer be effective.

If the new position does not have an approved IAM role, the new authorization must not be guessed or created ad hoc. The employee enters the same role-analysis process used for an unmapped Joiner position.

The department transfer is not considered complete until:

```text
Old Department Access Removed
+
New Department Access Assigned
+
Expected Effective Access Verified
```

Incomplete processing must be detectable through lifecycle validation.

## Mover Approval

A Mover event must be based on an authoritative HR-approved change.

The change record must identify, at minimum:

```text
Employee
Current Department
Current Role
New Department, if applicable
New Job Title
New Role, if applicable
Effective Date
Manager, if changed
Work Arrangement, if changed
Business justification or supporting documentation
Required approval
```

The department provides the business requirement and supporting information where applicable.

HR remains the authoritative source for the resulting personnel change.

IAM does not determine whether an employee should be promoted, demoted, transferred, or otherwise changed. IAM enforces the authorization consequences of the approved change.

## Mover Validation

A successful Mover must verify both:

```text
New Access Present
```

and:

```text
Obsolete Access Removed
```

Validation must compare the employee's actual state against the expected state.

The validation should examine:

```text
Identity Attributes
Global Role Group Membership
Domain Local Group Membership
VPN Entitlement
Account State
Effective Resource Access
Direct Permissions
Unexpected Nested/Inferred Authorization
```

A successful operation is not proven merely because the commands used to perform the Mover completed successfully. The resulting identity and authorization state is the evidence of success.

---

# 4. Leaver

## Trigger

A Leaver event begins when HR formally records an employee's termination or resignation as an authoritative personnel event.

The department may initiate or communicate the personnel change, but IAM must rely on the authoritative HR record before executing the corresponding lifecycle action.

Both termination and resignation enter the Leaver process.

```text
Termination / Resignation
        ↓
Authoritative HR Record
        ↓
IAM Leaver Process
```

## Timing

The Leaver process must prioritize removal of the employee's ability to authenticate.

The general sequence is:

```text
Authoritative Leaver Event
        ↓
Disable Account
        ↓
Remove Authorization
        ↓
Remove Privileged Access
        ↓
Validate Effective Authorization
        ↓
Move to Disabled Users
        ↓
Handle Devices/Data According to Policy
        ↓
Retain Audit Evidence
```

Account disablement is the initial containment action.

Authorization cleanup and archival actions occur after authentication has been disabled.

Exact timing requirements for individual actions remain a design decision for the lab and should be defined before automation is implemented.

## Account State

The expected final account state for a terminated or resigned employee is:

```text
Account:
Disabled

Employment Status:
Terminated

OU:
Disabled Users
```

The employee must not retain an enabled account.

The account's Global Role Group memberships and authorization-bearing memberships must be reconciled separately from account disablement.

The account must not retain privileged administrative access.

Device handling remains subject to the organization's device-return and reassignment process.

## Authorization State

The Leaver process must remove the employee's permanent business role and authorization-bearing group memberships.

The intended final authorization state is:

```text
No Permanent Business Role
No Role-Based Entitlement Access
No VPN Entitlement
No Privileged Access
No Unauthorized Direct Permissions
```

Account disablement is not considered sufficient evidence of authorization cleanup.

The final state must be validated against effective authorization.

## Data and Devices

Termination of an identity does not automatically determine what happens to organizational data.

The following must be handled according to separate organizational policies:

```text
User Data
Department Data
Assigned Workstation
Other Assigned Devices
Application Ownership
Administrative Accounts
```

Technical deprovisioning must be separated from organizational decisions regarding data retention, transfer, legal holds, and device disposition.

For the lab, the exact data-retention and device-return policies remain `TBD`.

## Disabled Users

After the account has been disabled and the required authorization cleanup has been performed and validated, the user account is moved to:

```text
Disabled Users
```

The Disabled Users OU serves as an administrative location for disabled identities retained for auditing, investigation, or organizational retention requirements.

The account must not be moved to the Disabled Users OU as a substitute for disabling the account.

**Retention:** 90 days after the effective termination date.

## Deletion

Disabling and deleting an identity are separate lifecycle actions.

The lab does not currently establish a final deletion policy.

Before implementing deletion, the following must be defined:

```text
Retention Period
Deletion Conditions
Deletion Authority
Required Audit Evidence
Data-Retention Requirements
Legal/Hold Requirements
```
### Deletion authority: designated IAM/IT administrator approval, with HR confirming that the employee's separation is final and no retention/legal requirement prevents deletion.

### Deletion executor: IAM automation or administrator, after approval.

### Audit evidence: employee ID, termination date, retention expiration date, approval, executor, deletion timestamp, and validation result.

Until those requirements are defined, terminated identities should remain disabled rather than being automatically deleted.

## Leaver Validation

A successful Leaver must verify more than:

```text
Account.Enabled = False
```

The expected final state is:

```text
Identity State:
Employment Status = Terminated
Required identity attributes retained for audit purposes

Account State:
Disabled
Located in Disabled Users

Access State:
No permanent business role
No obsolete role authorization
No VPN entitlement
No privileged access
No unauthorized direct permissions

Validation:
Authentication is disabled
Role memberships are reconciled
Entitlement memberships are reconciled
Privileged access is removed
Effective authorization has been evaluated
Audit evidence has been recorded
```

If authorization cleanup fails after account disablement, the employee remains contained from authentication but the lifecycle operation is still considered incomplete and must enter failure handling.

If account disablement itself fails, the Leaver operation is considered a high-priority containment failure requiring immediate remediation.

---

# 5. Failure Handling

Lifecycle operations must be treated as state transitions rather than a sequence of commands.

A lifecycle operation is successful only when the resulting state matches the expected state.

## Failed Mover

Example:

```text
New Role Added
Old Role Still Present
```

This represents an incomplete Mover and potential privilege accumulation.

The failure must be detected by comparing actual role and entitlement membership against the expected state.

The default response is fail-closed authorization reconciliation rather than automatic rollback.

The affected identity should be contained by removing unintended role and entitlement authorization while preserving the identity itself.

The previous role should not automatically be restored because restoring the previous authorization may be inappropriate, particularly during a demotion or other sensitive personnel change.

The remediation process is:

```text
Detect Failure
      ↓
Contain Authorization
      ↓
Reconcile Role/Entitlements
      ↓
Verify Unintended Access Is Removed
      ↓
Investigate Root Cause
      ↓
Apply Minimum Approved Temporary Access, If Required
      ↓
Permission Attestation
      ↓
Close Exception
```

If temporary access is required during remediation, it must be explicitly approved and limited to the minimum necessary access.

A test identity should be used to reproduce the failure where practical.

The investigation should determine whether the unexpected access resulted from:

```text
Direct Group Membership
Nested Group Membership
Inherited Group Membership
ACL Configuration
Incomplete Lifecycle Processing
Manual Administrative Change
```

Deletion Rule:
Termination disables and deprovisions the identity but does not immediately delete it.
Deletion occurs only after the defined retention period and required approval.

VPN Exception Rule:
Remote and Hybrid employees receive VPN access according to the standard rule.
On-Site employees do not receive VPN access by default.
An approved, documented, time-bound exception may grant VPN access without changing the employee's authoritative work arrangement.
...
```

The expected-state model will become the basis for Phase 4 automation and Phase 3 test cases.
