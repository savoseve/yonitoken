// SPDX-License-Identifier: MIT
/*
You send BNB to this contract to receive Yoni token
and Yoni token will use to receive a token that has more value
You will send 1 Yoni to another token contract to receive (x*1) other token.
*/
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract YoniToken is ERC20,ERC20Snapshot,ERC20Burnable,Ownable,Pausable  {
    
    address private tokenOwner;         // the owner of the token    
    // constructor will only be invoked during contract 

    constructor() ERC20("Echo Yoni", "YONI") {
        tokenOwner = msg.sender;       // address of the token owner        
        uint256 n = 7000000000000000000000000000000;
        // mint the tokens
        _mint(msg.sender, n * 10**uint(decimals()));    
    }
      uint256 private unitsOneEthCanBuy =100;// rand();
     // this function is called when someone sends ether to the 
    // token contract
    receive() external payable {        
        // msg.value (in Wei) is the ether sent to the 
        // token contract
        // msg.sender is the account that sends the ether to the 
        // token contract        // amount is the token bought by the sender
        uint256 amount = msg.value * unitsOneEthCanBuy; // ensure you have enough tokens to sell
        require(balanceOf(tokenOwner) >= amount, "Not enough tokens"); // transfer the token to the buyer
        _transfer(tokenOwner, msg.sender, amount);        // emit an event to inform of the transfer        
        emit Transfer(tokenOwner, msg.sender, amount);
        
        // send the ether earned to the token owner
        payable(tokenOwner).transfer(msg.value);
        
    }
    function SetEthCanBuy(uint256 _amount) external onlyOwner {
        unitsOneEthCanBuy = _amount;
    }

    function OneEthCanBuy() external view returns (uint256){
        return unitsOneEthCanBuy;
    }

    function snapshot() public onlyOwner {
        _snapshot();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
function mint(address to, uint256 amount) public  onlyOwner {
    //require(!paused, 'The contract is paused!');
        _mint(to, amount);
    }


}
