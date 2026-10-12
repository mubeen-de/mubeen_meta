# Kapmeta POS — Beta Testing & Staging Environment

## Architecture Overview

To ensure that in-development or experimental features are tested thoroughly without disrupting client systems in production, this repository is organized into two primary channels:

| Channel | Branch | Intended Audience | Purpose |
| :--- | :--- | :--- | :--- |
| **Beta Testing** | `beta` | Developers, QA Testers | Testing new features, experimental patches, UI updates. Changes pushed here **NEVER** go to client systems. |
| **Production Client** | `main` | Client Systems, Restaurant POS | Verified, production-ready releases. When client systems pull updates, they pull exclusively from `main`. |

---

## Remote Repository
* **GitHub URL**: [https://github.com/mubeen-de/mubeen_meta](https://github.com/mubeen-de/mubeen_meta)

---

## Developer & QA Workflow

### 1. Developer pushes to Beta (Does NOT affect Main)
Developers commit and push experimental or new features directly to the `beta` branch:
* Double-click `beta/Push_To_Beta.bat` (or root `Push_To_Beta.bat`).
* This pushes directly to `origin/beta`.
* Client systems pulling from `main` are 100% unaffected.

### 2. Testing the Beta Build
Testers on QA machines pull the latest beta commits:
* Double-click `beta/Pull_Beta.bat` (or root `Pull_Beta.bat`).
* Run `Start_PetPooja.bat` to test the POS features, kitchen screens, billing, etc.

### 3. Promoting Verified Beta to Main (Production Release)
Once all tests and QA reviews pass in the `beta` branch:
* Run `beta/Promote_Beta_To_Main.bat`.
* This merges the tested commits from `beta` into `main` and pushes to GitHub `origin/main`.

### 4. Client Systems Pull from Main
On client machines:
* Run `Pull_From_GitHub.bat` (or click **"Pull Latest Updates & Upgrade"** in the in-app Update Center).
* The script automatically pulls from `main` by default, ensuring the client only receives stable, tested software.
