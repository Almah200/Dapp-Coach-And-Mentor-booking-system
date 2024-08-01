// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoachAndMentor {
    address public owner;

    enum SessionType {
        IndividualOneSession,
        GroupOneSession,
        IndividualOneMonth,
        GroupOneMonth
    }

    struct Booking {
        address user;
        SessionType sessionType;
        uint256 amount;
    }

    // Mapping from user address to their bookings
    mapping(address => Booking[]) private userBookings;

    // Array to store all bookings in the contract
    Booking[] private allBookings;

    // Mapping to store session prices
    mapping(SessionType => uint256) public sessionPrices;

    // Events
    event BookingMade(
        address indexed user,
        SessionType sessionType,
        uint256 amount
    );
    event InvalidPaymentAmount(address indexed user, uint256 amount);
    event SessionTypeOutOfRange(uint256 sessionTypeIndex);

    constructor() {
        owner = msg.sender;

        // Set session prices in wei
        sessionPrices[SessionType.IndividualOneSession] = 1 wei;
        sessionPrices[SessionType.GroupOneSession] = 3 wei;
        sessionPrices[SessionType.IndividualOneMonth] = 5 wei;
        sessionPrices[SessionType.GroupOneMonth] = 7 wei;
    }

    // Receive function to accept Ether with empty data
    receive() external payable {
        require(msg.sender != owner, "Owner cannot send Ether to the contract");

        // Validate the payment amount
        bool validAmount = false;
        SessionType sessionType;
        uint256 amount = msg.value;

        for (uint i = 0; i < 4; i++) {
            if (amount == sessionPrices[SessionType(i)]) {
                sessionType = SessionType(i);
                validAmount = true;
                break;
            }
        }

        require(validAmount, "Invalid payment amount");

        // Record the booking
        Booking memory newBooking = Booking(msg.sender, sessionType, amount);
        userBookings[msg.sender].push(newBooking);
        allBookings.push(newBooking);

        // Emit an event
        emit BookingMade(msg.sender, sessionType, amount);
    }

    // Fallback function to accept Ether with non-empty data
    fallback() external payable {
        require(msg.sender != owner, "Owner cannot send Ether to the contract");

        // Validate the payment amount
        bool validAmount = false;
        SessionType sessionType;
        uint256 amount = msg.value;

        for (uint i = 0; i < 4; i++) {
            if (amount == sessionPrices[SessionType(i)]) {
                sessionType = SessionType(i);
                validAmount = true;
                break;
            }
        }

        require(validAmount, "Invalid payment amount");

        // Record the booking
        Booking memory newBooking = Booking(msg.sender, sessionType, amount);
        userBookings[msg.sender].push(newBooking);
        allBookings.push(newBooking);

        // Emit an event
        emit BookingMade(msg.sender, sessionType, amount);
    }

    // Function to withdraw all Ether from the contract to the owner
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance > 0, "Contract balance is zero");
        payable(owner).transfer(address(this).balance);
    }

    // Get the balance of the contract
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Get all bookings for a specific address
    function getUserBookings(
        address user
    ) external view returns (Booking[] memory) {
        return userBookings[user];
    }

    // Get all bookings in the contract
    function getAllBookings() external view returns (Booking[] memory) {
        return allBookings;
    }
} 