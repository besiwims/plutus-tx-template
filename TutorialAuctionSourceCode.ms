**Table of Contents**

1. [🔰 Introduction](#1-introduction)
2. [📋 Prerequisites](#2-prerequisites)
3. [🚀 Starting in `cabal repl`](#3-starting-in-cabal-repl)
4. [📦 Core Data Types](#4-core-data-types)

   * 4.1 [AuctionParams](#41-auctionparams)
   * 4.2 [AuctionDatum](#42-auctiondatum)
   * 4.3 [AuctionRedeemer](#43-auctionredeemer)
5. [🛠️ Writing `auctionTypedValidator`](#5-writing-auctiontypedvalidator)

   * 5.1 [Matching on `NewBid`](#51-matching-on-newbid)
   * 5.2 [Matching on `Payout`](#52-matching-on-payout)
6. [📜 Compiling the Validator Script](#6-compiling-the-validator-script)
7. [✍️ Writing Unit Tests](#7-writing-unit-tests)

   * 7.1 [Mocking `ScriptContext`](#71-mocking-scriptcontext)
   * 7.2 [Example Test Case](#72-example-test-case)
   * 7.3 [Running Tests](#73-running-tests)
8. [🧪 Property-Based Testing](#8-property-based-testing)
9. [🔭 Next Steps](#9-next-steps)
10. [📖 Glossary](#10-glossary)

---

## 1. 🔰 Introduction

This tutorial walks Haskell beginners through building and testing a Plutus Auction Validator smart contract. You’ll learn:

* Defining on-chain data types
* Writing validation logic in `auctionTypedValidator`
* Compiling to Plutus Core
* Unit and property-based testing

By the end, you’ll be comfortable loading modules in `cabal repl`, stepping through code, and verifying behavior.

## 2. 📋 Prerequisites

* Basic Haskell knowledge (records, pattern matching)
* [GHC](https://www.haskell.org/ghc/) and [Cabal](https://www.haskell.org/cabal/) installed
* Plutus libraries available (via Nix or direct Cabal setup)

## 3. 🚀 Starting in `cabal repl`

1. **Enter your project directory**:

   ```bash
   cd ~/projects/auction
   ```
2. **Launch the REPL**:

   ```bash
   cabal repl
   ```
3. **Load the validator module**:

   ```haskell
   λ> :l src/AuctionValidator.hs
   [1 of 1] Compiling AuctionValidator ( src/AuctionValidator.hs, interpreted )
   Ok, one module loaded.
   ```
4. **Inspect a type**:

   ```haskell
   λ> :t auctionTypedValidator
   auctionTypedValidator :: AuctionParams -> AuctionDatum -> AuctionRedeemer -> ScriptContext -> Bool
   ```

## 4. 📦 Core Data Types

### 4.1 AuctionParams

```haskell
data AuctionParams = AuctionParams
  { apSeller         :: PubKeyHash   -- ^ Seller's public key hash
  , apCurrencySymbol :: CurrencySymbol -- ^ Minting policy hash
  , apTokenName      :: TokenName    -- ^ Name of the token
  , apMinBid         :: Lovelace     -- ^ Minimum bid amount
  , apEndTime        :: POSIXTime    -- ^ Auction closing time
  }
```

* **Step**: In REPL, view fields:

  ```haskell
  λ> :i AuctionParams
  ```

### 4.2 AuctionDatum

```haskell
newtype AuctionDatum = AuctionDatum { adHighestBid :: Maybe Bid }
```

* Holds `Nothing` (no bids) or `Just Bid` (highest bid so far).

### 4.3 AuctionRedeemer

```haskell
data AuctionRedeemer = NewBid Bid | Payout
```

* **`NewBid`**: Places a new bid.
* **`Payout`**: Closes the auction and distributes funds.

## 5. 🛠️ Writing `auctionTypedValidator`

This function enforces auction rules. It has type:

```haskell
auctionTypedValidator
  :: AuctionParams -> AuctionDatum -> AuctionRedeemer -> ScriptContext -> Bool
```

### 5.1 Matching on `NewBid`

```haskell
case redeemer of
  NewBid bid ->
    and [ sufficientBid bid
        , validBidTime
        , refundsPreviousHighestBid
        , correctOutput bid
        ]
```

* **`sufficientBid`**: New bid > previous (or ≥ minimum if first)
* **`validBidTime`**: Within `apEndTime`.
* **`refundsPreviousHighestBid`**: Returns lovelace to prior bidder.
* **`correctOutput`**: New output datum + correct token+lovelace bundle.

### 5.2 Matching on `Payout`

```haskell
  Payout ->
    and [ validPayoutTime
        , sellerGetsHighestBid
        , highestBidderGetsAsset
        ]
```

* **`validPayoutTime`**: After `apEndTime`.
* **`sellerGetsHighestBid`**: Seller receives the funds.
* **`highestBidderGetsAsset`**: Winner gets the token (or seller if none).

## 6. 📜 Compiling the Validator Script

In `src/AuctionValidator.hs` you’ll find:

```haskell
auctionValidatorScript :: AuctionParams -> CompiledCode ...
auctionValidatorScript params = $$(PlutusTx.compile [|| auctionUntypedValidator ||])
                             `PlutusTx.unsafeApplyCode` PlutusTx.liftCode plcVersion100 params
```

* **In REPL**:

  ```haskell
  λ> :l src/AuctionValidator.hs
  λ> :browse auctionValidatorScript
  ```

## 7. ✍️ Writing Unit Tests

Tests live in `test/AuctionValidatorSpec.hs`.

### 7.1 Mocking `ScriptContext`

```haskell
import qualified PlutusTx.AssocMap as AssocMap

mockScriptContext :: ScriptContext
mockScriptContext = ScriptContext
  { scriptContextTxInfo = TxInfo
      { txInfoInputs          = []
      , txInfoReferenceInputs = []
      , txInfoOutputs         = []
      , txInfoFee             = mempty
      , txInfoMint            = mempty
      , txInfoDCert           = []
      , txInfoWdrl            = AssocMap.empty
      , txInfoValidRange      = always
      , txInfoSignatories     = []
      , txInfoData            = AssocMap.empty
      , txInfoId              = TxId ""
      , txInfoRedeemers       = AssocMap.empty
      }
  , scriptContextPurpose   = Spending (TxOutRef (TxId "") 0)
  }
```

### 7.2 Example Test Case

```haskell
it "rejects NewBid with empty context" $ do
  let params = AuctionParams (PubKeyHash "seller") (CurrencySymbol "") (TokenName "TOK") (Lovelace 100) 1620000000000
      datum = AuctionDatum Nothing
      redeemer = NewBid (Bid "a" (PubKeyHash "b") (Lovelace 150))
  auctionTypedValidator params datum redeemer mockScriptContext `shouldBe` False
```

### 7.3 Running Tests

```bash
cabal test auction-tests
```

## 8. 🧪 Property-Based Testing

Use QuickCheck in `test/AuctionValidatorProperties.hs`:

```haskell
import Test.QuickCheck

instance Arbitrary Bid where
  arbitrary = Bid <$> arbitrary <*> arbitrary <*> (Lovelace <$> arbitrary `suchThat` (>0))

prop_higherBid :: Bid -> Bid -> Property
prop_higherBid old new = bAmount new > bAmount old ==>
  let params = AuctionParams ...
      ctx = mockScriptContext
  in auctionTypedValidator params (AuctionDatum (Just old)) (NewBid new) ctx === False

main = quickCheck prop_higherBid
```

Run with:

```bash
cabal test auction-properties
```

## 9. 🔭 Next Steps

* Extend tests: first‐bid acceptance, refund checks, payout flows.
* Instantiate on a local Cardano testnet.
* Integrate off‐chain endpoints and CLI.

## 10. 📖 Glossary

| Term                 | Definition                                                                     |
| -------------------- | ------------------------------------------------------------------------------ |
| **REPL**             | Read–eval–print loop, interactive shell (`cabal repl`).                        |
| **Record**           | Haskell data structure with named fields (e.g., `AuctionParams`).              |
| **Pattern Matching** | Checking a value against a pattern (e.g., `case redeemer of NewBid bid -> …`). |
| **CompiledCode**     | PlutusTx wrapper for on-chain code after compilation.                          |
| **`mempty`**         | The identity element for a Monoid, e.g., empty fees, empty maps.               |
| **`AssocMap`**       | Plutus’s Map type used for scripts (e.g., `txInfoData`, `txInfoRedeemers`).    |
| **`QuickCheck`**     | Library for property‐based testing in Haskell.                                 |
| **`Hspec`**          | Behavior‐driven unit testing framework for Haskell.                            |
| **`Spending`**       | A `ScriptPurpose` constructor indicating a spend of a UTXO (with `TxOutRef`).  |

---

