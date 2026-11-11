# Objective:
The goal for this document is to function as a workbook for the design decisions that are needed
to implement hybrid identity in V2. As of now, there is a current roadblock due to licensing in Entra
ID. Therefore, I chose to move forwards with Okta to import test users from my on-prem Active Directory 
environment into Okta to test the configuration of users via Okta. I also plan to implement MFA and SSO
via Okta if the trial allows for such.

## Design Questions:

### Which AD OU contains test users for import?
My initial idea was to create a test OU to add users to, then export to Okta, but I think the better choice would to
import the entire sales OU as well as the groups OU to preserve my structure and organization. If I were to create
a separate OU, then I would essentially be creating an exact copy of the current sales OU with test users. I think the more
efficient idea would just to import both sales and groups OUs. All of my security groups in my groups OU already contain 
all groups required for the sales OU. I don't have any other departments in my environment right now, but assuming I
had financial or engineering, I'd likely just import the objects required to run the test. 

### Which specific test users should be imported?
Since I plan on adding all of the Sales OU, all of those users will be imported to Okta. Although, I think it wouldn't hurt to add
a few more sales users. Just for the sake of learning how to manage a lot of users at once in Okta.  

### Which groups need to be imported?
I think that whatever users I will be adding, groups should reflect their role following what I've already created.
 Sales reps will have sales data, salesforce user permissions, etc. The same goes with sales supervisors.

### Should nested group membership be part of the initial test?
Yes, according to Okta documentation, it can handle the import of nested groups in AD, meaning I can confidently add the sales OU and 
have all users be assigned to groups as they were in AD.

### Which identity attribute must be validated?
I say that first and last name, Username, Employee ID, Job Title, Department, and groups should all be attributes that are to be validated.
I'm hoping that gives enough information for Okta to be able to differentiate between these users. I considered using first and last, but
for the sake of the current naming convention of test users in my lab, I think that username, employee ID amongst the other
role-related identifiers should suffice.


### What should happen in Okta when an AD test user is disabled?
If an AD account is disabled, it should also be changed accordingly in Okta. If an account is moved outside the configured import scope, it 
should be defined whether or not the account is to be deactivated, stopped being updated or retained.

### Should Okta be allowed to write changes back to AD?
No, the integration will initially be kept as read only on the Okta end, and Active Directory will be my authoritative identity source. 


## Governance and Service accounts

### Service Accounts
So after some thought and research, Okta has multiple services. Following best practice and least privilege, I believe the best choice is
to have a service account for each responsibility in Okta. That being said, a new OU is to be created in the Accounts tree to house
these service accounts.

### Governance
To ensure that these service accounts aren't created indefinitely, the plan is to have quarterly reviews of these accounts. These reviews
are to be completed by an administrator and they are responsible for validating these things:
* Continued business and operational need
* Account ownership and a documented purpose
* Group memberships and assigned permissions
* Account activity and signs of unauthorized use
* Credential storage and management controls
* Required remediation and review documentation.
The application or service owner remains responsible for confirming that the account is still required.
