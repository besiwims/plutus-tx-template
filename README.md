Absolutely — here’s your `README.md` upgraded with **professional icons** (from GitHub’s emoji set) for each section, while keeping the numbered format, clean hierarchy, and glossary at the end.

---

````md
# 🧭 1. Auction Validator Project

Updated by **Coxygen Global – Bernard Sibanda**  
> 💡 Plinth currently supports **GHC 9.6.x** and **Cabal 3.8+** (recommended).

---

## 📑 2. Table of Contents

1. [🧭 Auction Validator Project](#-1-auction-validator-project)  
2. [📑 Table of Contents](#-2-table-of-contents)  
3. [⚙️ Overview](#️-3-overview)  
4. [✨ Features](#-4-features)  
5. [🏗️ Architecture](#️-5-architecture)  
6. [📋 Prerequisites](#-6-prerequisites)  
7. [⚡ Quick Start](#-7-quick-start)  
8. [🛠️ Installation & Build](#️-8-installation--build)  
9. [🧪 Testing](#-9-testing)  
10. [🔍 Property-Based Testing](#-10-property-based-testing)  
11. [🚀 Usage](#-11-usage)  
12. [⚙️ Configuration](#️-12-configuration)  
13. [📂 Directory Structure](#-13-directory-structure)  
14. [🔄 Development Workflow](#-14-development-workflow)  
15. [🤖 CI/CD (Optional)](#-15-cicd-optional)  
16. [🧯 Troubleshooting](#-16-troubleshooting)  
17. [💬 FAQ](#-17-faq)  
18. [🤝 Contributing](#-18-contributing)  
19. [📜 License](#-19-license)  
20. [📖 Glossary](#-20-glossary)

---

## ⚙️ 3. Overview

This repository contains a **Plutus-based Auction Validator** and **Minting Policy**.  
It includes **Blueprint generators**, **property-based tests**, and **development tooling**.  
The project is based on the **Plinth Template** for teaching on-chain Cardano smart contract development.

---

## ✨ 4. Features

- 🪙 On-chain **Auction Validator** (bid, close, payout logic)  
- 🧱 **Minting Policy** for auction tokens  
- 🧩 **Blueprint** generation tools for off-chain deployment  
- 🧪 **Unit tests** and **property-based tests**  
- 🧰 **Nix** and **Devcontainer** support for reproducibility  
- 🔄 Modular Cabal/Nix structure for teaching and reuse

---

## 🏗️ 5. Architecture

| Layer | Purpose |
|-------|----------|
| 🧠 **On-chain Logic** | Implemented in `src/AuctionValidator.hs`. |
| 🧰 **Executables** | Blueprint generators under `app/`. |
| 🧪 **Tests** | Unit + property suites under `test/`. |
| ⚙️ **Infrastructure** | Cabal/Nix build environment. |

---

## 📋 6. Prerequisites

- **GHC** `9.6.x`  
- **Cabal** `3.8+`  
- **Nix** *(optional)*  
- **Docker / Devcontainer** *(optional)*

> 🧩 If not using Nix, install via [Haskell Platform](https://www.haskell.org/platform/) or `ghcup`.

---

## ⚡ 7. Quick Start

```bash
# 1️⃣ Enter Nix shell (recommended)
nix-shell

# 2️⃣ Update Cabal package index
cabal update

# 3️⃣ Build project and tests
cabal build --enable-tests

# 4️⃣ Run test suite
cabal test
````

---

## 🛠️ 8. Installation & Build

1. **Enter Nix shell (optional)**

   ```bash
   nix-shell
   ```

2. **Update Cabal index**

   ```bash
   cabal update
   ```

3. **Build project**

   ```bash
   cabal build --enable-tests
   ```

4. **Generate Blueprints**

   ```bash
   cabal run gen-auction-validator-blueprint -- ./blueprint-auction.json
   cabal run gen-minting-policy-blueprint -- ./blueprint-minting.json
   ```

---

## 🧪 9. Testing

### 🧩 Unit Tests

```bash
cabal test auction-tests
```

### 🔁 Run All Tests

```bash
cabal test
```

---

## 🔍 10. Property-Based Testing

Example Cabal config:

```cabal
test-suite auction-properties
  type: exitcode-stdio-1.0
  main-is: AuctionValidatorProperties.hs
  hs-source-dirs: test
  build-depends:
      base >=4.7 && <5
    , QuickCheck
    , plutus-ledger-api
    , plutus-tx
    , scripts
  default-language: Haskell2010
```

Run:

```bash
cabal test auction-properties
```

---

## 🚀 11. Usage

1. **Customize parameters** in `app/GenAuctionValidatorBlueprint.hs`
   (e.g. seller, token name, min bid, end time).
2. **Generate blueprint JSONs** via Cabal commands.
3. **Deploy** the compiled Plutus scripts to Cardano network.
4. **Verify** with unit and property-based tests.

---

## ⚙️ 12. Configuration

* Project settings: `cabal.project`, `auction.cabal`
* Local overrides: `cabal.project.local`
* To ignore local configs:

  ```bash
  echo "cabal.project.local" >> .gitignore
  ```

---

## 📂 13. Directory Structure

```text
auction/
├── app/                        # Executables (Blueprint generators)
│   ├── GenAuctionValidatorBlueprint.hs
│   └── GenMintingPolicyBlueprint.hs
├── src/                        # On-chain modules
│   └── AuctionValidator.hs
├── test/                       # Tests
│   ├── AuctionValidatorSpec.hs
│   ├── AuctionMintingPolicySpec.hs
│   └── AuctionValidatorProperties.hs
├── default.nix
├── shell.nix
├── auction.cabal
├── cabal.project
└── cabal.project.local
```

---

## 🔄 14. Development Workflow

1. 🌿 Create a new branch
2. 🧱 Make modular commits
3. ✅ Run `cabal test`
4. 🧹 Format and lint
5. 🔀 Merge via PR
6. 🏷️ Tag releases

---

## 🤖 15. CI/CD (Optional)

* 🧰 **Build & Test:** `cabal build --enable-tests && cabal test`
* 📦 **Artifacts:** Upload blueprint JSONs, logs, etc.
* ⚡ **Cache:** Use Cabal store caching for faster pipelines.

---

## 🧯 16. Troubleshooting

| Issue              | Fix                                                         |
| ------------------ | ----------------------------------------------------------- |
| Build fails        | `cabal clean && cabal update && cabal build --enable-tests` |
| Wrong compiler     | Use `ghc --version` → must be 9.6.x                         |
| Nix errors         | Try `nix develop` or update flakes                          |
| Devcontainer fails | Check Docker Desktop / VSCode extensions                    |

---

## 💬 17. FAQ

**Q:** Do I need Nix?
**A:** No. It’s optional but ensures reproducibility.

**Q:** Where do I change auction parameters?
**A:** In `GenAuctionValidatorBlueprint.hs`.

**Q:** How do I run only property tests?
**A:** `cabal test auction-properties`

---

## 🤝 18. Contributing

1. 🍴 Fork this repo
2. 🌿 Branch from `main`
3. 🧩 Add code + tests
4. 🔍 Verify with `cabal test`
5. 📨 Open a Pull Request

---

## 📜 19. License

Released under the **MIT License** (or your organization’s chosen license).
See the `LICENSE` file for details.

---

## 📖 20. Glossary

| Icon | Term              | Description                                            |
| ---- | ----------------- | ------------------------------------------------------ |
| ⚙️   | **Cabal**         | Haskell’s package manager and build tool.              |
| 🧠   | **GHC**           | The Glasgow Haskell Compiler.                          |
| 💎   | **Plutus**        | Cardano’s smart contract platform.                     |
| 🧾   | **Blueprint**     | JSON representation of a Plutus script and parameters. |
| 🧩   | **ScriptContext** | Context for execution (`TxInfo`, `ScriptPurpose`).     |
| 🔗   | **TxInfo**        | Transaction metadata passed to the validator.          |
| 🧪   | **QuickCheck**    | Haskell property-based testing framework.              |
| 🧭   | **hspec**         | Behavior-driven testing framework for Haskell.         |
| 🗺️  | **AssocMap**      | Plutus internal key–value map type.                    |

---

🧠 *Maintained by Coxygen Global – Bernard Sibanda*
📅 *Last updated: 15 September 2025*
*Developer: Balogun Muiz Dolapo*
```

---

Would you like me to include **badge icons** (like build status, license, test coverage) at the top — for a GitHub-ready header? Those make it look extra professional for open-source repos.
```
