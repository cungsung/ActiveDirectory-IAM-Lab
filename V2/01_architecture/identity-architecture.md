# Identity Architecture

## Domain

aerotyne.local

### Rationale

I had thought for a while about the naming convention. "corp.aerotyne.com" sounded too much like
an actual company. I wanted to show that this is merely a lab, and not a reflection or actual documentation
of architecture I created for a company.

## Domain Controller

DC01

### Rationale

Initially, I chose DC02 because I wanted to avoid confusion between this version of my IAM lab and the old V1
version of my IAM lab. I decided to choose DC01 anyway because I figured a giant separator in my repository 
named "V2" would be enough of a sign that this is a different version!

## OU Structure

Aerotyne
├── Departments
│   ├── Engineering
│   ├── Finance
│   ├── HR
│   ├── Sales
│   ├── IT
│   └── Operations
├── Disabled Users
└── Admin Accounts

### Rationale

Users in this domain are organized by department, not role. Imagine if I chose role-based organization
and not department-based organization...I might have 100+ OUs in the domain and things would be all tangled. Therefore,
department-based organization was the best fit for my lab's requirements. The reason is the same as to why 
I deliberately avoided a generic "Users" OU. If I had a Department OU like "Finance" and
also had a "Users" OU. What would then be the purpose of my departmental setup? These are the 
questions I've been asking during this iteration of the lab. 
As far as the Admin Accounts OU stands, I created it to keep administrative entites separate from their day-to-day
browsing and job duties. The OU contains accounts used for higher-level administrative responsibilities like network
administration, system administration, and cryptography management and administration.
The disabled users OU is there to place deprovisioned users for the purpose of retaining all disabled objects in Aerotyne.


## Future Hybrid Identity

As of now, I plan to sync my on-prem environment to EntraID. My goal is to sync everything at once and create a new Entra tenant to avoid conflict with V1!
