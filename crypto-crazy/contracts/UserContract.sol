//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract UserContract {
    address public userAddress;

    struct User {
        uint256 id;
        string username;
        string email;
        bytes32 password;

    }

    mapping(uint256 => User) public users;

    event UserRegistered(uint256 indexed userId, string userName, string email);

   mapping(string => bool) public usernameTaken;
mapping(string => bool) public emailTaken;

function registerUser(string memory _username, string memory _email, string memory _password) public {
    // Validate input data
    require(bytes(_username).length > 0, "Username cannot be empty");
    require(bytes(_email).length > 0, "Email cannot be empty");
    require(bytes(_password).length > 0, "Password cannot be empty");

    // Check if username is unique
    require(!usernameTaken[_username], "Username already taken");

    // Check if email is unique
    require(!emailTaken[_email], "Email already taken");

    // Generate unique user ID
    uint256 userId = uint256(keccak256(abi.encodePacked(_username, _email)));

  bytes32 hashedPassword = keccak256(bytes(_password));

    // Create user struct
    User memory user = User({
        id: userId,
        username: _username,
        email: _email,
        password: hashedPassword
    });

    // Store user struct in mapping
    users[userId] = user;

    // Mark username and email as taken
    usernameTaken[_username] = true;
    emailTaken[_email] = true;

    // Emit registration event
    emit UserRegistered(userId, _username, _email);
}

function loginUser(string memory _username, string memory _email, string memory _password) view public returns (bool) {
    // Check if username or email is provided
    require(bytes(_username).length > 0 || bytes(_email).length > 0, "Username or email must be provided");

    bytes32 hashedInputPassword = keccak256(bytes(_password));

    // Check if username exists
    if (bytes(_username).length > 0) {
        require(usernameTaken[_username], "Username does not exist");
        uint256 userId = uint256(keccak256(abi.encodePacked(_username)));
        User memory user = users[userId];
   require(hashedInputPassword == keccak256(abi.encodePacked(user.password)), "Invalid password");
    }

    // Check if email exists
    if (bytes(_email).length > 0) {
        require(emailTaken[_email], "Email does not exist");
        uint256 userId = uint256(keccak256(abi.encodePacked(_email)));
        User memory user = users[userId];
   require(hashedInputPassword == keccak256(abi.encodePacked(user.password)), "Invalid password");
    }

    // Return true if login is successful
    return true;
}



function resetPassword(string memory _username, string memory _oldPassword, string memory _newPassword) public {
    // Check if username exists
    require(usernameTaken[_username], "Username does not exist");

    // Get user ID from username
    uint256 userId = uint256(keccak256(abi.encodePacked(_username)));

    // Get user object from user ID
    User memory user = users[userId];

    // Check if old password matches
    require(keccak256(abi.encodePacked(user.password)) == keccak256(abi.encodePacked(_oldPassword)), "Old password does not match");

    // Update user password
    user.password = keccak256(abi.encodePacked(_newPassword));

    // Store updated user object
    users[userId] = user;
}

function updateUser(string memory _username, string memory _email, string memory _password) view public  {
    // Check if username exists
    require(usernameTaken[_username], "Username does not exist");

    // Get user ID from username
    uint256 userId = uint256(keccak256(abi.encodePacked(_username)));

    // Get user object from user ID and update fields
    User memory user = users[userId];
    user.username = _username;
    user.email = _email;
user.password = keccak256(abi.encodePacked(_password));
}

}