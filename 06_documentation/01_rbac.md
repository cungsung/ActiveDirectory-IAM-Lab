Role-Based Access Control within Active Directory
-------------------------------------------------


Overview
--------
Despite already having some experience with RBAC when setting up our initial Aerotyne environment,
I thought I should take it a step further and apply that knowledge to files and folders.


How it was done
---------------
- To accomplish this, I created two new users, Stan Smith, and Chael Sonnen. Stan Smith was added to the 
GG-IT-Users Security group while Chael was added to the GG-Sales-Users group. I then created a folder tree in the C: drive
of the ENTRA01 vm. (Departments ---> IT ---> it-confidential.txt) 
- I then modified the security permissions to make it so that only members of the GG-IT-Users group could access the departments folder
as well of the contents inside of the folder.

- I tested the functionality of the policy by logging on to ENTRA01 as Stan Smith, verifying the that I could access and modify the file, then,
 I logged in as Chael Sonnen and tried to view the same folder/file. The policy worked and denied Chael Sonnen from viewing the contents of the departments
  folder!

Troubleshooting
---------------
While I had initially thought that everything was working, I noticed that Chael could still access the departments file despite allowing only GG-IT-Users to access
the folder. I looked closer to find that all users on ENTRA01 could still view that folder because of the (USERS-WIN....) rule, meaning all users on the system
could view the file. As I tried to remove that permission, windows told me I needed to disable inheritance to do such a removal. I continued with disabling
inheritance and explicitly removing anyone with access except for administrators, members of GG-IT-Users, and SYSTEM. Thus, solving the issue of Chael having
access to the departments folder.

Documentation
-------------
  Please see screenshot, "RBAC-Departments" in 04_screenshots to view what the policy looked like.
