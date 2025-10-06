**Table of Contents**

1. [📦 Environment Setup](#1-environment-setup)
2. [📂 Project Structure](#2-project-structure)
3. [🛠️ Writing the Auction Validator](#3-writing-the-auction-validator)
4. [✍️ Writing Unit Tests](#4-writing-unit-tests)
5. [🔬 Mocking ScriptContext](#5-mocking-scriptcontext)
6. [✅ Running Tests](#6-running-tests)
7. [🧪 Property-Based Testing](#7-property-based-testing)
8. [📖 Glossary](#8-glossary)

--checked 15-09-2025

---

# 1. 📦 Environment Setup

Before diving into code, ensure your development environment is configured properly:

* **GHC & Cabal**: Install [GHC](https://www.haskell.org/ghc/) and [Cabal](https://www.haskell.org/cabal/) via the Haskell Platform.
* **Plutus Dependencies**: Clone and follow the Plutus repository instructions for setting up the Plutus libraries (`plutus-ledger-api`, `plutus-tx`, etc.).
* **Directory**: Navigate to your project root, e.g. `~/projects/auction`.

*Commands:*

```bash
# Update package index
cabal update

# Ensure Cabal project is initialized
cabal init --non-interactive --minimal
```

# 2. 📂 Project Structure

Organize your files as follows:

```text
auction/           # Project root
├── app/           # Blueprint generator executables
│   ├── GenAuctionValidatorBlueprint.hs
│   └── GenMintingPolicyBlueprint.hs
├── src/           # On-chain library modules
│   └── AuctionValidator.hs
├── test/          # Test suite files
│   ├── AuctionValidatorSpec.hs
│   ├── AuctionMintingPolicySpec.hs
│   └── AuctionValidatorProperties.hs
├── auction.cabal  # Cabal configuration
├── cabal.project  # Project-level settings
└── cabal.project.local  # Local overrides (e.g., tests: True)
```

Ensure the `.cabal` file defines both executables and test suites:

```cabal
executable gen-auction-validator-blueprint
  hs-source-dirs: app
  main-is: GenAuctionValidatorBlueprint.hs
  build-depends: base, plutus-ledger-api, plutus-tx, scripts

test-suite auction-tests
  type: exitcode-stdio-1.0
  main-is: AuctionValidatorSpec.hs
  hs-source-dirs: test
  build-depends:
    base >=4.7 && <5,
    scripts,
    hspec,
    QuickCheck,
    plutus-ledger-api,
    plutus-tx,
    test-framework
  default-language: Haskell2010
```

# 3. 🛠️ Writing the Auction Validator

Your on-chain code lives in `src/AuctionValidator.hs`. Key points:

1. **Parameters & Datum**: Define `AuctionParams`, `AuctionDatum`, `AuctionRedeemer`.
2. **Typed Validator**: Implement `auctionTypedValidator` with `NewBid` and `Payout` branches.
3. **Compilation**: Use Template Haskell to compile into `auctionValidatorScript`.

Example snippet:

```haskell
{-# INLINEABLE auctionTypedValidator #-}
auctionTypedValidator :: AuctionParams -> AuctionDatum -> AuctionRedeemer -> ScriptContext -> Bool
auctionTypedValidator params (AuctionDatum mb) redeemer ctx = ...
```

# 4. ✍️ Writing Unit Tests

Create `test/AuctionValidatorSpec.hs`:

```haskell
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Test.Hspec
import AuctionValidator
import PlutusLedgerApi.V1.Crypto (PubKeyHash(..))
import PlutusLedgerApi.V1 (Lovelace(..))
import PlutusLedgerApi.V1.Interval (always)
import PlutusLedgerApi.V2 (CurrencySymbol(..), TokenName(..), ScriptContext(..), TxInfo(..))
import PlutusLedgerApi.V2.Contexts (ScriptPurpose(..), TxOutRef(..), TxId(..))
import qualified PlutusTx.AssocMap as AssocMap

-- Mock context with empty fields:
mockScriptContext :: ScriptContext
mockScriptContext = ScriptContext { scriptContextTxInfo = TxInfo { txInfoInputs = []
                                                                   , txInfoReferenceInputs = []
                                                                   , txInfoOutputs = []
                                                                   , txInfoFee     = mempty
                                                                   , txInfoMint    = mempty
                                                                   , txInfoDCert   = []
                                                                   , txInfoWdrl    = AssocMap.empty
                                                                   , txInfoValidRange = always
                                                                   , txInfoSignatories = []
                                                                   , txInfoData    = AssocMap.empty
                                                                   , txInfoId      = TxId ""
                                                                   , txInfoRedeemers = AssocMap.empty }
                                    , scriptContextPurpose = Spending (TxOutRef (TxId "") 0) }

main :: IO ()
main = hspec $
  describe "auctionTypedValidator" $ do
    it "rejects NewBid with empty context" $ do
      let params = AuctionParams (PubKeyHash "seller") (CurrencySymbol "") (TokenName "TOK") (Lovelace 100) 1620000000000
          datum = AuctionDatum Nothing
          redeemer = NewBid (Bid "addr" (PubKeyHash "bidder") (Lovelace 150))
      auctionTypedValidator params datum redeemer mockScriptContext `shouldBe` False
```

# 5. 🔬 Mocking ScriptContext

A complete `TxInfo` has many fields. For unit tests, stub them out:

* Use `AssocMap.empty` for maps.
* `mempty` for monoidal fields (`txInfoFee`, `txInfoMint`).
* `always` for validity.
* `Spending (TxOutRef (TxId "") 0)` for purpose.

This minimalist context lets you test branches without a full ledger.

# 6. ✅ Running Tests

Execute:

```bash
cabal clean
cabal update
cabal build --enable-tests
cabal test
```

* **Unit tests** pass for invalid contexts.
* Add more `it` blocks to cover other branches (first bid, refund, payout).

# 7. 🧪 Property-Based Testing

Use QuickCheck for properties. Example in `test/AuctionValidatorProperties.hs`:

```haskell
import Test.QuickCheck
import AuctionValidator

instance Arbitrary Bid where
  arbitrary = Bid <$> arbitrary <*> arbitrary <*> (Lovelace <$> arbitrary `suchThat` (>=1))

prop_newBidOverride :: Bid -> Bid -> Property
prop_newBidOverride old new = bAmount new > bAmount old ==>
  let params = AuctionParams ...
      datum  = AuctionDatum (Just old)
      ctx    = mockScriptContext
  in auctionTypedValidator params datum (NewBid new) ctx === False

main = quickCheck prop_newBidOverride
```

Add a second test suite in `.cabal` if desired.

# 8. 📖 Glossary

| Term              | Definition                                                                                   |
| ----------------- | -------------------------------------------------------------------------------------------- |
| **Cabal**         | Haskell’s package manager and build tool.                                                    |
| **GHC**           | The Glasgow Haskell Compiler.                                                                |
| **Plutus**        | Smart contract platform for Cardano, includes `plutus-ledger-api`, `plutus-tx`, etc.         |
| **TxInfo**        | Transaction metadata passed to on-chain validators.                                          |
| **ScriptContext** | Full context for on-chain script evaluation, includes `TxInfo` and `ScriptPurpose`.          |
| **AssocMap**      | Internal map type used by Plutus for associating keys to values in contexts (`Datum`, etc.). |
| **Hspec**         | Haskell testing framework for behavior‐driven development.                                   |
| **QuickCheck**    | Library for property‐based testing in Haskell.                                               |
