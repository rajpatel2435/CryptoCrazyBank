// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract RegisterUser {
    // Mapping to store the generated OTPs for users
    mapping(string => uint256) private otps;

    struct User {
        string identifier; // Email or phone number
        bool isRegistered;
        uint256 registrationTimestamp;
    }

    // Mapping to track registered users
    mapping(string => bool) private isRegistered;

    // Event to log OTP generation
    // Mapping to store user details by identifier (email/phone)
    mapping(string => User) private users;

    // Event to log user registration
    event UserRegistered(string indexed identifier);

    // Event to log OTP generation
    event OTPGenerated(string indexed identifier, uint256 otp);

    // Function to generate OTP
    function generateOTP(string memory identifier) public returns (uint256) {
        require(bytes(identifier).length > 0, "Identifier cannot be empty");

        // Generate a pseudo-random OTP based on the block timestamp and identifier
        uint256 otp = uint256(keccak256(abi.encodePacked(identifier, block.timestamp, block.prevrandao))) % 1000000;

        // Store the OTP in the mapping
        otps[identifier] = otp;

        // Emit an event for logging
        emit OTPGenerated(identifier, otp);

        return otp;
    }

    // Function to retrieve the OTP for debugging purposes (remove in production)
    function getOTP(string memory identifier) public view  returns (uint256) {
        return otps[identifier];
    }


        function verifyOTP(string memory identifier, uint256 otp) public returns (bool) {
        require(bytes(identifier).length > 0, "Identifier cannot be empty");
        require(!isRegistered[identifier], "User is already registered");
        require(otps[identifier] != 0, "OTP not generated for this identifier");

        // Validate the provided OTP
        require(otps[identifier] == otp, "Invalid OTP");

        // Mark the user as registered
        isRegistered[identifier] = true;

        // Clear the OTP after successful verification
        delete otps[identifier];

        // Emit a registration event
        emit UserRegistered(identifier);

        return true;
    }

    // Function to check if a user is registered
    function isUserRegistered(string memory identifier) public view returns (bool) {
        return isRegistered[identifier];
    }

     function registerUser(string memory identifier) private {
        // Ensure the user is not already registered
        require(!users[identifier].isRegistered, "User is already registered");

        // Store the user's registration information
        users[identifier] = User({
            identifier: identifier,
            isRegistered: true,
            registrationTimestamp: block.timestamp
        });

        // Emit the registration event
        emit UserRegistered(identifier);
    }

        // Function to get user information (after they are registered)
    function getUserInfo(string memory identifier) public view returns (User memory) {
        require(users[identifier].isRegistered, "User is not registered");
        return users[identifier];
    }

function loginUser(string memory identifier) public returns (bool) {
    require(users[identifier].isRegistered, "User is not registered");

    // Generate a new OTP for login
    uint256 otp = uint256(keccak256(abi.encodePacked(identifier, block.timestamp, block.prevrandao))) % 1000000;

    // Store the OTP in the mapping
    otps[identifier] = otp;

    // Emit an event for logging
    emit OTPGenerated(identifier, otp);

    // Return the OTP to the user
    return true;
}

function verifyLoginOTP(string memory identifier, uint256 otp) public returns (bool) {
    require(users[identifier].isRegistered, "User is not registered");
    require(otps[identifier] == otp, "Invalid OTP");

    // Clear the OTP after successful verification
    delete otps[identifier];



    return true;
}
}
