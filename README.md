# Pahana Web

A lightweight Java (Servlets/JSP) web app for **Customers**, **Items**, and **Billing** with a built-in **Help/User Manual**.  
Designed OOP-first, **no frameworks**, compliant with the assignment rule: only **JUnit**, **Database**, and **Serialization** allowed.

- **GroupId:** `lk.icbt.pahana`
- **ArtifactId:** `pahana-web`
- **Server:** Apache Tomcat 9
- **DB:** MySQL 8 (or compatible)
- **JDK:** 17+

---

## ✨ Features

- **Auth**
    - Username/password login
    - Redirect to Dashboard on success
    - `login_audit` entry on successful login
    - `AuthFilter` protects app routes
- **Customers** – Create, list/search, edit, delete
- **Items** – Create, list/search, edit, delete
- **Billing**
    - Create invoice (bill) with multiple line items
    - Live UI: **Unit Price**, **Qty**, **Amount**; **Subtotal / Discount / Tax / Grand Total**
    - Server computes and persists all pricing (DB is source of truth)
    - Printable invoice with **Print Bill** button
- **Help / User Manual**
    - `/help` with expandable sections, search, print
    - Shortcut buttons to **Dashboard / Customers / Items / Billing / New Bill**

---

## 🛠 Prerequisites

- **Java 17**
- **Tomcat 9** (or IntelliJ Tomcat runner)
- **MySQL 8** (XAMPP ok)
- **Maven 3.9+**
- **MySQL Connector/J 8.x**

---

## 📦 Project Structure

```text
pahana-web
├─ src/main/java/lk/icbt/pahana
│ ├─ dao/ # ConnectionFactory, UserDAO, CustomerDAO, ItemDAO, BillDAO
│ ├─ model/ # User, Customer, Item, Bill, BillItem, ManualSection
│ ├─ service/ # AuthenticationService, CustomerService, ItemService, BillingService, HelpService
│ └─ web/ # Servlets (Login, Customers, Items, Bills, Help), Filters, Listener
├─ src/main/webapp
│ ├─ views/ # JSPs: login, dashboard, customers(+form), items(+form),
│ │ # bills(+form,+view), help
│ └─ WEB-INF/ # web.xml (+ optional db.properties)
└─ pom.xml

```

---

## ⚙️ Configuration

Create `db.properties` (pick **one** location):

**A) Classpath**  
`src/main/resources/db.properties`

**B) Webapp**  
`src/main/webapp/WEB-INF/db.properties`

```properties
db.url=jdbc:mysql://localhost:3306/pahana_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.user=root
db.password=YOUR_PASSWORD

```

---


## 🗄️ Database Schema
```
users: id, username, password_hash, role, status, created_/updated_

login_audit: id, username, login_time, ip_address, user_agent

customers: id, account_no(uniq), name, address, telephone, units, audit cols

items: id, name, unit_price, status, audit cols

bills: id, bill_no(uniq), customer_id🔗, bill_date, subtotal, discount, tax, total, status, audit cols

bill_items: id, bill_id🔗, item_id🔗, qty, unit_price, line_total

```
## 🚀 Build & Run

### Build

```bash
mvn clean package -DskipTests

```
### Deploy
- **IntelliJ: deploy war exploded to Tomcat**
- **or copy `target/pahana-web.war` → `${TOMCAT_HOME}/webapps/`**

### Run
-- Start Tomcat → open
`http://localhost:8080/pahana-web/`

---
## 🧠 Design & OOP Notes

- **3-tier: DAO ↔ Service ↔ Web (Servlets/JSP)**
- **Validation in Service layer**
- **PreparedStatements for all SQL (no injection)**
- **Transactions around ```bill``` + ```bill_items``` insert**
- **Server-authoritative pricing (UI is for display only)**

---

## 🩹 Troubleshooting

- **Cannot connect to DB**: check `DBConnection.java` + MySQL running.
- **JSP EL errors**: ensure IntelliJ uses Tomcat 9 + Servlet API 4.0+.
- **Session not clearing**: verify logout page invalidates session and sets no‑cache headers.

---

## 📄 License

**For academic/internal use unless a LICENSE is added.**
