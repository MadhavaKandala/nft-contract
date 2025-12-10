// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftCollection {
    string public name;
    string public symbol;
    uint256 public maxSupply;
    uint256 public totalSupply;
    string private baseURI;
    
    address public owner;
    bool public paused;
    
    mapping(uint256 => address) private tokenOwners;
    mapping(address => uint256) private balances;
    mapping(uint256 => address) private tokenApprovals;
    mapping(address => mapping(address => bool)) private operatorApprovals;
    mapping(uint256 => bool) private tokenExists;
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed spender, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    constructor(string memory _name, string memory _symbol, uint256 _maxSupply) {
        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        totalSupply = 0;
        owner = msg.sender;
        paused = false;
        baseURI = "https://metadata.example.com/";
    }
    
    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "Invalid address");
        return balances[account];
    }
    
    function ownerOf(uint256 tokenId) public view returns (address) {
        require(tokenExists[tokenId], "Token does not exist");
        return tokenOwners[tokenId];
    }
    
    function safeMint(address to, uint256 tokenId) public onlyOwner whenNotPaused {
        require(to != address(0), "Cannot mint to zero address");
        require(!tokenExists[tokenId], "Token already exists");
        require(totalSupply < maxSupply, "Max supply reached");
        
        tokenOwners[tokenId] = to;
        tokenExists[tokenId] = true;
        balances[to] += 1;
        totalSupply += 1;
        
        emit Transfer(address(0), to, tokenId);
    }
    
    function transfer(address to, uint256 tokenId) public {
        require(tokenExists[tokenId], "Token does not exist");
        require(to != address(0), "Cannot transfer to zero address");
        
        address from = tokenOwners[tokenId];
        require(msg.sender == from, "Not token owner");
        
        _transfer(from, to, tokenId);
    }
    
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(tokenExists[tokenId], "Token does not exist");
        require(to != address(0), "Cannot transfer to zero address");
        require(tokenOwners[tokenId] == from, "From address is not owner");
        
        bool isApproved = msg.sender == from || 
                         msg.sender == tokenApprovals[tokenId] ||
                         operatorApprovals[from][msg.sender];
        require(isApproved, "Not approved to transfer");
        
        _transfer(from, to, tokenId);
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal {
        tokenOwners[tokenId] = to;
        balances[from] -= 1;
        balances[to] += 1;
        delete tokenApprovals[tokenId];
        
        emit Transfer(from, to, tokenId);
    }
    
    function approve(address to, uint256 tokenId) public {
        address _owner = tokenOwners[tokenId];
        require(msg.sender == _owner || operatorApprovals[_owner][msg.sender], "Not approved");
        
        tokenApprovals[tokenId] = to;
        emit Approval(_owner, to, tokenId);
    }
    
    function getApproved(uint256 tokenId) public view returns (address) {
        require(tokenExists[tokenId], "Token does not exist");
        return tokenApprovals[tokenId];
    }
    
    function setApprovalForAll(address operator, bool approved) public {
        operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    
    function isApprovedForAll(address _owner, address operator) public view returns (bool) {
        return operatorApprovals[_owner][operator];
    }
    
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(tokenExists[tokenId], "Token does not exist");
        return string(abi.encodePacked(baseURI, uintToString(tokenId), ".json"));
    }
    
    function uintToString(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    
    function pauseMinting() public onlyOwner {
        paused = true;
    }
    
    function unpauseMinting() public onlyOwner {
        paused = false;
    }
    
    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }
}
