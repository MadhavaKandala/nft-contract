# NFT Collection Smart Contract

ERC-721 compatible NFT smart contract with comprehensive automated test suite and Docker containerization.

## Overview

This project implements a fully functional NFT (ERC-721) smart contract that enables secure minting, transferring, and management of non-fungible tokens on the Ethereum blockchain.

## Features

- **ERC-721 Compliant**: Implements the standard ERC-721 interface for NFT functionality
- **Minting Control**: Secure minting with owner-based authorization
- **Transfers & Approvals**: Full support for token transfers and approval mechanisms
- **Metadata Support**: Token URI functionality for metadata retrieval
- **Pause/Unpause**: Admin controls to pause/unpause minting when needed
- **Maximum Supply**: Enforced collection size limits
- **Comprehensive Testing**: Full test suite covering all functionality
- **Docker Ready**: Containerized environment for easy deployment and testing

## Project Structure

```
nft-contract/
├── contracts/
│   └── NftCollection.sol          # Main ERC-721 smart contract
├── test/
│   └── NftCollection.test.js      # Comprehensive test suite
├── package.json                   # Project dependencies
├── hardhat.config.js              # Hardhat configuration
├── Dockerfile                     # Docker containerization
├── .dockerignore                  # Docker build exclusions
└── README.md                      # This file
```

## Requirements

- Node.js 18 or higher
- Docker (for containerized testing)
- npm or yarn

## Installation

### Local Setup

```bash
# Clone the repository
git clone https://github.com/MadhavaKandala/nft-contract.git
cd nft-contract

# Install dependencies
npm install
```

### Using Docker

```bash
# Build the Docker image
docker build -t nft-contract .

# Run tests in Docker container
docker run nft-contract
```

## Running Tests

### Local Testing

```bash
# Run all tests
npm test

# Run tests with verbose output
npm test -- --verbose

# Run specific test file
npx hardhat test test/NftCollection.test.js
```

### Docker Testing

```bash
# Build the image
docker build -t nft-contract .

# Run tests
docker run nft-contract
```

## Smart Contract Functions

### Core Functions

- `balanceOf(address account)`: Get token balance of an address
- `ownerOf(uint256 tokenId)`: Get owner of a specific token
- `safeMint(address to, uint256 tokenId)`: Mint a new token (owner only)
- `transfer(address to, uint256 tokenId)`: Transfer token
- `transferFrom(address from, address to, uint256 tokenId)`: Approved transfer
- `approve(address to, uint256 tokenId)`: Approve token transfer
- `setApprovalForAll(address operator, bool approved)`: Approve all tokens for operator
- `getApproved(uint256 tokenId)`: Get approved address for token
- `isApprovedForAll(address owner, address operator)`: Check operator approval
- `tokenURI(uint256 tokenId)`: Get metadata URI for token

### Admin Functions

- `pauseMinting()`: Pause token minting
- `unpauseMinting()`: Resume token minting
- `setBaseURI(string memory _baseURI)`: Update base URI for metadata

## Test Coverage

The test suite includes comprehensive coverage of:

- Contract initialization
- Token minting (success and failure cases)
- Token transfers
- Approval mechanisms
- Operator approvals
- Pause/unpause functionality
- Event emissions
- Metadata retrieval
- Edge cases and error handling

## Deployment

To deploy the contract to a testnet:

1. Create a `.env` file with your private key and RPC URL
2. Update Hardhat configuration for your target network
3. Run deployment script (if available)

## Technology Stack

- **Solidity 0.8.20**: Smart contract language
- **Hardhat**: Ethereum development framework
- **Chai**: Test assertion library
- **Node.js**: Runtime environment
- **Docker**: Container orchestration

## Gas Considerations

The contract is optimized for reasonable gas usage:
- Minting: ~67,000 gas (approximate)
- Transfer: ~35,000 gas (approximate)
- Approval: ~25,000 gas (approximate)

Gas costs may vary based on network conditions and current gas prices.

## Security

- Owner-based access control for privileged operations
- Input validation for all functions
- Atomic state changes to prevent inconsistencies
- Clear error messages for invalid operations
- No reentrancy vulnerabilities in contract logic

## Common Issues

### Docker Build Fails

```bash
# Clear Docker cache and rebuild
docker system prune
docker build --no-cache -t nft-contract .
```

### Test Failures

```bash
# Ensure node_modules are installed
rm -rf node_modules
npm install
npm test
```

## License

MIT License - See LICENSE file for details

## Author

MadhavaKandala

## Contributing

Feel free to submit issues and enhancement requests!
