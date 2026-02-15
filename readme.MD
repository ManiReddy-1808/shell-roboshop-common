```md
---

## ♻️ Reusable Code Architecture (`common.sh`)

To keep the automation clean and maintainable, this project follows the **DRY principle (Don’t Repeat Yourself)** 🧠

Instead of repeating the same logic inside every service script, all shared functionality is written once inside:

```

common.sh

````

Every script imports it using:

```bash
source common.sh
````

This is similar to using a library in programming languages — write once, reuse everywhere ✨

---

### 🔐 Root Privilege Check

Ensures the script is executed only with proper permissions.

**Why important ❓**
Most installation and configuration steps require admin privileges.
Running without root can leave the system in a broken or half-configured state.

**Behavior:**

* If root → continue ✔️
* If not root → stop immediately ❌

Prevents accidental misconfiguration ⚠️

---

### 👤 Application User Management

Automatically creates the application user only if it does not already exist.

**Benefits:**

* Avoids duplicate users
* Keeps scripts idempotent
* Safe to rerun automation

**Example:**
System checks first → then creates only when required.

---

### 📜 Centralized Logging

All scripts write logs in a consistent structured format.

**Location:**

```
/var/log/shell-roboshop/
```

**Advantages:**

* Easier troubleshooting 🔍
* Standard log format 📏
* Audit friendly 🏢
* Quick root cause analysis

Every step prints meaningful status messages instead of silent execution.

---

### ✔️ Status Validation

After every important command, the script verifies whether it succeeded.

**Flow:**

* Command success → continue
* Command failure → stop script safely with error message

This prevents hidden failures and debugging nightmares 😄

No more:

> “Script finished but service not working”

---

### 📦 Smart Package Installation

Reusable installation function:

* Checks if package already installed
* Installs only when missing
* Avoids unnecessary downloads
* Speeds up re-execution

Perfect for repeatable automation ♻️

---

### 🧠 Standardized Output Messages

All scripts print uniform messages:

* INFO messages ℹ️
* SUCCESS messages ✅
* FAILURE messages ❌

This makes logs readable even for someone new to the project.

---

## 🏗️ How Service Scripts Use It

Each service script starts with:

```bash
source /home/ec2-user/shell-roboshop-common/common.sh
```

Then directly calls shared functions:

```bash
check_root
create_app_user
install_package nginx
validate $? "Installing Nginx"
```

---

## 🎯 Why This Matters

This structure makes the project:

* Easier to maintain 🧹
* Production structured 🏢
* Debug friendly 🔍
* Idempotent ♻️
* Scalable for more services 🚀

In real DevOps environments, centralizing shared logic like this is a standard engineering practice.

```
```
