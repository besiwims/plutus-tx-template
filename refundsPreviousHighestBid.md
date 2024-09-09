```haskell
refundsPreviousHighestBid :: Bool
refundsPreviousHighestBid = case highestBid of
    Nothing -> True 
    Just (Bid bidder amt) ->
        case PlutusTx.find
            ( \o ->
                txOutAddress o
                    PlutusTx.== pubKeyHashAddress bidder
                    PlutusTx.&& txOutValue o
                    PlutusTx.== lovelaceValue amt
            )
            (txInfoOutputs txInfo) of
            Just _ -> True
            Nothing -> PlutusTx.traceError ("Not found: refund output")
```

### Explanation

1. **Type Declaration**
   - `refundsPreviousHighestBid :: Bool`: This specifies that `refundsPreviousHighestBid` is a function returning a `Bool` (a Boolean value).

2. **Function Definition**
   - `refundsPreviousHighestBid = ...`: This is the definition of the function `refundsPreviousHighestBid`.

3. **Pattern Matching on `highestBid`**
   - `case highestBid of ...`: This is a case expression used to handle different possibilities for `highestBid`.
   - If `highestBid` is `Nothing`, the function returns `True`, indicating that there's no previous highest bid to refund, and thus the condition is trivially satisfied.

4. **Handling a Present Highest Bid**
   - If `highestBid` is `Just (Bid bidder amt)`, it means there was a previous highest bid with `bidder` and amount `amt`.
   - The code then checks if there is a corresponding refund output in the transaction.

5. **Finding the Refund Output**
   - `PlutusTx.find`: This function is used to search through the list of transaction outputs (`txInfoOutputs txInfo`) to find one that matches the specified condition.
   - The condition being checked is whether the output address and value match the expected values for the refund:
     - `txOutAddress o PlutusTx.== pubKeyHashAddress bidder`: Checks if the address of the output matches the public key hash of the bidder.
     - `txOutValue o PlutusTx.== lovelaceValue amt`: Checks if the value of the output matches the amount of lovelace (`amt`) expected.
   - If such an output is found (`Just _`), the function returns `True`, indicating the refund was found.

6. **Handling Refund Not Found**
   - If no matching output is found (`Nothing`), it triggers an error with the message `"Not found: refund output"` using `PlutusTx.traceError`.

### Summary

- The function `refundsPreviousHighestBid` determines if a refund for the highest bid is present in the transaction.
- It returns `True` if there was no previous highest bid (`Nothing`) or if a matching refund output is found.
- It triggers an error if the expected refund output is not found.

This function is typically used in Plutus smart contracts to ensure that a refund has been correctly included in a transaction when needed.

[Back <<< SellerGetHighestBid](https://github.com/besiwims/plutus-tx-template/blob/main/sellerGetsHighestBid.md)

[Next >>> CorrectNewDatum](https://github.com/besiwims/plutus-tx-template/blob/main/correctNewDatum.md)
