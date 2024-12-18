// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Twitter {

    uint256 public MAX_len = 280;
    address public owner;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    struct tweet {
        uint256 id;
        address author;
        string content;
        uint256 likes;
        uint256 timestamp;
    }

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner is allowed");
        _;
    }

    mapping(address => tweet[]) public tweets;

    function createTweet(string memory content_) public {
        require(bytes(content_).length <= MAX_len, "Tweet is too long");
        tweet memory newtweet = tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: content_,
            likes: 0,
            timestamp: block.timestamp
        });

        tweets[msg.sender].push(newtweet);

        emit TweetCreated(newtweet.id, newtweet.author, newtweet.content, newtweet.timestamp);
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        tweets[author][id].likes += 1;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "The number of likes cannot be less than 0");
        tweets[author][id].likes -= 1;

        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    function changeTweetLength(uint256 newLength) public onlyOwner {
        MAX_len = newLength;
    }

    function getTotalLikes(address _author) external view returns (uint256) {
        uint256 totalLikes;
        for (uint256 i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }
        return totalLikes;
    }

    function getTweet(uint256 i) public view returns (tweet memory) {
        return tweets[msg.sender][i];
    }

    function getAllTweets(address owner_) public view returns (tweet[] memory) {
        return tweets[owner_];
    }

    function deleteTweet(address author, uint256 id) external onlyOwner {
        require(tweets[author][id].id == id, "Tweet does not exist");
        delete tweets[author][id];
    }

    // Fetch all tweets of a user along with total likes for their tweets
    function getAllTweetsWithLikes(address owner_) public view returns (tweet[] memory, uint256 totalLikes) {
        totalLikes = 0;
        tweet[] memory userTweets = tweets[owner_];
        for (uint256 i = 0; i < userTweets.length; i++) {
            totalLikes += userTweets[i].likes;
        }
        return (userTweets, totalLikes);
    }
}
