pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
    /// total amount of tokens
    uint256 public totalSupply;


    struct Approval {
        address spender;
        uint256 amount;
    }

    address public owner;
    mapping(address => uint256) private balances;
    mapping(address => Approval[]) private approvals;


    function Token(uint256 _totalSupply) {
        owner = msg.sender;
        totalSupply = _totalSupply;
    }

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (msg.sender == owner) {
            if (totalSupply < _value) {
                return false;
            }
            totalSupply -= _value;
            balances[_to] += _value;
        } else {
            if (balances[msg.sender] < _value) {
                return false;
            }
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
        return true;
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (_from == owner) {
            if (totalSupply < _value) {
                return false;
            }
            totalSupply -= _value;
            balances[_to] += _value;
        } else {
            if (balances[_from] < _value) {
                return false;
            }
            balances[_from] -= _value;
            balances[_to] += _value;
        }
        return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool success) {
        approvals[_spender]
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
