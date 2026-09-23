# Access Model

## Purpose
The general structure of the security groups is, in theory,
optimized for security and least privilege. The DomainLocal 
groups are nested inside of the global groups, allowing for a clear
separation between one role, and another. Each DomainLocal group corresponds
to one permission rather than a list of permissions assigned once users
are added to the security Global Groups.
## Authorization Flow

User
→ Global Role Group
→ Domain Local Entitlement Group
→ Resource Permission

## Sales Representative

### Role Group
GG-Sales-Representatives

### Entitlements
DL-Salesforce-User
DL-Sales-Data

### Resulting Access
As stated earlier, you can see clearly what roles sale representives hold.
The DL-Salesforce-User is meant to be the most basic access required for Sales
Representatives to do their jobs. It also serves as the most basic access for
anyone really to access salesforce. This way, JIT permissions can be set via 
just the DomainLocal groups rather than assigning users to Global Groups with
predefined access they may not need. 


## Sales Supervisor

### Role Group
GG-Sales-Supervisors

### Entitlements
DL-Salesforce-User
DL-Sales-Data
DL-Salesforce-Management

### Resulting Access
As you can see, it looks a little redundant; "DL-Salesforce-User, DL-Salesforce-Management".
This is actually a deliberate choice I made. Rather than having one role like:
"DL-Salesforce-Admin" with permissions that would be more than required for supervisors to have,
or when needed, the only option for a temporary supervisor to be given access to that role,
it could be potentially hazardous. Just because their title is "Sales Supervisor", does
not mean they should have one role and permission that covers the entire scope of their work. That's
why there is "DL-Salesforce-User" (Basic Salesforce access, required to use the platform at all) and 
"DL-Salesforce-Management" (additional permissions required for managing agents within salesforce).

## Authorization Boundaries

The reason "DL-Sales-Data" was created, was to show what a theoretical access to proprietary or 
department-sensitive data would look like. Users need to be in the specific "DL-Sales-Data" group
to access the sales data. I will go further later on about how that was tested, but the basic idea was:
DL-Sales-Data –--> (sales-data.txt)
testsalesrep ---> sales-data.txt = Access Granted with Read and Write capabilities. (In DL-Sales-Data security group)
nonsalesrep ---> sales-data.txt = Access Denied (Not in DL-Sales-Data security group)

## Role Transition

### Representative → Supervisor
If a representative is promoted to Sales Supervisor, they would be added to the
"GG-Sales-Supervisor" security group. The nested DomainLocal groups would be assigned, granting permissions
required for the supervisor role. It is important to understand that in any other case, all current roles would
be removed as soon as the user is taken out of their current group for example, "GG-Sales-Representative", and 
added to the "GG-Sales-Supervisor" Global Group. Then, their new permissions are assigned. This way the deprovisioning
is easier, and privilege creeps are reduced. 
 ** NOTE:** Please do not misunderstand, quarterly access reviews will still be conducted. The architecture is not there to
 act as a compensating control for access reviews. 



### Supervisor → Representative
If there was a scenario where a supervisor needed to be demoted from their position to a representative,
they would be removed from the global group "GG-Sales-Supervisor" and added to "GG-Sales-Representative"
With the current architecture, the supervisory "DL-Salesforce-Management" role would be removed.
The result would be: "DL-Sales-Data" and "DL-Salesforce-User".


## Temporary/JIT Access

In "role-model.md" I stated that JIT permissions would be added in the event temporary access needs to be granted to 
users. The initial decision was to add users to the required DomainLocal groups as needed with a formal change request
submission, but that is not best practice. In the CompTIA Security+ material, there was emphasis on JIT permissions
and reducing potential privilege creeps, or internal threat actors from disrupting workflows or the company. 

I later changed my initial decision from: Change request ---> Temporary access granted to DomainLocal groups through ADUC---> manual removal through
ADUC

To: Change Request ---> JIT implementation, valid only for time listed on CR ---> automatic credential expiration, no more
access to permissions.

As of now, this is just the rough draft of what JIT access may look like. I plan to revisit this later.

## Authorization Rules
The following authorization rules define conditions that should remain true throughout the IAM environment.

### Role-Based Access
1. Users should receive standard Sales access through an appropriate Global Role Group rather than through direct assignment of individual resource permissions.
2. GG-Sales-Representatives represents the Sales Representative business role.
3. GG-Sales-Supervisors represents the Sales Supervisor business role.
4. A user should not simultaneously hold both GG-Sales-Representatives and GG-Sales-Supervisors as their permanent Sales role.

### Entitlement Separation
5. DL-Salesforce-User represents baseline Salesforce access and is required by both Sales Representatives and Sales Supervisors.
6. DL-Sales-Data represents access to Sales-controlled data and is required by both Sales Representatives and Sales Supervisors.
7. DL-Salesforce-Management represents supervisory capabilities within Salesforce and should only be available to users with an authorized supervisory requirement.
8. Salesforce management access should not be bundled into the baseline Salesforce user entitlement.
9. Domain Local entitlement groups should represent distinct access capabilities rather than unnecessarily broad collections of unrelated permissions.

### Least Privilege
10. A user's access should correspond to the responsibilities of their current role.
11. A user should not retain supervisory permissions after their supervisory role has been removed.
12. A role change should result in the old role's entitlements being removed and the new role's entitlements being established.
13. Access should not be granted directly to individual users when the required authorization can be represented through the established group model.

### Resource Authorization
14. Access to Sales-controlled data should be granted through DL-Sales-Data.
15. Individual users should not receive direct NTFS permissions to Sales-controlled resources unless a documented exception is explicitly approved.
16. Resource permissions must be evaluated together with inherited permissions when validating effective access.
17. Unintended inherited permissions must not create an authorization path that bypasses the intended RBAC model.

### Role Changes
18. A promotion from Sales Representative to Sales Supervisor should remove GG-Sales-Representatives and assign GG-Sales-Supervisors.
19. A demotion from Sales Supervisor to Sales Representative should remove GG-Sales-Supervisors and assign GG-Sales-Representatives.
20. A promotion must result in DL-Salesforce-Management becoming available through the Supervisor role.
21. A demotion must result in DL-Salesforce-Management no longer being available through the employee's permanent role.
22. Role changes must be supported by the organization's documented approval process.

### Temporary and JIT Access
23. Temporary elevated access should not require permanent membership in a higher-privilege business role.
24. Temporary access should be limited to the specific entitlement required for the approved task.
25. Temporary elevated access should have a defined activation period and automatic expiration.
26. Temporary access should be auditable and associated with an approved business request.
27. JIT access should not permanently alter the employee's underlying business role.

### Access Review
28. Supervisory access should be reviewed quarterly.
29. Access reviews should determine whether current permissions remain justified by the employee's current responsibilities.
30. Access reviews are an independent control and should not be treated as a replacement for correct role assignment, timely deprovisioning, or JIT expiration.

### Authorization Testing
31. Every role should have both positive and negative authorization tests.
32. A user possessing the appropriate role should receive the access defined by that role.
33. A user lacking the appropriate role should not receive access solely because they belong to a broader group such as BUILTIN\Users.
34. Effective access testing should validate the complete authorization path from user membership through nested groups and ultimately to the resource permission.
35. Changes to group membership should be validated to ensure that effective permissions change as expected.
