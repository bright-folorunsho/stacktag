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

(define-map reputation-history
  { user: principal, timestamp: uint }
  {
    action-type: (string-ascii 32),
    reputation-change: int,
    total-reputation: uint,
    details: (string-utf8 128)
  }
)

;; Helper Functions
(define-private (get-current-time)
  stacks-block-height
)

(define-private (calculate-reputation-reward (likes uint) (author-reputation uint))
  (let
    (
      (base-reward (if (> likes u0) (+ u10 (* likes u2)) u0))
      (reputation-multiplier (if (> author-reputation u500) u2 u1))
    )
    (* base-reward reputation-multiplier)
  )
)

(define-private (calculate-endorsement-weight (endorser-reputation uint))
  (if (>= endorser-reputation u1000)
    u50
    (if (>= endorser-reputation u500)
      u30
      (if (>= endorser-reputation u100)
        u20
        u10
      )
    )
  )
)

;; Read-only Functions
(define-read-only (get-user (user-address principal))
  (map-get? users { user-address: user-address })
)

(define-read-only (get-user-by-id (user-id uint))
  (match (map-get? user-by-id { user-id: user-id })
    user-data (get-user (get user-address user-data))
    none
  )
)

(define-read-only (get-post (post-id uint))
  (map-get? posts { post-id: post-id })
)

(define-read-only (get-endorsement (endorsement-id uint))
  (map-get? endorsements { endorsement-id: endorsement-id })
)

(define-read-only (has-liked-post (post-id uint) (user principal))
  (is-some (map-get? post-likes { post-id: post-id, liker: user }))
)

(define-read-only (has-endorsed-user (endorser principal) (endorsed principal))
  (is-some (map-get? user-endorsements { endorsed: endorsed, endorser: endorser }))
)

(define-read-only (get-user-reputation (user-address principal))
  (match (get-user user-address)
    user-data (get reputation-score user-data)
    u0
  )
)

(define-read-only (get-platform-stats)
  {
    total-users: (- (var-get next-user-id) u1),
    total-posts: (- (var-get next-post-id) u1),
    total-endorsements: (- (var-get next-endorsement-id) u1),
    platform-fee: (var-get platform-fee),
    min-reputation-for-rewards: (var-get min-reputation-for-rewards)
  }
)

;; Public Functions

;; User Management
(define-public (register-user (username (string-ascii 32)) (bio (string-utf8 256)))
  (let
    (
      (current-user-id (var-get next-user-id))
      (current-time (get-current-time))
    )
    (asserts! (is-none (get-user tx-sender)) err-already-exists)
    (asserts! (> (len username) u0) err-invalid-input)
    
    (map-set users
      { user-address: tx-sender }
      {
        user-id: current-user-id,
        username: username,
        bio: bio,
        reputation-score: u50, ;; Starting reputation
        total-posts: u0,
        total-likes-received: u0,
        total-endorsements-received: u0,
        joined-at: current-time,
        is-verified: false
      }
    )
    
    (map-set user-by-id
      { user-id: current-user-id }
      { user-address: tx-sender }
    )
    
    (var-set next-user-id (+ current-user-id u1))
    (ok current-user-id)
  )
)

(define-public (update-profile (username (string-ascii 32)) (bio (string-utf8 256)))
  (let
    (
      (user-data (unwrap! (get-user tx-sender) err-not-found))
    )
    (asserts! (> (len username) u0) err-invalid-input)
    
    (map-set users
      { user-address: tx-sender }
      (merge user-data { username: username, bio: bio })
    )
    (ok true)
  )
)

;; Content Management
(define-public (create-post (content (string-utf8 512)) (tags (list 5 (string-ascii 32))))
  (let
    (
      (current-post-id (var-get next-post-id))
      (current-time (get-current-time))
      (user-data (unwrap! (get-user tx-sender) err-not-found))
    )
    (asserts! (> (len content) u0) err-invalid-input)
    (asserts! (<= (len content) u512) err-invalid-input)
    
    ;; Create post
    (map-set posts
      { post-id: current-post-id }
      {
        author: tx-sender,
        content: content,
        timestamp: current-time,
        likes: u0,
        reposts: u0,
        replies: u0,
        reputation-earned: u0,
        is-active: true,
        tags: tags
      }
    )
    
    ;; Update user stats
    (map-set users
      { user-address: tx-sender }
      (merge user-data { total-posts: (+ (get total-posts user-data) u1) })
    )
    
    (var-set next-post-id (+ current-post-id u1))
    (ok current-post-id)
  )
)