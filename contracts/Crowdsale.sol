pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
  address private owner;
  uint256 private tokensSold;
  uint256 private crowdSaleBalance;
  uint private startTime;
  uint private endTime;
  uint256 public exchangeRate;
  Token private token;
  Queue public q;

  event PurchaseCompleted(address buyer, bool successful);
  event RefundCompleted(address buyer, bool successful);


  modifier OwnerOnly() {
		if (msg.sender == owner) {_;}
	}


  modifier SaleHasEnded() {
		if (now > startTime) {_;}
	}


  modifier SaleHasNotEnded() {
		if (now <= startTime) {_;}
	}


  function Crowdsale(uint256 _exhangeRate, uint256 totalSupply, uint timeCap) {
    startTime = now;
    endTime = startTime + timeCap;
    owner = msg.sender;
    token = new Token(totalSupply);
    exchangeRate = _exhangeRate;
    q = new Queue();
  }


  function mint(uint256 amount) OwnerOnly() {
    token.mint(amount);
  }


  function burn(uint256 amount) OwnerOnly() returns (bool) {
    if ((token.totalSupply - tokensSold) >= amount) {
      token.totalSupply -= amount;
      return true;
    }
    return false;
  }


  function sell() payable SaleHasNotEnded() returns (bool) {
    uint sellTime = now;
    uint256 tokensPurchased = msg.value * exchangeRate;

    if (tokensPurchased > (totalSupply - tokensSold)) {
      return false;
    }

    q.enqueue(msg.sender);
    uint8 place = q.checkPlace();
    while (place > 1) {
      place = checkPlace();
    }
    assert(q.checkPlace > 0);  // should NEVER happen

    q.checkTime();
    if (q.checkPlace() == 0) {  // timeout
      msg.sender.send(msg.value);  // refund the ether from the purchase
      PurchaseCompleted(msg.sender, false);
      return false;
    }

    bool success = token.transfer(msg.sender, tokensPurchased);
    PurchaseCompleted(msg.sender, success);
    return success;
  }


  function refund(uint256 amount) SaleHasNotEnded() returns (bool) {
    success = token.refund(msg.sender, amount);
    if (success) {
      success = msg.sender.send(amount);
    }
    RefundCompleted(msg.sender, success);
    return success;
  }


  function receiveFunds() SaleHasEnded() OwnerOnly() returns (bool) {
    return owner.send(crowdSaleBalance);
  }
}
