// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SocialMedia {

    struct Profile {
        string username;
        string bio;
        uint followersCount;
    }

    mapping(address => Profile) public profiles;

    function setProfile(string memory _username, string memory _bio) public {
        profiles[msg.sender] = Profile(_username, _bio, profiles[msg.sender].followersCount);
    }

    function follow(address _user) public {
        require(_user != msg.sender, "You cannot follow yourself");
        profiles[_user].followersCount += 1;
    }

    function getProfile(address _user) public view returns (string memory, string memory, uint) {
        Profile memory profile = profiles[_user];
        return (profile.username, profile.bio, profile.followersCount);
    }
}
