// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

contract UserContract {

    struct User {
        string email;
        string username;
        string password;
        string role;
        bool isLogged;
    }

    mapping(string => User) users;

    // Register User
    function registerUser(string memory _email, string memory _username, string memory _password, string memory _role ) public returns (bool) {
        users[_email].email = _email;
        users[_email].username = _username;
        users[_email].password = _password;
        users[_email].role = _role;
        users[_email].isLogged = true;

        return true;
    }

    // Login User
    function loginUser(string memory _email, string memory _password) public returns (bool, string memory, string memory) {
        if (keccak256(abi.encodePacked(users[_email].password)) == keccak256(abi.encodePacked(_password))) {
            users[_email].isLogged = true;
            return( users[_email].isLogged, _email, users[_email].username);
        } else {
            return (false, "", "");
        }
    }

    //Check logged user state
    function checkLogged(string memory _email) public view returns(bool) {
        return users[_email].isLogged;
    }

    function logoutUser(string memory _email) public {
        users[_email].isLogged = false;
    }

}