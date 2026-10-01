# Reconciliation Plan and Comparison Model

## Purpose

The reconciliation engine compares the current Active Directory state of an employee against the calculated desired state derived from authoritative HR data and the approved IAM role model.

The comparison phase does not modify Active Directory.

Its purpose is to identify differences, determine which changes are required, assign an appropriate failure severity, and produce a reconciliation plan for the execution phase.

The design follows a desired-state model:

```text
Current State
      +
Desired State
      ↓
Comparison
      ↓
Reconciliation Plan
      ↓
Execution
      ↓
Validation
```

## Current State

Current state represents the values and authorization currently present in Active Directory and other automation-managed systems.

Examples include:

* Department
* Job Title
* Manager
* OU placement
* IAM role
* Global group membership
* Domain Local entitlement membership
* Remote access entitlements
* Account state

The current state is collected before any modifications are made.

## Desired State

Desired state is calculated from authoritative HR data and the approved IAM role model.

HR provides authoritative personnel attributes such as:

* Employee ID
* First Name
* Last Name
* Department
* Job Title
* Manager
* Start Date
* Employment Status
* Remote Access requirements

The IAM role is resolved from:

```text
Department + Job Title
        ↓
Approved Role Mapping
        ↓
IAM Role
        ↓
Global Groups
DL Entitlements
Remote Access Entitlements
```

The desired state must be deterministic.

A valid Department + Job Title combination must resolve to exactly one approved role.

Unrecognized or ambiguous role mappings are blocking preflight failures and must not result in guessed authorization.

## Comparison Rules

The comparison engine evaluates automation-managed properties individually.

If the current value equals the desired value, no mutation is required.

```text
Current = Desired
    ↓
NO_CHANGE
```

If the current value differs from the desired value, the engine creates a reconciliation operation.

```text
Current ≠ Desired
    ↓
Create Operation
```

For collection-based properties such as Global Groups, Domain Local groups, and Remote Access Entitlements, the engine compares the current managed collection against the desired managed collection.

The engine calculates the difference internally:

```text
Current Collection
        ↓
Compare
        ↑
Desired Collection
        ↓
ToAdd / ToRemove
```

The reconciliation operation remains expressed in terms of current state and desired state rather than individual hard-coded add/remove commands.

## Automation Ownership

The comparison engine only reconciles properties owned by the automation.

Automation-owned properties must converge exactly to their calculated desired state.

Automation-owned properties include:

* Department
* Job Title
* Manager
* Start Date
* Employment Status
* OU placement
* Account state
* IAM role
* Role Global Groups
* Role Domain Local Entitlements
* Remote Access Entitlements

Identity correlation properties are validation-only:

* Employee ID
* First Name
* Last Name
* Username

Unmanaged authorization and permissions are not modified.

These include:

* Unmanaged Global Groups
* Unmanaged Domain Local Groups
* Direct user permissions
* Unrelated or inherited ACL permissions

Unmanaged access is preserved and reported for human review.

## Reconciliation Operation Schema

Each planned operation contains:

```text
OperationID
EmployeeID
Phase
Operation
CurrentValue
DesiredValue
Severity
Result
Error
```

### OperationID

Unique identifier for the planned operation.

### EmployeeID

Immutable employee identifier used to correlate the operation with the employee.

### Phase

Logical lifecycle phase in which the operation belongs.

Examples:

```text
Identity State
Authorization State
Remote Access State
Account State
```

Phases describe dependency and risk boundaries rather than a rigid sequence of hard-coded commands.

### Operation

Describes the state being reconciled.

Examples:

```text
Update Department
Update Job Title
Assign Manager
Move OU
Reconcile IAM Role
Reconcile Global Groups
Reconcile DL Entitlements
Reconcile Remote Access
Change Account State
```

### CurrentValue

The state observed before reconciliation.

### DesiredValue

The state calculated by the desired-state engine.

### Severity

Defines the consequence of an operation failure.

Supported values:

```text
Blocking
NonBlocking
```

A Blocking failure stops reconciliation for that employee.

A NonBlocking failure is recorded as an exception but does not stop the remaining independent operations.

### Result

The execution status of the operation.

Supported values:

```text
PENDING
NO_CHANGE
SUCCESS
NEEDS_ATTENTION
SKIPPED
```

### Error

Contains the error information when an operation cannot successfully complete.

Errors must identify the failed operation and provide enough information for human investigation.

## Example — No Change

```text
EmployeeID: 12345
Operation: Update Department
CurrentValue: Sales
DesiredValue: Sales
Severity: Blocking
Result: NO_CHANGE
Error: None
```

No Active Directory modification is performed.

## Example — Successful Change

```text
EmployeeID: 12345
Operation: Update Job Title
CurrentValue: Sales Representative
DesiredValue: Sales Supervisor
Severity: Blocking
Result: SUCCESS
Error: None
```

The desired change is applied and subsequently validated.

## Example — Global Group Reconciliation

Current state:

```text
GG-Sales-Representatives
```

Desired state:

```text
GG-Sales-Supervisor
```

The reconciliation operation is:

```text
Operation: Reconcile Global Groups

CurrentValue:
    GG-Sales-Representatives

DesiredValue:
    GG-Sales-Supervisor

Severity:
    Blocking

Result:
    PENDING
```

Internally, the comparison engine determines:

```text
ToRemove:
    GG-Sales-Representatives

ToAdd:
    GG-Sales-Supervisor
```

The execution layer uses those calculated differences to reach the desired state.

## Example — Unmanaged Additional Access

Current state:

```text
GG-Sales-Supervisor
GG-Special-Project
```

Desired role-managed state:

```text
GG-Sales-Supervisor
```

The automation removes neither group automatically unless `GG-Special-Project` is within the automation's ownership boundary.

Instead:

```text
GG-Sales-Supervisor
    → Managed
    → Desired state satisfied

GG-Special-Project
    → Unmanaged
    → Preserved
    → Reported for review
```

This prevents the reconciliation engine from becoming an uncontrolled access-removal mechanism.

## Reconciliation Plan Generation

The comparison process follows this model:

```text
Collect Current State
        ↓
Calculate Desired State
        ↓
Compare Managed Properties
        ↓
No Difference?
   ┌────┴────┐
  Yes        No
   │          │
   ▼          ▼
NO_CHANGE   Create Operation
              ↓
        Assign Severity
              ↓
        Add to Plan
```

The complete plan must be generated before modifications begin.

This allows predictable input and configuration problems to be identified during preflight rather than discovered after partial changes have already occurred.

## Execution Boundary

The comparison engine does not modify Active Directory.

Its responsibility ends when it produces a valid reconciliation plan.

```text
Comparison
    ↓
Reconciliation Plan
    ↓
Preflight
    ↓
Apply Changes
```

The execution engine is responsible for applying the approved plan.

The validation engine is responsible for proving that the resulting state matches the desired state.

## Design Invariant

The reconciliation engine follows the following invariant:

> For every automation-owned property, successful reconciliation results in the current state exactly matching the calculated desired state.

Unmanaged state is preserved and reported rather than modified.

Identity validation failures and blocking preflight failures prevent reconciliation for the affected employee.

A failure affecting one employee must not terminate processing for other employees in the same batch.
