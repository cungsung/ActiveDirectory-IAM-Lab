# Automation Input Contract

## Purpose

The automation input contract defines the authoritative employee information consumed by IAM automation.

The input represents personnel, organizational, and approved access information. Automation uses this information to determine the desired identity and authorization state.

HR is the authoritative source for personnel lifecycle decisions. The automation does not independently determine whether an employee should be hired, transferred, promoted, or terminated.

## Input Fields

| Field                      | Type             | Required | Purpose                                                                 |
| -------------------------- | ---------------- | -------: | ----------------------------------------------------------------------- |
| Employee ID                | String           |      Yes | Immutable identifier used to correlate the HR record to the AD identity |
| First Name                 | String           |      Yes | Employee identity information                                           |
| Last Name                  | String           |      Yes | Employee identity information                                           |
| Username                   | String           |      Yes | Account identifier supplied by the authoritative input                  |
| Department                 | String           |      Yes | Organizational attribute used during role resolution and OU placement   |
| Job Title                  | String           |      Yes | HR job classification used during role resolution                       |
| Manager                    | String           |      Yes | Reporting relationship stored as an identity attribute                  |
| Start Date                 | Date             |      Yes | Determines lifecycle timing and account state                           |
| Employment Status          | Enumerated value |      Yes | Determines lifecycle state such as Active or Terminated                 |
| Remote Access Entitlements | Collection       |      Yes | Explicitly approved remote-access capabilities                          |

## Remote Access Entitlements

Remote access is modeled as an entitlement rather than as an inferred property of an employee's work arrangement.

Allowed values for the current lab:

* `None`
* `VPN`
* `ZTNA`

Multiple entitlements may be assigned to the same employee.

Examples:

```text
Remote Access Entitlements = [None]
Remote Access Entitlements = [VPN]
Remote Access Entitlements = [ZTNA]
Remote Access Entitlements = [VPN, ZTNA]
```

`None` represents an employee with no approved remote-access entitlement.

The automation must not infer remote-access authorization from Department, Job Title, or another unrelated attribute.

VPN and ZTNA are separate access mechanisms and may coexist when both are explicitly approved.

ZTNA is represented in the input contract before its implementation is introduced into the lab. Phase 4 may establish the data model while implementation of ZTNA is deferred to the hybrid/remote-access phase.

## Authority and Decision Boundaries

The automation consumes authoritative HR information and approved access requirements. It does not create business policy.

Department and Job Title are inputs to role resolution. They do not independently grant authorization.

The resulting relationship is:

```text
Department + Job Title
        ↓
Approved IAM Role
        ↓
Existing Global Security Group
        ↓
Existing Domain Local Entitlement Groups
        ↓
Effective Resource Access
```

Remote access is evaluated separately:

```text
Remote Access Entitlements
        ↓
Approved Remote-Access Configuration
        ↓
VPN / ZTNA Entitlement
```

## Group Creation Boundary

Automation must not create new security groups.

The current approved Global and Domain Local security groups are the only groups automation may use for the current authorization model.

If a required group does not exist, automation must report an error rather than create a replacement group.

Example:

```text
Required:
GG-Sales-Representatives

AD:
GG-Sales-Representatives does not exist

Result:
Failure
Reason: Required authorization group is missing
Action: Administrative remediation required
```

This prevents automation from silently changing the authorization architecture.

## Account Creation Boundary

Automation may create an account when no matching account exists and all required inputs successfully resolve.

If an account already exists, automation must not create a second account.

If an existing account is found:

```text
Account exists and is expected:
    Report existing/duplicate account condition
    Do not create another account

Account exists but is incorrect:
    Report exception
    Do not automatically modify the account
    Require manual investigation/remediation through ADUC
```

The current lab intentionally uses controlled provisioning rather than automatically correcting every existing AD account.

## Validation Requirements

Before an account is considered successfully provisioned, automation must validate the resulting state.

Validation must include, where applicable:

* Identity attributes match the authoritative input.
* User is located in the expected Accounts child OU.
* Approved Global Security Group membership is correct.
* Required Domain Local entitlements are present through the approved group structure.
* No unauthorized role group was added by the automation.
* Remote-access entitlements match the approved input.
* Account state corresponds to Employment Status and Start Date.
* No duplicate account was created.

Successful execution of an individual PowerShell command does not constitute successful lifecycle execution.

## Failure Reporting

Automation must produce a per-user result.

Example:

```text
Provisioning Run
----------------
Success:
- John Doe
- Jane Doe

Failure:
- Michael Brown — Job Title could not resolve to an approved IAM role
- Robert Jones — Existing account detected; manual review required
```

The report should distinguish between successful operations and exceptions requiring human intervention.

## Design Principle

The input contract describes the desired business and access state. Automation is responsible for translating that state into controlled AD changes, validating the resulting state, and producing audit evidence.

Automation should not invent roles, groups, entitlements, or authorization decisions that are not represented by the approved design.
