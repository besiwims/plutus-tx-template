```
sellerGetsHighestBid :: Bool
sellerGetsHighestBid = case highestBid of
        Nothing -> True
        Just (Bid _ amt) ->
            case PlutusTx.find
                ( \o ->
                    txOutAddress o
                        PlutusTx.== pubKeyHashAddress (apSeller params)
                        PlutusTx.&& txOutValue o
                        PlutusTx.== lovelaceValue amt
                )
                (txInfoOutputs txInfo) of
                Just _ -> True
                Nothing -> PlutusTx.traceError ("Not found: Output paid to seller")
```
This Haskell code defines a function `sellerGetsHighestBid` that checks whether the highest bid in an auction has been paid to the seller. The function returns a `Bool`, which will be `True` if the seller receives the highest bid, and `False` otherwise. Let's break it down step by step:

### 1. **Function Definition:**
```haskell
sellerGetsHighestBid :: Bool
```
- The function `sellerGetsHighestBid` is of type `Bool`. It will return either `True` or `False` based on certain conditions.

### 2. **Pattern Matching on `highestBid`:**
```haskell
sellerGetsHighestBid = case highestBid of
    Nothing -> True
    Just (Bid _ amt) -> ...
```
- `highestBid` represents the highest bid in the auction, which is presumably of type `Maybe Bid`.
- If `highestBid` is `Nothing` (i.e., no bids were made), the function returns `True` since no bid was made, so no payment is expected.
- If `highestBid` is `Just (Bid _ amt)`, it means there is a valid bid, and `amt` is the bid amount.

### 3. **Finding the Seller's Payment:**
```haskell
case PlutusTx.find
    ( \o ->
        txOutAddress o
            PlutusTx.== pubKeyHashAddress (apSeller params)
        PlutusTx.&& txOutValue o
            PlutusTx.== lovelaceValue amt
    )
    (txInfoOutputs txInfo) of
```
- The function then uses `PlutusTx.find` to search the transaction outputs (`txInfoOutputs txInfo`) to verify if there is an output that corresponds to the payment to the seller.
  
#### Explanation of the Lambda Function:
- `\o -> ...`: This is an anonymous function (lambda) that takes an output `o` and checks two conditions:
    1. **Address Check:**
        ```haskell
        txOutAddress o PlutusTx.== pubKeyHashAddress (apSeller params)
        ```
        This checks if the output address matches the seller's address (`pubKeyHashAddress (apSeller params)`), where `apSeller params` retrieves the public key hash of the seller.
    
    2. **Value Check:**
        ```haskell
        txOutValue o PlutusTx.== lovelaceValue amt
        ```
        This checks if the output's value (`txOutValue o`) equals the amount of the highest bid (`lovelaceValue amt`). In Plutus, values are represented in "lovelace" (smallest unit of Ada).

- The function tries to find an output that satisfies both conditions (paid to the seller and with the correct amount).

### 4. **Result of the Search:**
```haskell
Just _ -> True
Nothing -> PlutusTx.traceError ("Not found: Output paid to seller")
```
- If the search (`PlutusTx.find`) returns `Just _`, meaning it found an output that matches the conditions, then the function returns `True`, indicating the seller received the highest bid.
- If the search returns `Nothing`, it raises an error using `PlutusTx.traceError`, with the message `"Not found: Output paid to seller"`. This means no output matched the conditions, and thus the seller was not paid.

### Summary:
- The function `sellerGetsHighestBid` checks if the seller has received the correct payment (the highest bid).
- It looks through the transaction outputs and verifies:
  - The output is sent to the seller's address.
  - The amount sent matches the highest bid.
- If both conditions are met, the function returns `True`, otherwise, it triggers an error.

- [Back <<< HighestBidderGetsAsset](https://github.com/besiwims/plutus-tx-template/blob/main/highestBidderGetsAsset%20.md)

- [Next >>> RefundPreviousHighestBid](https://github.com/besiwims/plutus-tx-template/blob/main/refundsPreviousHighestBid.md)
