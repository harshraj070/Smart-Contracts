// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SocialMedia {

    struct Profile {
        string username;
        string bio;
        uint followersCount;
        mapping(address => bool) following;
    }

    mapping(address => Profile) public profiles;

    // Set or update the user's profile
    function setProfile(string memory _username, string memory _bio) public {
        profiles[msg.sender].username = _username;
        profiles[msg.sender].bio = _bio;
    }

    // Follow another user
    function follow(address _user) public {
        require(_user != msg.sender, "You cannot follow yourself");
        require(!profiles[_user].following[msg.sender], "You are already following this user");

        profiles[_user].followersCount += 1;
        profiles[_user].following[msg.sender] = true;
    }

    // Unfollow a user
    function unfollow(address _user) public {
        require(_user != msg.sender, "You cannot unfollow yourself");
        require(profiles[_user].following[msg.sender], "You are not following this user");

        profiles[_user].followersCount -= 1;
        profiles[_user].following[msg.sender] = false;
    }

    // Update only the bio of the profile
    function updateBio(string memory _bio) public {
        profiles[msg.sender].bio = _bio;
    }

    // Check if a user is following another user
    function isFollowing(address _user, address _follower) public view returns (bool) {
        return profiles[_user].following[_follower];
    }

    // Get the profile details of a user
    function getProfile(address _user) public view returns (string memory, string memory, uint) {
        Profile storage profile = profiles[_user];
        return (profile.username, profile.bio, profile.followersCount);
    }

    // Simple private messaging (DM) system
    mapping(address => mapping(address => string[])) private messages;

    function sendMessage(address _recipient, string memory _message) public {
        require(_recipient != msg.sender, "You cannot send a message to yourself");
        messages[_recipient][msg.sender].push(_message);
    }

    function getMessages(address _sender) public view returns (string[] memory) {
        return messages[msg.sender][_sender];
    }
}
