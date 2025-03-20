// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BlockchainDonations {
    address public owner;
    mapping(address => uint256) public donations;
    uint256 public totalDonations;

    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than zero");
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    function getDonationAmount(address donor) external view returns (uint256) {
        return donations[donor];
    }

    function withdrawFunds(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        payable(owner).transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

