//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserOTP {

uint256 private constant SALT_VALUE = 0xdeadbeef;

bytes32 public salt;
mapping(string => bytes) public otpCodes;
mapping(string => bool) public emailTaken;
mapping(string => bool) public usernameTaken;

struct User {
    uint256 id;
    string username;
    string email;
    bytes mobileNumber;
    bytes32 otp;
}

mapping(uint256 => User) public users;

constructor() {
    salt = bytes32(SALT_VALUE);
}

// function generateOtp(string memory _email, bytes32 mobileNumber) public {
//     // Check if the email address is provided
//     if(bytes(_email).length > 0) {
//      bytes memory otp = bytes(keccak256(abi.encodePacked(_email, mobileNumber)));

// otpCodes[_email] = otp;

//     }
// }

function generateOtp(string memory _email, string memory mobileNumber) public returns (bytes memory) {
    // Check if the email address is provided

    require(bytes(_email).length > 0 || bytes(mobileNumber).length > 0, "Either email or mobile number must be provided");

    if(bytes(_email).length > 0) {

        bytes32 hash = keccak256(abi.encodePacked(_email, block.timestamp,salt));

        bytes memory otp = abi.encodePacked(hash);

       return otpCodes[_email] = otp;

    }else if(bytes(mobileNumber).length > 0) {

        bytes32 hash = keccak256(abi.encodePacked(mobileNumber, block.timestamp, salt));

        bytes memory otp = abi.encodePacked(hash); 

       return otpCodes[mobileNumber] = otp;

    }

    
}

function requestOtp( string memory _email, string memory _mobileNumber) public  {
    require(bytes(_email).length > 0 || bytes(_mobileNumber).length > 0, "Either email or mobile number must be provided");

    if(bytes(_email).length > 0) {
        generateOtp(_email, _mobileNumber);
    }

    if(bytes(_mobileNumber).length > 0) {
        generateOtp(_email,_mobileNumber);
    }
}

function verifyOtp(string memory _email, string memory _mobileNumber, bytes memory _otp) public  returns (bool) {
    require(bytes(_email).length > 0 || bytes(_mobileNumber).length > 0, "Either email or mobile number must be provided");
    if(bytes(_email).length > 0) {
        bytes memory storedOtp = otpCodes[_email];
        require(storedOtp.length > 0, "OTP not generated for this email");
        bytes memory encodedOtp = abi.encodePacked(_otp);
        require(keccak256(encodedOtp) == keccak256(storedOtp), "Invalid OTP");
        registerUser(_email);
        return true;
    } else if(bytes(_mobileNumber).length > 0) {
        bytes memory storedOtp = otpCodes[_mobileNumber];
        require(storedOtp.length > 0, "OTP not generated for this mobile number");
        bytes memory encodedOtp = abi.encodePacked(_otp);
        require(keccak256(encodedOtp) == keccak256(storedOtp), "Invalid OTP");
        return true;
    }
}
function registerUser(string memory _email) public {
    // Check if the email or mobile number is already registered

    require(!emailTaken[_email], "Email or mobile number already registered");
    uint256 userId = uint256(keccak256(abi.encodePacked(_email, block.timestamp)));
    User memory user = User({
        id: userId,
        username: _email,
        email: _email,
        mobileNumber: "0x0",
        otp: 0x0
    });

    // Store user struct in mapping
    users[userId] = user;

    // Mark email as taken
    emailTaken[_email] = true;
  
}
}