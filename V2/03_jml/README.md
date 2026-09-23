# 03 — Joiner, Mover, Leaver

This phase defines how Aerotyne manages identity and access throughout an employee's lifecycle.

The objective is to establish a predictable lifecycle model before implementing automation. The model defines what should happen when an employee joins the organization, changes roles or departments, or leaves the organization.

Automation is intentionally deferred until the lifecycle rules have been designed and validated.

## Lifecycle Model

```text
                    Employee Lifecycle
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
           JOINER        MOVER        LEAVER
              │            │            │
              ▼            ▼            ▼
          Provision     Reconcile     Deprovision
           Access        Access         Access
              │            │            │
              └────────────┼────────────┘
                           ▼
                     Audit / Review
```

## Objectives

The JML model should ensure that:

* New employees receive the access required for their assigned role.
* Employees changing roles receive the new access required by their position.
* Access associated with the previous role is removed when it is no longer required.
* Departing employees lose access in accordance with the organization's termination policy.
* Privileged access receives additional controls where appropriate.
* Lifecycle actions are traceable and capable of being audited.
* Lifecycle changes can eventually be automated without changing the underlying authorization model.

## Lifecycle Authority

Each lifecycle event must have an authoritative source or approved trigger.

The lab will distinguish between:

* Identity source data
* Lifecycle event
* IAM action
* Resource authorization
* Validation and audit evidence

The initial lab will use a controlled administrative process to simulate authoritative lifecycle events.

A future implementation may use an HR system or another authoritative identity source to drive automated provisioning.

## Joiner

A Joiner is an individual entering the organization and requiring access.

The Joiner process must determine:

1. What identity information is required.
2. Which OU should contain the account.
3. Which business role the employee has.
4. Which role group should be assigned.
5. Which resource entitlements result from that role.
6. Which device or workstation relationships are required.
7. When the account should become usable.
8. What evidence should be recorded.

The desired outcome is an active identity whose access matches the employee's approved role.

## Mover

A Mover is an existing employee whose department, job role, or authorization requirements change.

The Mover process must be treated as an access reconciliation event rather than simply an additional group assignment.

For example:

```text
Sales Representative
        │
        │ promotion
        ▼
Sales Supervisor
```

The expected state is:

```text
Remove obsolete role
        ↓
Assign new role
        ↓
Recalculate resulting access
        ↓
Validate effective permissions
```

The process must prevent privilege accumulation caused by retaining obsolete role memberships.

## Leaver

A Leaver is an employee who no longer requires organizational access.

The Leaver process must determine:

* When access should be disabled.
* When the account should be disabled.
* How group memberships should be handled.
* How privileged memberships should be handled.
* How assigned devices should be handled.
* How organizational data should be preserved or transferred.
* How the identity should be retained for audit purposes.
* When eventual deletion is appropriate, if at all.

The lab will distinguish between disabling an identity and deleting an identity.

## Timing

Lifecycle actions will be classified as one of the following:

| Timing       | Meaning                                                        |
| ------------ | -------------------------------------------------------------- |
| Immediate    | Action should occur as soon as the lifecycle event is approved |
| Scheduled    | Action occurs at a defined date/time                           |
| Manual       | An administrator performs the action                           |
| Automated    | A future workflow or script performs the action                |
| Review-based | Action requires human validation before completion             |

The timing requirement is part of the lifecycle design and should not be assumed to be the same for every action.

## Lifecycle Invariants

The following rules must remain true regardless of how the lifecycle process is implemented:

1. A user's access must correspond to an approved business role.
2. A role change must remove access that is no longer required.
3. Users should not receive direct resource permissions when the established group model can provide the authorization.
4. Privileged access must not be inherited simply because a user belongs to a broad administrative group.
5. A disabled employee must not retain effective access through unrelated group membership.
6. Lifecycle automation must produce a predictable final identity state.
7. Failed or incomplete lifecycle operations must be detectable.
8. Lifecycle changes must be auditable.

These invariants define the expected behavior that Phase 4 automation will eventually enforce.

## Validation Strategy

Each lifecycle scenario will be validated by comparing the user's actual state against the expected state.

Validation should include:

* Account status
* OU placement
* Role group membership
* Entitlement group membership
* Resource access
* Privileged group membership
* Device association where applicable
* Audit evidence

Testing should include both successful scenarios and intentionally incorrect states.

## Phase Boundary

Phase 3 focuses on designing and validating the JML process.

PowerShell automation is intentionally excluded from this phase.

Phase 4 will translate the approved lifecycle model into repeatable automation.

## References

Microsoft Entra ID Governance uses the Joiner-Mover-Leaver model for lifecycle management and emphasizes defining the identity source, workflow scope, triggers, tasks, and validation before implementing lifecycle automation.

* Microsoft Entra ID Governance deployment guide
* Microsoft Entra Lifecycle Workflows documentation
