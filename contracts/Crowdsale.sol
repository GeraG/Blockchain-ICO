pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
  address public owner;
  uint256 public tokensSold;
  uint256 public crowdSaleBalance;
  uint public startTime;
  uint public endTime;
  uint256 public exchangeRate;
  Token private token;
  Queue private q;

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
    endTime = SafeMath.add(startTime, timeCap);
    owner = msg.sender;
    token = new Token(totalSupply);
    exchangeRate = _exhangeRate;
    q = new Queue();
    tokensSold = 0;
    crowdSaleBalance = 0;
  }


  function weiToDragonGlass(uint256 amountInWei) returns (uint256) {
    return SafeMath.mul(amountInWei, exchangeRate);
  }


  function dragonGlassToWei(uint256 amountInDG) returns (uint256) {
    return SafeMath.div(amountInDG, exchangeRate);
  }


  function mint(uint256 amount) OwnerOnly() {
    token.mint(amount);
  }


  function burn(uint256 amount) OwnerOnly() returns (bool) {
    return token.burn(amount);
  }


  function sell() payable SaleHasNotEnded() returns (bool) {
    uint256 tokensPurchased = weiToDragonGlass(msg.value);

    if (tokensPurchased > (token.totalSupply() - tokensSold)) {
      return false;
    }

    q.enqueue(msg.sender);
    while (q.checkPlace() > 1) {  // wait until first in line
      continue;
    }
    assert(q.checkPlace() > 0);  // should NEVER happen

    q.checkTime();
    if (q.checkPlace() == 0) {  // timeout. should already be dequeued now
      assert(msg.sender.send(msg.value));  // refund ether (should always pass!)
      PurchaseCompleted(msg.sender, false);
      return false;
    }

    while (q.qsize() < 1) {  // wait until at least 2 nodes in the queue
      continue;
    }
    q.dequeue();
    bool success = token.transfer(msg.sender, tokensPurchased);
    if (success) {
      crowdSaleBalance = SafeMath.add(crowdSaleBalance, msg.value);
      tokensSold = SafeMath.add(tokensSold, tokensPurchased);
    }
    PurchaseCompleted(msg.sender, success);
    return success;
  }


  function refund(uint256 amount) SaleHasNotEnded() returns (bool) {
    bool success = token.refund(msg.sender, amount);
    if (success) {
      tokensSold = SafeMath.sub(tokensSold, amount);
      uint256 refundInWei = dragonGlassToWei(amount);
      success = msg.sender.send(refundInWei);
      if (success) {
        crowdSaleBalance = SafeMath.sub(crowdSaleBalance, refundInWei);
      }
    }
    RefundCompleted(msg.sender, success);
    return success;
  }


  function receiveFunds() SaleHasEnded() OwnerOnly() returns (bool) {
    bool success = owner.send(crowdSaleBalance);
    if (success) {
      crowdSaleBalance = 0;
    }
    return success;
  }
}
