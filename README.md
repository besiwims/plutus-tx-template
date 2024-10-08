# This is a rapid Plutus Application Development (rPAD-Pheidippides) project. This is intended to be for new developers.

**Aim:** To promote rapid, easy learning, simplification, and development on Cardano. Just like a greek messanger Pheidippides, who ran to deliver good news of victory, rPAD aims to quickly deliver quick dApps to Cardano communities.
![alt text](WhatsApp_Image_2024-09-09_at_14.38.56-removebg-preview.png)

**Author:** Bernard Sibanda (Intersect Developer Advocate). You can contact him via Discord: `#wims5274` or email: `cto@wims.io`.

**Date:** 09-09-2024

![image](https://github.com/user-attachments/assets/81636f94-ae64-401e-bbcc-296e000020e1)


## 1. Plutus Tx Template: English Auction Demo Example

Welcome to the Plutus Tx Template repository! The purpose of this template is to help both new and experienced developers get started quickly with real-life Plutus smart contract development.

## 2. Fork the Repository

You can find the repository here: [Plutus Tx Template GitHub](https://github.com/besiwims/plutus-tx-template/tree/dev)

## 3. Set Up Your Development Environment Quickly: GitHub Codespaces

To set up the development environment:

1. Look for the green button in the top right that says `Use this template`. 
2. Click it and select "Open in a Codespace." You will need a GitHub account. 

If you don’t have one, use this link to create an account: [GitHub Help](https://coxygen.co/user-help/github/)

Note: VS Code might prompt you to install the GHCI extension. Follow the instructions to install it.

## 4. Writing the On-Chain Plutus Validator (English Auction Example)

In `Main.hs`, the `main` function performs two tasks:

- Instantiates the validator by providing the `AuctionParams` for a specific auction.
- Serializes the instantiated validator and writes it to a file.

### Steps:

**a)** Replace `apSeller` with the seller's wallet address.  
Example: Preproduction  
`addr_test1qpy74jhr809t5xnya9q0dz6wy7rzpkwuq6k6fj8dw7eekntgea2499mfs2u6cn3wqgplpl8zchatgvqn4j73ew9lf8dqfz2xp9`

If you're unsure how to install the Nami preproduction wallet, refer to the following documentation:  
[Nami Wallet Help](https://github.com/wimsio/coxygen/wiki/3.-Nami-Wallet-on-Chrome-browser-by-Mugdor-Mary-29%E2%80%9004%E2%80%902024)

**b)** Replace `apEndTime` with your desired [POSIXTime] (e.g., 1725875446). Use this service to convert your desired time:  
[Epoch Converter](https://www.epochconverter.com/)

Steps:
1. Open the link above.
2. Adjust the desired end date.
3. Click the `Human date to Timestamp` button.
4. Copy the generated Epoch timestamp (e.g., 1725875446) and paste it into the `Main.hs` file located in the app directory of this project.

## 5. Build the Project

To build the project, open the VS Code terminal. You can do this from the top left menu (`Menu > File > Terminal > New Terminal`) or by using the shortcut `Ctrl + Shift + `.

Run the following commands in the terminal:

```bash
a) cabal build plutus-tx-template
b) cabal exec plutus-tx-template
```

## 6. Linux Commands for Beginners

You'll need to navigate and run commands using a terminal. If you're unfamiliar with basic Linux commands, check out this cheat sheet:  
[Linux Commands Cheat Sheet](https://www.geeksforgeeks.org/linux-commands-cheat-sheet/)

If everything runs successfully, the serialized validator will be written to `validator.uplc`.

Congratulations, you've successfully created a Plutus validator script!

## 7. Project detailed explanation : Sections below explain the structure of the plutus project: the app/AuctionValidator.hs in an easy way.

[2. Explanation of haskell language extentions.md](https://github.com/besiwims/plutus-tx-template/blob/main/2.%20Explanation%20of%20haskell%20language%20extentions.md)

[3. Module name and import section.md](https://github.com/besiwims/plutus-tx-template/blob/main/3.%20Module%20name%20and%20import%20section.md)

[4. Data and types of Haskell.md](https://github.com/besiwims/plutus-tx-template/blob/main/4.%20Data%20and%20types%20of%20Haskell.md)

[5. Functions and helper functions.md](https://github.com/besiwims/plutus-tx-template/blob/main/5.%20Functions%20and%20helper%20functions.md)

[5. a) highestBidderGetsAsset.md](https://github.com/besiwims/plutus-tx-template/blob/main/highestBidderGetsAsset%20.md)

[5. b) sellerGetsHighestBid.md](https://github.com/besiwims/plutus-tx-template/blob/main/sellerGetsHighestBid.md)

[5. c) refundsPreviousHighestBid.md_](https://github.com/besiwims/plutus-tx-template/blob/main/refundsPreviousHighestBid.md_)

[5. d) correctNewDatum.md](https://github.com/besiwims/plutus-tx-template/blob/main/correctNewDatum.md)

[WHERE TO FROM HERE >>> ] (https://github.com/besiwims/plutus-tx-template/wiki/Home-:-Plutus)
