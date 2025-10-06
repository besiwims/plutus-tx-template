# 📦 Auction Validator Project

### Updated by Coxygen Global - Bernard Sibanda

## 📑 Table of Contents

1. ⚙️ Project Overview
2. ⚙️ Environment Setup
3. 📂 Directory Structure
4. 🛠️ Installation & Build
5. 🔬 Testing
6. 🧪 Property-Based Testing
7. 🚀 Usage
8. 📖 Glossary

---

## 1. ⚙️ Project Overview

This repository contains a Plutus-based Auction Validator smart contract along with tooling to generate Blueprints and comprehensive test suites. It is part of the **Plinth Template** for teaching on-chain development on Cardano.

## 2. ⚙️ Environment Setup

![image](https://github.com/user-attachments/assets/5e920e6a-4189-4917-b9ad-b31977e0d81b)

![image](https://github.com/user-attachments/assets/92f0a394-d7da-44c6-b15a-9068efe7f4c3)

![image](https://github.com/user-attachments/assets/4793940e-518a-4893-b3f2-1300d488bf65)

Follow these steps to prepare your environment:

```bash
# 1. Enter the Nix shell (requires Nix installed)
nix-shell

# 2. Update Cabal package index
cabal update

# 3. Ensure project dependencies are available
cabal build --enable-tests
```

> **Note:** If you do not use Nix, skip the `nix-shell` step and ensure you have GHC and Cabal installed via the Haskell Platform.

## 3. 📂 Directory Structure

```text
auction/                     # Project root
├── app/                     # Executables for Blueprint generation
│   ├── GenAuctionValidatorBlueprint.hs
│   └── GenMintingPolicyBlueprint.hs
├── src/                     # On-chain library modules
│   └── AuctionValidator.hs
├── test/                    # Test suite files
│   ├── AuctionValidatorSpec.hs            # Unit tests
│   ├── AuctionMintingPolicySpec.hs        # Minting policy tests
│   └── AuctionValidatorProperties.hs      # QuickCheck properties
├── default.nix              # Nix definition (if applicable)
├── shell.nix                # Nix shell entry (if applicable)
├── auction.cabal            # Cabal project configuration
├── cabal.project            # Root project settings
└── cabal.project.local      # Local overrides (e.g., tests: True)
```

## 4. 🛠️ Installation & Build

1. **Enter Nix shell (optional)**:

   ```bash
   nix-shell
   ```
2. **Update Cabal index**:

   ```bash
   cabal update
   ```
3. **Install dependencies & build**:

   ```bash
   cabal build --enable-tests
   ```
4. **Generate Blueprints**:

   ```bash
   cabal run gen-auction-validator-blueprint -- ./blueprint-auction.json
   cabal run gen-minting-policy-blueprint -- ./blueprint-minting.json
   ```

## 5. 🔬 Testing

### Run Unit Tests

```bash
cabal test auction-tests
```

### Run All Tests

```bash
cabal test
```

* **`auction-tests`**: Unit tests for the Auction Validator.
* **`minting-tests`**: Unit tests for the Minting Policy (if configured).

## 6. 🧪 Property-Based Testing

To verify invariants using QuickCheck:

1. Add a QuickCheck test suite entry in your `.cabal`:

   ```cabal
   test-suite auction-properties
     type: exitcode-stdio-1.0
     main-is: AuctionValidatorProperties.hs
     hs-source-dirs: test
     build-depends:
         base >=4.7 && <5,
       , scripts,
       , QuickCheck,
       , plutus-ledger-api,
       , plutus-tx,
       , test-framework
     default-language: Haskell2010
   ```
2. Run the property suite:

   ```bash
   cabal test auction-properties
   ```

## 7. 🚀 Usage

* **Deploy** your compiled Plutus script on a Cardano network by submitting the generated blueprint JSON via your deployment tooling.
* **Customize** `AuctionParams` (seller, currency symbol, token name, minimum bid, end time) in `GenAuctionValidatorBlueprint.hs` before generating the blueprint.
* **Extend** the contract logic in `src/AuctionValidator.hs` and re-run tests to ensure correctness.

## 8. 📖 Glossary

| Term              | Description                                                                        |
| ----------------- | ---------------------------------------------------------------------------------- |
| **Cabal**         | Haskell’s package manager and build tool.                                          |
| **GHC**           | The Glasgow Haskell Compiler.                                                      |
| **Plutus**        | Cardano’s on-chain smart contract platform.                                        |
| **TxInfo**        | Metadata about a transaction passed to a Plutus validator.                         |
| **ScriptContext** | Context for script execution, including `TxInfo` and `ScriptPurpose`.              |
| **AssocMap**      | Plutus’s internal map type for associating keys to values (e.g., Datum, Redeemer). |
| **hspec**         | A behavior-driven testing framework for Haskell.                                   |
| **QuickCheck**    | A property-based testing library for Haskell.                                      |
| **Blueprint**     | JSON representation of a Plutus script and its parameters, for off-chain tooling.  |

---

*Updated by Coxygen Global - Bernard Sibanda*
*Date: 15 September 2025*

