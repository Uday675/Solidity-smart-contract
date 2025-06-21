// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Project {
    address public owner;

    // Track donations made by each donor
    mapping(address => uint256) public donations;

    // Total donations received
    uint256 public totalDonations;

    // Event emitted on each donation
    event DonationReceived(address indexed donor, uint256 amount);

    // Event emitted when owner withdraws funds
    event Withdrawal(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // Function to accept donations
    function donate() external payable {
        require(msg.value > 0, "Donation must be more than zero");

        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }

    // Function for owner to withdraw collected funds
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");

        payable(owner).transfer(amount);

        emit Withdrawal(owner, amount);
    }

    // Get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
