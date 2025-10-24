Stacks Auto Yield
The Stacks Auto Yield contract provides a fully on-chain, automated yield generation system for STX deposits.
It allows users to deposit STX, automatically accrue staking or lending rewards, and periodically compound yields back into their balance.
Designed for passive income, DeFi yield farming, and staking-as-a-service protocols.

Features
Auto-compounding STX yield mechanism
Fully decentralized — no manual yield collection needed
Time-based yield accrual based on block height
Configurable APY and reward rate (DAO controlled)
Transparent accounting of total deposits and yield distribution
Supports user deposits, withdrawals, and claims

Technical Overview
Language: Clarity
Purpose: Enable automatic yield generation for STX holders
Use Cases: DeFi yield farming, staking vaults, DAO treasury growth, savings protocols

Core -Functions
Function	-Description
deposit(amount)	-Lock STX into the yield system
compound()	-Automatically compounds yield for all eligible users
withdraw(amount)	-Withdraw principal plus accrued yield
claim-yield()	-Claim accumulated rewards without full withdrawal
set-apy(rate)	-Adjust APY (DAO/governance-controlled)
get-yield(user)	-Compute user’s current unclaimed yield
