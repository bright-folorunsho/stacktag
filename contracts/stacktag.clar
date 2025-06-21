;; StackTag - Decentralized Social Reputation Protocol
;; A Bitcoin-secured SocialFi protocol for decentralized reputation, 
;; user validation, and on-chain social interactions.
;;
;; Empowering communities with verifiable reputation systems built 
;; on the security of Bitcoin via the Stacks Layer 2. 
;; StackTag enables trustless social actions, public endorsements, 
;; and incentivized content participation for a next-gen decentralized society.

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))
(define-constant err-insufficient-reputation (err u105))
(define-constant err-self-endorsement (err u106))
(define-constant err-already-endorsed (err u107))

;; Data Variables
(define-data-var next-user-id uint u1)
(define-data-var next-post-id uint u1)
(define-data-var next-endorsement-id uint u1)
(define-data-var platform-fee uint u100) ;; 1% fee in basis points
(define-data-var min-reputation-for-rewards uint u100)

;; Data Maps
(define-map users
  { user-address: principal }
  {
    user-id: uint,
    username: (string-ascii 32),
    bio: (string-utf8 256),
    reputation-score: uint,
    total-posts: uint,
    total-likes-received: uint,
    total-endorsements-received: uint,
    joined-at: uint,
    is-verified: bool
  }
)

(define-map user-by-id
  { user-id: uint }
  { user-address: principal }
)

(define-map posts
  { post-id: uint }
  {
    author: principal,
    content: (string-utf8 512),
    timestamp: uint,
    likes: uint,
    reposts: uint,
    replies: uint,
    reputation-earned: uint,
    is-active: bool,
    tags: (list 5 (string-ascii 32))
  }
)

(define-map post-likes
  { post-id: uint, liker: principal }
  { timestamp: uint }
)

(define-map post-reposts
  { post-id: uint, reposter: principal }
  { timestamp: uint, original-post-id: uint }
)

(define-map endorsements
  { endorsement-id: uint }
  {
    endorser: principal,
    endorsed: principal,
    skill-category: (string-ascii 32),
    message: (string-utf8 256),
    reputation-weight: uint,
    timestamp: uint,
    is-active: bool
  }
)

(define-map user-endorsements
  { endorsed: principal, endorser: principal }
  { endorsement-id: uint }
)