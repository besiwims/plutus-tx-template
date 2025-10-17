{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module AuctionTypes where

import GHC.Generics (Generic)
import Data.Aeson (FromJSON, ToJSON)
import PlutusTx (makeIsData, makeLift)
import PlutusTx.Prelude
import Ledger (PubKeyHash, POSIXTime, CurrencySymbol, TokenName, Value)

-- | Parameters for starting an auction
data AuctionParams = AuctionParams
    { apSeller      :: PubKeyHash
    , apDeadline    :: POSIXTime
    , apMinBid      :: Integer
    , apCurrency    :: CurrencySymbol
    , apToken       :: TokenName
    } deriving (Show, Generic, FromJSON, ToJSON)

makeIsData ''AuctionParams
makeLift ''AuctionParams

-- | Datum for the auction UTXO
data AuctionDatum = AuctionDatum
    { adHighestBidder :: Maybe PubKeyHash
    , adHighestBid    :: Integer
    , adDeadline      :: POSIXTime
    } deriving (Show, Generic, FromJSON, ToJSON)

makeIsData ''AuctionDatum
makeLift ''AuctionDatum

-- | Redeemer for the auction actions
data AuctionAction = Bid | Close
    deriving (Show, Generic, FromJSON, ToJSON)

makeIsData ''AuctionAction
makeLift ''AuctionAction