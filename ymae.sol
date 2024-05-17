// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1.  Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2. Transferring tokens: Players should be able to transfer their tokens to others.
3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
4. Checking token balance: Players should be able to check their token balance at any time.
5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenGamingToken is ERC20, Ownable {
    mapping(address => bool) public authorizedRedeemers;

    event Redeemed(address indexed account, uint256 amount);
    event TokensBurned(address indexed account, uint256 amount);

    constructor() ERC20("DegenGamingToken", "DGT") Ownable(msg.sender) {
        // The owner will be the deployer of the contract
    }

    // Minting function - only owner can mint
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Redeeming tokens - only authorized accounts can redeem
    function redeem(address account, uint256 amount) external {
        require(authorizedRedeemers[msg.sender], "Not authorized to redeem");
        _burn(account, amount);
        emit Redeemed(account, amount);
    }

    // Function to add or remove authorized redeemers
    function setAuthorizedRedeemer(address redeemer, bool authorized) external onlyOwner {
        authorizedRedeemers[redeemer] = authorized;
    }

    // Burn tokens - anyone can burn their own tokens
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
}

