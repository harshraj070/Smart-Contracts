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

    function setProfile(string memory _username, string memory _bio) public {
        profiles[msg.sender].username = _username;
        profiles[msg.sender].bio = _bio;
    }

    function follow(address _user) public {
        require(_user != msg.sender, "You cannot follow yourself");
        require(!profiles[_user].following[msg.sender], "You are already following this user");

        profiles[_user].followersCount += 1;
        profiles[_user].following[msg.sender] = true;
    }

    function unfollow(address _user) public {
        require(_user != msg.sender, "You cannot unfollow yourself");
        require(profiles[_user].following[msg.sender], "You are not following this user");

        profiles[_user].followersCount -= 1;
        profiles[_user].following[msg.sender] = false;
    }

    function updateBio(string memory _bio) public {
        profiles[msg.sender].bio = _bio;
    }

    function isFollowing(address _user, address _follower) public view returns (bool) {
        return profiles[_user].following[_follower];
    }

    function getProfile(address _user) public view returns (string memory, string memory, uint) {
        Profile storage profile = profiles[_user];
        return (profile.username, profile.bio, profile.followersCount);
    }

    mapping(address => mapping(address => string[])) private messages;

    function sendMessage(address _recipient, string memory _message) public {
        require(_recipient != msg.sender, "You cannot send a message to yourself");
        messages[_recipient][msg.sender].push(_message);
    }

    function getMessages(address _sender) public view returns (string[] memory) {
        return messages[msg.sender][_sender];
    }

    function deleteMessage(address _sender, uint256 index) public {
        require(index < messages[msg.sender][_sender].length, "Invalid message index");

        string[] storage userMessages = messages[msg.sender][_sender];
        for (uint i = index; i < userMessages.length - 1; i++) {
            userMessages[i] = userMessages[i + 1];
        }
        userMessages.pop();
    }
}
