# Aerotyne IAM Lab — V2
## Overview

### V2 is an independently designed rebuild of my Active Directory and Microsoft Entra ID IAM laboratory environment.

The purpose of V2 is to develop practical skills in identity and access management by designing, implementing, testing, breaking, and troubleshooting an enterprise-style identity environment.

Unlike the initial version of this lab, V2 is intentionally being developed with an emphasis on independent decision-making and documentation. Architectural decisions are researched before implementation, and design choices are documented with their intended security and operational purpose.

## Environment

Organization: Aerotyne International
Environment: Isolated virtual laboratory
Active Directory domain: aerotyne.local
Domain Controller: DC01

Aerotyne International is a fictional organization created for educational purposes. This environment is not representative of a production deployment.

## Current Objectives
Design an Active Directory identity architecture
Implement department-based organizational structure
Develop an RBAC model using AGDLP principles
Implement Joiner-Mover-Leaver workflows
Develop PowerShell-based identity provisioning automation
Integrate Active Directory with Microsoft Entra ID
Explore authentication technologies including MFA, SSO, and FIDO2/passkeys
Develop a laboratory PKI environment
Test identity lifecycle and access-control scenarios
Intentionally introduce failures and troubleshoot them
Document architectural decisions, testing, and lessons learned
## Design Philosophy

### The environment is being developed around several core IAM principles:

Least privilege
Role-based access control
Separation of administrative and standard identities
Centralized identity management
Controlled access provisioning
Documented and auditable changes
Repeatable automation
Security-focused testing

Architectural decisions are made before implementation whenever practical. Documentation records both successful implementations and design decisions that were changed or rejected during development.
