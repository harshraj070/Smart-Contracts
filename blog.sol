// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Blog {
    struct Post {
        uint256 id;
        string title;
        string contentHash; // IPFS or other hash for the actual content
        address author;
        uint256 timestamp;
    }

    Post[] public posts;
    uint256 public postCount;

    event PostCreated(uint256 id, string title, string contentHash, address indexed author, uint256 timestamp);
    event PostUpdated(uint256 id, string title, string contentHash, address indexed author, uint256 timestamp);

    // Create a new blog post
    function createPost(string memory _title, string memory _contentHash) public {
        postCount += 1;
        posts.push(Post(postCount, _title, _contentHash, msg.sender, block.timestamp));
        emit PostCreated(postCount, _title, _contentHash, msg.sender, block.timestamp);
    }

    // Update an existing post by ID (only the author can update)
    function updatePost(uint256 _id, string memory _title, string memory _contentHash) public {
        require(_id > 0 && _id <= postCount, "Invalid post ID");
        Post storage post = posts[_id - 1]; // IDs start at 1 but array is 0-based
        require(post.author == msg.sender, "You are not the author");

        post.title = _title;
        post.contentHash = _contentHash;
        post.timestamp = block.timestamp;

        emit PostUpdated(_id, _title, _contentHash, msg.sender, block.timestamp);
    }

    // Delete an existing post by ID (only the author can delete)
    function deletePost(uint256 _id) public {
        require(_id > 0 && _id <= postCount, "Invalid post ID");
        Post storage post = posts[_id - 1];
        require(post.author == msg.sender, "You are not the author");

        // Clear the post data
        post.title = "";
        post.contentHash = "";
        post.timestamp = 0;
        post.author = address(0);

        emit PostUpdated(_id, "", "", address(0), 0); // Indicate the post is deleted
    }

    // Fetch a post by ID
    function getPost(uint256 _id) public view returns (Post memory) {
        require(_id > 0 && _id <= postCount, "Invalid post ID");
        return posts[_id - 1]; // Return the post from the array
    }

    // Get the total number of posts
    function getPostCount() public view returns (uint256) {
        return postCount;
    }

    // Fetch all posts
    function getAllPosts() public view returns (Post[] memory) {
        return posts;
    }
}
