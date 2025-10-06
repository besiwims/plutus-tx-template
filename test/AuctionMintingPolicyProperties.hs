import Test.QuickCheck
import AuctionMintingPolicy

property_oneTokenMinted :: PubKeyHash -> Property
property_oneTokenMinted pkh = 
    let redeemer = ()
        context = mockMintingScriptContext
    in auctionTypedMintingPolicy pkh redeemer context ==> 
        mintedExactlyOneToken context

main :: IO ()
main = quickCheck property_oneTokenMinted

