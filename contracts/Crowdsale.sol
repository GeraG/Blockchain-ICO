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

  modifier OwnerOnly() {
		if (msg.sender == owner) {_;}
	}

  function Crowdsale(uint256 _exhangeRate, uint256 totalSupply, uint timeCap) {
    startTime = now;
    endTime = startTime + timeCap;
    owner = msg.sender;
    token = new Token(totalSupply);
    exchangeRate = _exhangeRate;
    q = new Queue();
  }

  function mint(uint256 amount) OwnerOnly() returns (bool) {
    token.totalSupply += amount;
    return true;
  }

  function burn(uint256 amount) OwnerOnly() returns (bool) {
    token.totalSupply -= amount;
    return true;
  }

  function sell() payable returns (bool) {
    // TODO
  }

  function refund() returns (bool) {
    // TODO
  }
}
