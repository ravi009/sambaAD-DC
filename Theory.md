# Samba AD DC

A quick reference guide for managing a Samba Active Directory Domain Controller (AD DC), Organizational Units (OUs), Group Policy Objects (GPOs), and RSAT tools.

---

# Organizational Unit (OU)

An **OU (Organizational Unit)** is a container inside Active Directory used to organize objects such as:

* 👤 Users
* 💻 Computers
* 👥 Groups

Think of an OU as a folder in a file system.

OUs are used to:

* Organize users and computers logically
* Separate departments, labs, or student groups
* Apply Group Policies to multiple objects at once
* Delegate administrative control

Example structure:

```text
iot.local
│
├── Students
│   ├── Semester1
│   ├── Semester2
│   └── Semester3
│
├── Staff
│
└── Computers
    ├── Lab1
    ├── Lab2
    └── Lab3
```

---

# Group Policy Object (GPO)

A **Group Policy Object (GPO)** is a collection of rules and settings applied to users and computers.

GPOs determine:

* What users can do
* What computers can do
* Security settings
* Desktop settings
* Software restrictions
* Device restrictions

There are two types of GPO settings:

## 1. User Configuration

Applies to the user regardless of which computer they log into.

Examples:

* Desktop wallpaper
* Control Panel restrictions
* Start Menu settings

## 2. Computer Configuration

Applies to the computer regardless of who logs in.

Examples:

* USB restrictions
* Firewall settings
* Windows Updates
* Local Administrator configuration

---

# Group Policy Processing Order

When a user logs in, policies are applied in the following order:

```text
L → S → D → OU
```

Where:

| Abbreviation | Meaning                    |
| ------------ | -------------------------- |
| L            | Local Policy               |
| S            | Site Policy                |
| D            | Domain Policy              |
| OU           | Organizational Unit Policy |

Important notes:

* Policies applied later have higher priority.
* OU policies override Domain policies.
* Child OUs inherit policies from parent OUs by default.

---

# Samba AD DC Commands

## Create an OU

```bash
samba-tool ou create "OU=Students,DC=iot,DC=local"
```

**Note:**

`DC` stands for **Domain Component**.

For the domain:

```text
iot.local
```

the Distinguished Name (DN) becomes:

```text
DC=iot,DC=local
```

---

## Create a GPO

```bash
samba-tool gpo create "Student-Restrictions"
```

---

## Link a GPO to an OU

```bash
samba-tool gpo setlink "OU=Students,DC=iot,DC=local" "Student-Restrictions"
```

---

## List All GPOs

```bash
samba-tool gpo listall
```

---

## Check GPO Links

```bash
samba-tool gpo listlinks "OU=Students,DC=iot,DC=local"
```

---

## Move a User to an OU

```bash
samba-tool user move student1 "OU=Students,DC=iot,DC=local"
```

---

# Managing GPOs Using RSAT

Applying advanced restrictions through the Samba CLI can be difficult.

For day-to-day administration, use **RSAT (Remote Server Administration Tools)**.

---

# RSAT Components

## 1. Active Directory Users and Computers (ADUC)

Used to manage Active Directory objects.

### Users

* Create users
* Reset passwords
* Enable/disable accounts
* Unlock accounts

### Groups

* Create groups
* Add/remove members
* Manage permissions

### Organizational Units

* Create OUs
* Move users and computers
* Organize directory structure

### Computers

* View domain-joined computers
* Manage computer accounts

---

## 2. Group Policy Management (GPMC)

Used to manage Group Policy.

Tasks include:

* Create GPOs
* Edit GPOs
* Link GPOs to OUs
* Security filtering
* GPO inheritance management

---

## 3. DNS Manager

Used to manage:

* DNS zones
* Host records
* Reverse lookup zones
* Name resolution

---

# Example: Disable USB for Students

## Step 1

Open:

```text
Group Policy Management
```

## Step 2

Select the GPO.

## Step 3

Open:

```text
Scope Tab
```

## Step 4

Remove:

```text
Authenticated Users
```

## Step 5

Add:

```text
Students
```

This ensures the policy only applies to members of the Students group.

---

# Verify Applied Policies

Run on a client machine:

```cmd
gpresult /r
```

This displays:

* Applied GPOs
* Filtered GPOs
* User policies
* Computer policies

---

# Recommended Initial AD Structure

## User OUs

```text
Students
├── Semester1
├── Semester2
└── Semester3

Staff
```

## Computer OUs

```text
Computers
├── Lab1
├── Lab2
└── Lab3
```

Place:

* Students in the Students OU
* Staff in the Staff OU
* Computers in the appropriate Lab OU

This structure makes it easy to apply GPOs and manage permissions efficiently.

---

# Best Practice

Remember:

```text
OU      = Organization + GPO Targeting
Group   = Permissions
User    = Person
Computer= Machine
GPO     = Rules
```

Keep permissions assigned to groups and use OUs primarily for organization and GPO application.
