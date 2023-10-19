what happens if you send an ERC721 NFT to a smart contract:

The ERC721 safeTransferFrom() or transferFrom() function is called to initiate the NFT transfer to the contract address.
The ERC721 contract checks if the recipient contract implements the ERC721TokenReceiver interface. This is done by checking if the contract has the onERC721Received() function.
The ERC721 contract then calls onERC721Received() on the recipient contract and passes the from, to, tokenId and data parameters.
The recipient contract runs the code in its onERC721Received() implementation. This is where any logic to handle the NFT receipt goes.
The onERC721Received() function must return the specific magic value of 0x150b7a02, otherwise the transaction will revert.
If onERC721Received() returns the magic value, the NFT transfer is considered successful. The NFT is transferred from the sender to the recipient contract's address.
The recipient contract now has ownership of the NFT and can trigger any further logic like emitting events, sending the NFT to other contracts, putting it up for sale etc.
So in summary, the ERC721 makes sure the recipient is able to handle ERC721 tokens by checking for the onERC721Received() function. The recipient contract defines custom transfer logic in onERC721Received(). This allows contracts to securely trade NFTs.

// We can encode Json objects the same way we encoded SCg objects
