-- NFTMarketPlace.hs
module NFTMarketPlace 
  ( NFT(..)
  , Listing(..)
  , sell
  , cancel
  ) where

-- | Represent a Non-Fungible Token (NFT) by its ID and metadata
data NFT = NFT
  { nftId      :: Int
  , nftName    :: String
  , nftCreator :: String
  } deriving (Show, Eq)

-- | Represent a Listing in the marketplace
data Listing = Listing
  { listingNFT   :: NFT
  , price        :: Int        -- price in some currency units (e.g., ADA, USD, etc.)
  , isActive     :: Bool
  } deriving (Show, Eq)


-- | Function to sell an NFT (creates a new listing)
--   Input: NFT and price
--   Output: Listing (active = True)
sell :: NFT -> Int -> Listing
sell token p = Listing 
  { listingNFT = token
  , price = p
  , isActive = True
  }


-- | Function to cancel a listing
--   Input: Listing
--   Output: Listing (active = False)
cancel :: Listing -> Listing
cancel listing = listing { isActive = False }
