{-# LANGUAGE OverloadedStrings #-}

import Test.QuickCheck
import AuctionValidator

instance Arbitrary Bid where
    arbitrary = do
        addr <- arbitrary
        pkh <- arbitrary
        amt <- arbitrary `suchThat` (> 0)  -- Ensure the bid amount is positive
        return $ Bid addr pkh amt

property_newBidHigherThanPrevious :: Bid -> Bid -> Property
property_newBidHigherThanPrevious previousBid newBid = 
    let params = AuctionParams "seller" "currencySymbol" "MY_TOKEN" 100 1725227091000
        datum = AuctionDatum (Just previousBid)
        redeemer = NewBid newBid
        context = mockScriptContext
    in (bAmount newBid > bAmount previousBid) ==> 
        auctionTypedValidator params datum redeemer context

main :: IO ()
main = quickCheck property_newBidHigherThanPrevious

