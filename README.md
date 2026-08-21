Active Directory Identity and Access Management Lab
---------------------------------------------------


Overview
--------
The purpose of this lab was to simulate an enterprise environment and to better understand the Identity and Access Management lifecycle
in a hands-on environment. I learned more about how to implement RBAC, Least Privilege, and how the JML lifecycle works.


Environment
-----------
-Oracle VirtualBox
-Windows Server 2025 Evaluation
-2vCPU
-4GB RAM
-60GB Virtual Disk Space

What I Built
------------
-AD forest and domain
-Top level OU named "Aerotyne"
-Employee, computer, group, and disabled user OU's
-Security groups for departmental and specific access (GG-VPN-Access, GG-Payroll-Access, etc)
-CSV file input for automated provisioning
-Automated provisioning script using PowerShell
-Manual JML scenarios

IAM Concepts Demonstrated
-------------------------
-RBAC
Assigned users to security groups based on their job function, allowing access to only required permissions and resources for their job
-Least privilege
With the help of RBAC, users are only assigned roles with permissions and access necessary for their job function
-JML
Simulated the provisioning, moving, and de-provisioning of users in "Aerotyne"
-Access review
Went through users permissions when moving or provisioning to ensure least privilege is enforced
-Privilege creep prevention
Adhered to Least privilege and RBAC practices to ensure a privilege creep is prevented

Automation
----------
The provisioning script I created functions based off of the logic below:
- HR sends a .csv file containing Firstname, Lastname, Username,Job desc, etc... 
- I import the .csv script using Import-CSV "C:\path\path" after also importing AD library
- Created $OU variables with their paths to help script decide where users should be created
- Created $DepartmentGroup variables to help decide what groups users should be placed in within their department
- Used New-ADUser with the previously defined $OU variables as well as .csv data to create users 
- Used the previously defined $DepartmentGroup variables and "Add-ADGroupMember" to assign users to their designated departmental security groups
- Added additional logic for users that require VPN or Payroll access

Joiner/Mover/Leaver (JML)
-------------------------
Joiner: Simulated the manual provisioning and creation of a new user for Aerotyne.
-Create Identity
-Give attributes
-Place in correct department OU
-Assign baseline accesses
-Assign role specific permissions (Payroll access)

Mover: Simulated scenarios where an employee may move to another department or changed roles within the same department.
-Review existing access
-Remove access unrelated to new position
-Update dept and title
-Move user to correct OU
-Add new role-specific access

Leaver: Simulated scenarios where an employee has to leave the company. I then went through all the motions to adhere to best security practices when doing so.
-Disable account
-Remove all access
-Move account into Disabled Users OU
-Preserve user for retention or auditing purposes

What's Next?
------------
Future improvements for this lab environment include:
-Error Handling for provisioning script
-Automated deprovisioning
-Duplicate user detection for provisioning script
-Microsoft Entra ID integration
-MFA
-SSO
-Provisioning logs and audit reports
-Automated mover workflows






