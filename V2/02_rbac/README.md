# 02 — Role-Based Access Control

This phase develops the role-based access control model for the Aerotyne IAM laboratory.

The objective is to translate business responsibilities into controlled technical access while maintaining separation between identity, role membership, resource entitlements, and resource permissions.

## Objectives

* Define business roles.
* Map roles to security groups.
* Define resource entitlements.
* Implement least-privilege access.
* Separate role assignment from resource permissions.
* Validate effective authorization.
* Test unauthorized and unexpected access.
* Establish a model that can later support Joiner-Mover-Leaver automation.

## Authorization Model

```text
User
  ↓
Global Role Group
  ↓
Domain Local Entitlement Group
  ↓
Resource Permission
```

The role model describes what a user does.

The entitlement model describes what access is associated with that role.

The resource ACL enforces the technical permission.

## Current Scope

The initial RBAC implementation focuses on Sales and will expand into administrative and privileged roles as the laboratory develops.

## Phase Completion Criteria

Phase 2 is complete when:

* Business roles are explicitly defined.
* Role-to-entitlement mappings are documented.
* Resource permissions are documented.
* Authorization has been tested using positive and negative test cases.
* Least-privilege decisions have been documented.
* The resulting model is suitable for later JML automation.
