//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Twitter {
    uint16 public MAX_LENGTH = 280;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyowner {
        require(msg.sender == owner, "Only owner can call this function!");
        _;
    }

    function changeLength(uint16 newTweetLength) public onlyowner {
        MAX_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_LENGTH, "Tweet is too long!");
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        tweets[author][id].likes++;
    }

    function unliketweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes");
        tweets[author][id].likes--;
    }

    function getTweets(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
