## Test 1 — Synchronization Scope

### Objective

Confirm that only users located in the `Entra-Sync` OU are synchronized.

### Expected Result

Users in:

`Aerotyne → Employees → Entra-Sync`

should synchronize to Microsoft Entra ID.

Users in Finance, HR, IT, and Sales should not synchronize.

### Result

PASS

The selected synchronization scope was configured for the Entra-Sync OU.

---

## Test 2 — jlee Synchronization

### Objective

Confirm that the `jlee` Active Directory account appears in Microsoft Entra ID.

### Expected Result

`jlee` should appear as a synchronized Entra user.

### Result

PASS

Entra ID displayed the `jlee` account.

Observed:

- On-premises sync enabled: Yes
- Entra account: [exact UPN]
- AD account: jlee

---

## Test 3 — rstone Synchronization

### Objective

Confirm that a second account in the synchronization OU is synchronized.

### Expected Result

`rstone` should appear in Microsoft Entra ID.

### Result

PASS

`rstone` appeared as a synchronized user.

---

## Test 4 — Password Hash Synchronization

### Objective

Confirm that an Active Directory password change can be used
for Microsoft 365 authentication.

### Procedure

1. Reset the `jlee` password in Active Directory.
2. Allow synchronization to occur.
3. Sign in to Microsoft 365 as `jlee`.
4. Confirm successful authentication.

### Result

PASS

The updated Active Directory password successfully authenticated
to Microsoft 365.

---

## Test 5 — Sync Scheduler

### Objective

Confirm that the Entra Connect scheduler is enabled.

### Observed Configuration

- SyncCycleEnabled: True
- CurrentlyEffectiveSyncCycleInterval: 00:30:00
- NextSyncCyclePolicyType: Delta
- StagingModeEnabled: False
- SchedulerSuspended: False

### Result

PASS

---

## Overall Validation

| Test | Result |
|---|---|
| OU synchronization scope | PASS |
| jlee synchronization | PASS |
| rstone synchronization | PASS |
| Password Hash Synchronization | PASS |
| Sync scheduler | PASS |

## Evidence

Screenshots associated with these tests are stored in:

`05_entra/screenshots/`
