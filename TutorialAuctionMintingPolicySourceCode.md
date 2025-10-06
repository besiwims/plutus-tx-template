**Table of Contents**

1. [🔰 Introduction](#1-introduction)
2. [📋 Prerequisites](#2-prerequisites)
3. [🚀 Starting in ](#3-starting-in-cabal-repl)[`cabal repl`](#3-starting-in-cabal-repl)
4. [📦 Core Data Types](#4-core-data-types)

   * 4.1 [AuctionMintingParams](#41-auctionmintingparams)
   * 4.2 [AuctionMintingRedeemer](#42-auctionmintingredeemer)
5. [🛠️ Writing ](#5-writing-auctiontypedmintingpolicy)[`auctionTypedMintingPolicy`](#5-writing-auctiontypedmintingpolicy)
6. [📜 Compiling the Minting Policy Script](#6-compiling-the-minting-policy-script)
7. [✍️ Writing Unit Tests](#7-writing-unit-tests)

   * 7.1 [Mocking ](#71-mocking-scriptcontext)[`ScriptContext`](#71-mocking-scriptcontext)
   * 7.2 [Example Test Case](#72-example-test-case)
   * 7.3 [Running Tests](#73-running-tests)
8. [🧪 Property-Based Testing](#8-property-based-testing)
9. [🔭 Next Steps](#9-next-steps)
10. [📖 Glossary](#10-glossary)

---

## 1. 🔰 Introduction

This tutorial guides Haskell beginners through creating and testing a Plutus Auction Minting Policy. You’ll learn how to:

* Define on-chain parameters and redeemer types
* Implement `auctionTypedMintingPolicy` logic
* Compile the policy to Plutus Core
* Write unit and property-based tests

## 2. 📋 Prerequisites

* Haskell basics (records, pattern matching)
* GHC and Cabal installed
* Plutus libraries available (via Nix or direct Cabal setup)

## 3. 🚀 Starting in `cabal repl`

1. **Change to project root**:

   ```bash
   cd ~/projects/auction
   ```
2. **Launch REPL**:

   ```bash
   cabal repl
   ```
3. **Load the minting module**:

   ```haskell
   λ> :l src/AuctionMintingPolicy.hs
   [1 of 1] Compiling AuctionMintingPolicy ( src/AuctionMintingPolicy.hs, interpreted )
   Ok, one module loaded.
   ```
4. **Inspect the main function**:

   ```haskell
   λ> :t auctionTypedMintingPolicy
   auctionTypedMintingPolicy :: PubKeyHash -> () -> ScriptContext -> Bool
   ```

## 4. 📦 Core Data Types

### 4.1 AuctionMintingParams

```haskell
-- The parameter is simply the seller's PubKeyHash
type AuctionMintingParams = PubKeyHash
```

### 4.2 AuctionMintingRedeemer

```haskell
type AuctionMintingRedeemer = ()
```

* A unit type, since no extra data is needed to authorize minting.

## 5. 🛠️ Writing `auctionTypedMintingPolicy`

Open `src/AuctionMintingPolicy.hs` and locate:

```haskell
{-# INLINEABLE auctionTypedMintingPolicy #-}
auctionTypedMintingPolicy :: AuctionMintingParams -> AuctionMintingRedeemer -> ScriptContext -> Bool
auctionTypedMintingPolicy pkh _ ctx =
  txSignedBy txInfo pkh PlutusTx.&& mintedExactlyOneToken
  where
    txInfo = scriptContextTxInfo ctx
    mintedExactlyOneToken = case flattenValue (txInfoMint txInfo) of
      [(cs, _tn, q)] ->
         cs PlutusTx.== ownCurrencySymbol ctx PlutusTx.&& q PlutusTx.== 1
      _ -> False
```

**Step-by-step**:

1. **`txSignedBy`**: ensures the seller’s signature is present.
2. **`flattenValue`**: converts minted `Value` to a list of triples.
3. **Pattern match**: exactly one `(currencySymbol, tokenName, quantity)`.
4. **`ownCurrencySymbol`**: checks policy’s own symbol matches.
5. **Quantity check**: must be exactly `1`.

## 6. 📜 Compiling the Minting Policy Script

Below the typed logic you’ll find:

```haskell
auctionMintingPolicyScript :: AuctionMintingParams -> CompiledCode (BuiltinData -> BuiltinData -> PlutusTx.BuiltinUnit)
auctionMintingPolicyScript pkh =
  $$(PlutusTx.compile [|| auctionUntypedMintingPolicy ||])
    `PlutusTx.unsafeApplyCode` PlutusTx.liftCode plcVersion100 pkh
```

* **In REPL**:

  ```haskell
  λ> :browse auctionMintingPolicyScript
  ```

## 7. ✍️ Writing Unit Tests

Create `test/AuctionMintingPolicySpec.hs`:

### 7.1 Mocking `ScriptContext`

```haskell
import qualified PlutusTx.AssocMap as AssocMap
import           PlutusLedgerApi.V2.Contexts ( ScriptContext(..), TxInfo(..), TxOutRef(..), TxId(..) )

mockMintingContext :: ScriptContext
mockMintingContext = ScriptContext
  { scriptContextTxInfo = TxInfo
      { txInfoInputs          = []
      , txInfoReferenceInputs = []
      , txInfoOutputs         = []
      , txInfoFee             = mempty
      , txInfoMint            = singleton cs tn 1
      , txInfoDCert           = []
      , txInfoWdrl            = AssocMap.empty
      , txInfoValidRange      = mempty
      , txInfoSignatories     = []
      , txInfoData            = AssocMap.empty
      , txInfoId              = TxId ""
      , txInfoRedeemers       = AssocMap.empty
      }
  , scriptContextPurpose = Minting (TxOutRef (TxId "") 0)
  }
  where
    cs = ownCurrencySymbol mockMintingContext
    tn = "TOK"
```

### 7.2 Example Test Case

```haskell
import Test.Hspec
import PlutusLedgerApi.V1.Crypto (PubKeyHash(..))

main :: IO ()
main = hspec $
  describe "auctionTypedMintingPolicy" $ do
    it "allows exactly one token minting by seller" $ do
      let pkh = PubKeyHash "seller"
      auctionTypedMintingPolicy pkh () mockMintingContext `shouldBe` True
```

### 7.3 Running Tests

```bash
cabal test minting-tests
```

## 8. 🧪 Property-Based Testing

Example in `test/AuctionMintingPolicyProperties.hs`:

```haskell
import Test.QuickCheck

prop_onlyOne :: PubKeyHash -> Property
prop_onlyOne pkh =
  let ctx = mockMintingContext
  in auctionTypedMintingPolicy pkh () ctx === True

main = quickCheck prop_onlyOne
```

Run:

```bash
cabal test minting-properties
```

## 9. 🔭 Next Steps

* Extend to allow controlled multiple minting with limits.
* Deploy policy on a testnet and test minting transactions.
* Integrate off-chain code to submit minting transactions.

## 10. 📖 Glossary

| Term                    | Definition                                                                |
| ----------------------- | ------------------------------------------------------------------------- |
| **`txSignedBy`**        | Checks a transaction is signed by a given `PubKeyHash`.                   |
| **`flattenValue`**      | Converts a `Value` into a list of `(CurrencySymbol, TokenName, Integer)`. |
| **`ownCurrencySymbol`** | Retrieves the currency symbol for the currently running minting policy.   |
| **`Minting`**           | A `ScriptPurpose` constructor indicating a mint operation on a UTXO.      |
| **`CompiledCode`**      | Wrapper for PlutusTx-compiled on-chain code.                              |
| **`Hspec`**             | Haskell testing framework for behavior-driven development.                |
| **`QuickCheck`**        | Property-based testing library in Haskell.                                |

---
