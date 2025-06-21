# StackTag - Decentralized Social Reputation Protocol

A Bitcoin-secured SocialFi protocol for decentralized reputation, user validation, and on-chain social interactions built on the Stacks Layer 2 blockchain.

## Overview

StackTag empowers communities with verifiable reputation systems that enable trustless social actions, public endorsements, and incentivized content participation. By leveraging Bitcoin's security through the Stacks Layer 2, StackTag creates a foundation for next-generation decentralized social interactions.

## System Architecture

### Core Components

The StackTag protocol consists of four primary modules:

1. **User Management System** - Handles user registration, profiles, and verification
2. **Content Management System** - Manages posts, likes, and reposts
3. **Reputation Engine** - Calculates and maintains user reputation scores
4. **Endorsement System** - Facilitates peer-to-peer skill and reputation validation

### Data Models

#### Users

- **User Profile**: Username, bio, reputation score, verification status
- **User Statistics**: Total posts, likes received, endorsements received
- **Temporal Data**: Join date, activity timestamps

#### Content

- **Posts**: Content, metadata, engagement metrics, tags
- **Interactions**: Likes, reposts, replies with timestamp tracking
- **Moderation**: Content activation/deactivation capabilities

#### Reputation

- **Scoring Algorithm**: Dynamic calculation based on engagement and endorsements
- **Reputation History**: Immutable audit trail of reputation changes
- **Weighted Endorsements**: Reputation-based endorsement value calculation

#### Endorsements

- **Skill-Based Validation**: Category-specific endorsements
- **Weighted System**: Endorsement value based on endorser's reputation
- **Mutual Validation**: Prevents self-endorsement and duplicate endorsements

## Contract Architecture

### Data Storage

The contract utilizes Clarity's native data structures:

- **Data Variables**: Global state management (user IDs, platform settings)
- **Data Maps**: Efficient key-value storage for users, posts, and endorsements
- **Relationship Mapping**: Cross-referential data structures for complex queries

### Core Functions

#### User Management

```clarity
(define-public (register-user (username (string-ascii 32)) (bio (string-utf8 256))))
(define-public (update-profile (username (string-ascii 32)) (bio (string-utf8 256))))
(define-public (verify-user (user-address principal)))
```

#### Content Operations

```clarity
(define-public (create-post (content (string-utf8 512)) (tags (list 5 (string-ascii 32)))))
(define-public (like-post (post-id uint)))
(define-public (repost (post-id uint) (original-post-id uint)))
```

#### Endorsement System

```clarity
(define-public (endorse-user (endorsed-user principal) (skill-category (string-ascii 32)) (message (string-utf8 256))))
```

### Security Features

- **Access Control**: Owner-only administrative functions
- **Input Validation**: Comprehensive sanitization and validation
- **Anti-Abuse Mechanisms**: Prevention of self-endorsement and duplicate actions
- **Emergency Controls**: Content and endorsement deactivation capabilities

## Data Flow

### User Onboarding Flow

1. **Registration**: User creates profile with username and bio
2. **Initial Reputation**: User receives starting reputation score (50 points)
3. **Profile Management**: Users can update profile information
4. **Verification**: Admin can verify users for enhanced credibility

### Content Creation Flow

1. **Post Creation**: User creates content with optional tags
2. **Engagement**: Other users can like and repost content
3. **Reputation Rewards**: Authors earn reputation based on engagement
4. **Moderation**: Content can be deactivated if necessary

### Reputation Calculation Flow

1. **Base Rewards**: Posts earn reputation through likes and engagement
2. **Multiplier Effects**: Higher reputation users earn enhanced rewards
3. **Endorsement Weights**: Reputation determines endorsement value
4. **Continuous Updates**: Real-time reputation score adjustments

### Endorsement Flow

1. **Eligibility Check**: Endorser must meet minimum reputation threshold
2. **Validation**: Prevents self-endorsement and duplicate endorsements
3. **Weight Calculation**: Endorsement value based on endorser's reputation
4. **Reputation Transfer**: Endorsed user receives reputation boost

## Key Features

### Reputation System

- **Dynamic Scoring**: Reputation calculated based on content quality and peer validation
- **Tiered Rewards**: Higher reputation users receive enhanced reward multipliers
- **Transparent History**: Immutable record of all reputation changes

### Anti-Spam Protection

- **Minimum Thresholds**: Reputation requirements for certain actions
- **Duplicate Prevention**: Protection against repeated actions
- **Content Moderation**: Admin and author content deactivation

### Economic Incentives

- **Platform Fees**: Configurable fee structure (default 1%)
- **Reward Thresholds**: Minimum reputation requirements for rewards
- **Scalable Economics**: Fee and threshold adjustments for platform growth

## Technical Specifications

### Platform Configuration

- **Starting Reputation**: 50 points for new users
- **Platform Fee**: 100 basis points (1%)
- **Minimum Reward Reputation**: 100 points
- **Maximum Content Length**: 512 UTF-8 characters
- **Maximum Tags**: 5 per post
- **Maximum Bio Length**: 256 UTF-8 characters

### Error Handling

- `err-owner-only` (u100): Unauthorized admin access
- `err-not-found` (u101): Resource not found
- `err-already-exists` (u102): Duplicate resource creation
- `err-unauthorized` (u103): Insufficient permissions
- `err-invalid-input` (u104): Invalid input parameters
- `err-insufficient-reputation` (u105): Below minimum reputation threshold
- `err-self-endorsement` (u106): Self-endorsement attempt
- `err-already-endorsed` (u107): Duplicate endorsement attempt

## Read-Only Functions

The contract provides comprehensive read-only functions for data retrieval:

- `get-user`: Retrieve user profile by address
- `get-user-by-id`: Retrieve user profile by ID
- `get-post`: Retrieve post data
- `get-endorsement`: Retrieve endorsement data
- `has-liked-post`: Check if user has liked a post
- `has-endorsed-user`: Check if user has endorsed another user
- `get-user-reputation`: Get user's current reputation score
- `get-platform-stats`: Retrieve platform-wide statistics

## Administrative Functions

### Platform Management

- **User Verification**: Admin can verify user accounts
- **Fee Management**: Adjustable platform fee structure
- **Reputation Thresholds**: Configurable minimum reputation requirements
- **Emergency Controls**: Content and endorsement deactivation

### Governance Features

- **Owner Controls**: Restricted administrative functions
- **Platform Parameters**: Adjustable economic and operational settings
- **Emergency Procedures**: Rapid response capabilities for content moderation

## Getting Started

### Prerequisites

- Stacks blockchain testnet/mainnet access
- Clarity development environment
- Stacks wallet integration

### Deployment

1. Deploy the contract to Stacks blockchain
2. Configure initial platform parameters
3. Set up administrative controls
4. Initialize user registration process

### Integration

The contract can be integrated with:

- Web3 frontend applications
- Mobile DApps
- Other Stacks ecosystem protocols
- Cross-chain bridging solutions

## Security Considerations

- **Input Sanitization**: All user inputs are validated and sanitized
- **Access Control**: Strict permission management for sensitive operations
- **Anti-Abuse**: Multiple layers of protection against malicious behavior
- **Emergency Procedures**: Rapid response capabilities for security incidents

## Future Enhancements

- **Cross-Protocol Integration**: Integration with other DeFi and SocialFi protocols
- **Advanced Reputation Models**: Machine learning-enhanced reputation calculation
- **Governance Token**: Community-driven platform governance
- **Mobile SDK**: Native mobile application development kit
- **API Gateway**: RESTful API for easy integration

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests for any improvements.

## Support

For technical support and questions, please visit our documentation or contact the development team.
