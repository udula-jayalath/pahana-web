# Changelog

All notable changes to **pahana-web** are documented here.  
Format: Added / Changed / Fixed / Security.

## [1.0.0] - 2025-08-20
### Added
- **Authentication**
    - Login, redirect to Dashboard on success.
    - **login_audit** entry created on successful login.
    - `AuthFilter` protecting app routes.
- **Customers**: Full CRUD with server-side validation.
- **Items**: Full CRUD with server-side validation.
- **Billing**
    - Create invoice (bill) with line items.
    - Live UI: Unit Price, Qty, Amount; auto Subtotal, Discount, Tax, Grand Total.
    - Server-authoritative pricing and totals; transactional DB write.
    - Invoice view with **Print Bill** button + print-friendly CSS.
- **Help**
    - `/help` page with User Manual (expand/collapse, search, print) and shortcut buttons.

### Changed
- **Users table** restructured to:
    - `id, username, password_hash, role, status, created_/updated_`
- **DB config loading**
    - Robust loading via `AppConfigContextListener` (`/WEB-INF/db.properties`) with classpath fallback.

### Fixed
- 404 / JSP compilation issues on first deploy.
- `db.properties` classpath resolution problems.

### Security
- All SQL access uses PreparedStatements.
- Passwords stored as **hashes** (see README for details).

---

## [0.1.0] - 2025-08-10
### Added
- Initial Maven project (GroupId `lk.icbt.pahana`, ArtifactId `pahana-web`).
- Basic folder structure, `web.xml`, login page, dashboard skeleton.
- Connection factory and MySQL driver wiring.
