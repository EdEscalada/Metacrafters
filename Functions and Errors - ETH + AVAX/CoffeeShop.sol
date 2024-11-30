// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract CoffeeShopLoyalty {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //customer structure
    struct Customer {
        uint points;
        uint totalSpent;
    }

    //mapping variable
    mapping(address => Customer) public customers;

    //events
    event PointsEarned(address indexed customer, uint points);
    event PointsRedeemed(address indexed customer, uint points, string reward);

    //modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // fxn to add points to a customer's account
    function addPoints(address _customer, uint _amountSpent) public onlyOwner {
        uint points = _amountSpent / 10; // Earn 1 point for every 10 units of currency spent
        customers[_customer].points += points;
        customers[_customer].totalSpent += _amountSpent;
        emit PointsEarned(_customer, points);
    }

    // fxn to redeem points for a reward
    function redeemPoints(address _customer, uint _points, string memory _reward) public {
        require(customers[_customer].points >= _points, "Not enough points to redeem");
        customers[_customer].points -= _points;
        emit PointsRedeemed(_customer, _points, _reward);
    }

    // fxn to check a customer's points balance
    function getPointsBalance(address _customer) public view returns (uint) {
        return customers[_customer].points;
    }

    // fxn to check a customer's total spent
    function getTotalSpent(address _customer) public view returns (uint) {
        return customers[_customer].totalSpent;
    }

    // fxn to transfer ownership
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        owner = newOwner;
    }

    // fxn to assert the contract state
    function assertContractState() public view {
        assert(owner != address(0));
    }

    // fxn to revert if a condition is not met
    function revertIfNotOwner() public view {
        if (msg.sender != owner) {
            revert("Caller is not the owner");
        }
    }
}
