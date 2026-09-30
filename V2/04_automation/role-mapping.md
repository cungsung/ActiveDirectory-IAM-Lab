# Role Mapping

## Purpose

Role mapping translates authoritative HR organizational attributes into an approved Aerotyne IAM role.

The mapping process uses Department and Job Title together. The combination must resolve to exactly one approved IAM role before authorization can be provisioned.

Automation must never guess an employee's role or create an authorization mapping dynamically.

## Role Resolution

The resolution sequence is:

```text
Department
    ↓
Job Title within Department
    ↓
Approved IAM Role
    ↓
Global Security Group
    ↓
Existing Domain Local Entitlements
```

Department is evaluated first. Job Title is then evaluated within the context of that Department.

The same job title may exist in multiple departments, but each Department + Job Title combination must have an explicit approved mapping.

The Department + Job Title combination is therefore the authoritative input to IAM role resolution.

## Uniqueness Requirement

Every valid Department + Job Title combination must resolve to exactly one IAM role.

Valid:

```text
Sales + Sales Representative
    ↓
Sales Representative

Sales + Sales Manager
    ↓
Sales Manager
```

Invalid:

```text
Sales + Unknown Title
    ↓
No approved role
```

Also invalid:

```text
Sales + Example Title
    ↓
Role A
Role B
```

Multiple mappings indicate an ambiguous role definition and must not be resolved automatically.

## Role Catalog

The approved IAM role catalog is an IAM-controlled configuration.

The HR job title catalog and the IAM role catalog are separate concepts.

HR provides the employee's Department and Job Title.

IAM maintains the approved mapping that determines which role those attributes represent.

Example:

```text
Department: Sales
Job Title: Sales Representative
IAM Role: Sales Representative
Global Group: GG-Sales-Representatives
Domain Local Entitlements:
    DL-Sales-Data
    DL-Salesforce-User
```

```text
Department: Sales
Job Title: Sales Manager
IAM Role: Sales Manager
Global Group: GG-Sales-Manager
Domain Local Entitlements:
    DL-Sales-Data
    DL-Salesforce-Management
    DL-Salesforce-User
```

## Role Specificity

Roles should be specific to the Department in which they are defined.

A generic job title should not automatically imply a generic authorization role.

For example, if the organization has an Engineer job title in multiple departments, each Department + Job Title combination should have an explicit role mapping.

OUs provide administrative organization and policy scope but are not relied upon as the authorization control preventing role collisions.

## Unmapped Job Title

If the Department is valid but the Job Title cannot be mapped to an approved IAM role, automation must fail closed.

Example:

```text
FAILURE
Employee 12345 — Job Title cannot be mapped to an approved Aerotyne IAM role.
Manual review of the HR job listing is required.
```

No Global Security Group or resource entitlement should be assigned based on an unmapped Job Title.

The issue should be investigated through the authoritative HR/job-listing process before authorization is provisioned.

## Invalid Department + Job Title Combination

If the Department exists but the Department + Job Title combination does not exist in the approved role catalog, automation must report an exception.

Example:

```text
FAILURE
Employee 12345 — Department/Job Title combination does not map to an approved Aerotyne IAM role.
Manual review required.
```

Automation must not select a similar role, use a default role, or infer authorization from the Job Title alone.

## Ambiguous Mapping

If a Department + Job Title combination resolves to more than one IAM role, automation must fail closed.

Example:

```text
EXCEPTION
Employee 12345 — Department/Job Title combination has multiple approved IAM role mappings.
Manual IAM review required.
```

No authorization should be provisioned until the mapping is resolved.

## Group Creation Boundary

Role mapping references existing approved security groups.

Automation must not create Global Security Groups or Domain Local Groups.

If a mapped role references a group that does not exist, provisioning fails and reports the missing configuration.

Example:

```text
FAILURE
Employee 12345 — Required group GG-Sales-Representatives does not exist.
Authorization configuration requires administrative remediation.
```

## Current Approved Roles

The initial automation scope uses the existing Sales role model.

### Sales Representative

```text
Department:
Sales

Job Title:
Sales Representative

IAM Role:
Sales Representative

Global Security Group:
GG-Sales-Representatives

Domain Local Entitlements:
DL-Sales-Data
DL-Salesforce-User
```

### Sales Manager

```text
Department:
Sales

Job Title:
Sales Manager

IAM Role:
Sales Manager

Global Security Group:
GG-Sales-Manager

Domain Local Entitlements:
DL-Sales-Data
DL-Salesforce-Management
DL-Salesforce-User
```

Additional roles will only be introduced when they demonstrate a distinct IAM requirement or are required by a later phase.

## Design Principle

Role resolution is a controlled authorization decision.

The automation translates an approved Department + Job Title mapping into an existing IAM role and its predefined authorization structure.

It does not:

* Guess missing roles
* Create new authorization groups
* Grant access based solely on Job Title
* Grant a default role when mapping fails
* Automatically resolve ambiguous mappings
* Treat OU placement as authorization

Unmapped and ambiguous conditions result in predictable exception states requiring human investigation.
