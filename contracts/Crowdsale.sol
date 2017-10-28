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
    endTime = SafeMath.add(startTime, timeCap);
    owner = msg.sender;
    token = new Token(totalSupply);
    exchangeRate = _exhangeRate;
    q = new Queue();
  }


  function mint(uint256 amount) OwnerOnly() {
    token.mint(amount);
  }


  function burn(uint256 amount) OwnerOnly() returns (bool) {
    return token.burn(amount);
  }


  function sell() payable SaleHasNotEnded() returns (bool) {
    uint256 tokensPurchased = SafeMath.mul(msg.value, exchangeRate);

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
      uint256 refundInWei = SafeMath.div(amount, exchangeRate);
      success = msg.sender.send(refundInWei);
      if (success) {
        crowdSaleBalance = SafeMath.sub(crowdSaleBalance, refundInWei);
      }
    }
    RefundCompleted(msg.sender, success);
    return success;
  }


  function receiveFunds() SaleHasEnded() OwnerOnly() returns (bool) {
    return owner.send(crowdSaleBalance);
  }
}
