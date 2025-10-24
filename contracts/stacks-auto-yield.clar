;; Define the yield strategy trait
(define-trait yield-strategy-trait (
    (harvest () (response uint uint))
))

(define-constant ADMIN tx-sender)
(define-constant contract-owner tx-sender)
(define-data-var total-deposits uint u0)
(define-data-var reward-pool uint u0)
(define-map user-balances { user: principal } uint)
(define-data-var strategy-contract (optional principal) none)

;; -------------------------------
;; Deposit STX into Yield Vault
;; -------------------------------
(define-public (deposit (amount uint))
  (begin
    (asserts! (> amount u0) (err u100)) ;; Minimum deposit check
    (match (stx-transfer? amount tx-sender (as-contract tx-sender))
      transfer-ok (begin
                    (let ((current-balance (default-to u0 (map-get? user-balances { user: tx-sender }))))
                      (map-set user-balances { user: tx-sender } (+ current-balance amount))
                      (var-set total-deposits (+ (var-get total-deposits) amount))
                      (ok true)))
      transfer-err (err transfer-err))
  )
)

;; -------------------------------
;; Withdraw STX + Yield Rewards
;; -------------------------------
(define-public (withdraw (amount uint))
  (let ((balance (default-to u0 (map-get? user-balances { user: tx-sender }))))
    (begin
      (asserts! (> amount u0) (err u107)) ;; Amount must be greater than zero
      (asserts! (>= balance amount) (err u102)) ;; Insufficient funds
      (match (stx-transfer? amount (as-contract tx-sender) tx-sender)
        transfer-ok (begin
                     (map-set user-balances { user: tx-sender } (- balance amount))
                     (var-set total-deposits (- (var-get total-deposits) amount))
                     (ok true))
        transfer-err (err transfer-err))
    )
  )
)

;; -------------------------------
;; Auto-Compounding Function (Harvest from Strategy)
;; -------------------------------
(define-public (auto-compound)
  (match (var-get strategy-contract)
    some-strategy (ok true)
    (err u105)))

;; ------------------------------- 
;; Set Yield Strategy Contract (Admin Only)
;; -------------------------------
(define-public (set-strategy)
  (begin
    (asserts! (is-eq tx-sender ADMIN) (err u104)) ;; Only admin can set strategy
    (var-set strategy-contract (some tx-sender))
    (ok true)))

;; -------------------------------
;; Get User Balance
;; -------------------------------
(define-read-only (get-user-balance (user principal))
  (ok (default-to u0 (map-get? user-balances { user: user })))
)

;; -------------------------------
;; Get Total Deposits
;; -------------------------------
(define-read-only (get-total-deposits)
  (ok (var-get total-deposits))
)

;; -------------------------------
;; Get Active Strategy Contract
;; -------------------------------
(define-read-only (get-strategy)
  (ok (var-get strategy-contract))
)

;; -------------------------------
;; Get Reward Pool
;; -------------------------------
(define-read-only (get-reward-pool)
  (ok (var-get reward-pool))
)