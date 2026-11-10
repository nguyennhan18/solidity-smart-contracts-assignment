# Smart Contract Test Report

> Test status: source code has been prepared for Remix/Ganache. Replace each `Pending` entry below with the actual test outcome and filenames only after running it on your own Ganache workspace.

## 01 Storage
- **Function:** Stores and updates one unsigned integer on-chain.
- **Key concept:** Private state, constructor, view getter, and indexed `ValueSet` event.
- **Tests:** Deploy with `42`; call `get`; call `set(100)` and inspect the event.
- **Ganache proof:** Pending - save as `screenshots/01_compile.png`, `01_test1.png`.

## 02 Greeting
- **Function:** Stores a greeting that only the owner can change or reset.
- **Key concept:** Access control with `require` and change events.
- **Tests:** Read greeting; owner sets `GM Ganache`; non-owner set call must revert.
- **Ganache proof:** Pending - save as `screenshots/02_compile.png`, `02_test1.png`.

## 03 Counter
- **Function:** Increments, decrements, and resets a counter constrained to `0..100`.
- **Key concept:** Constants, boundary guards, and lifecycle events.
- **Tests:** Increment/decrement/reset; test the `MAX` and zero reverts.
- **Ganache proof:** Pending - save as `screenshots/03_compile.png`, `03_test1.png`.

## 04 Ownable / ProtectedVault
- **Function:** Accepts ETH deposits and lets only the current owner withdraw.
- **Key concept:** Inheritance and the `onlyOwner` modifier remove repeated authorization code.
- **Tests:** Deposit 1 ETH; reject non-owner withdrawal; transfer ownership then withdraw.
- **Ganache proof:** Pending - save as `screenshots/04_compile.png`, `04_test1.png`.

## 05 SimpleBank
- **Function:** Tracks each user's deposits and permits withdrawals of their own balance.
- **Key concept:** Checks-Effects-Interactions updates the balance before the external ETH call.
- **Tests:** Deposit from two accounts; reject over-withdrawal; withdraw 1 ETH.
- **Ganache proof:** Pending - save as `screenshots/05_compile.png`, `05_test1.png`.

## 06 Voting
- **Function:** Lets the chairperson authorize voters and determines the leading candidate.
- **Key concept:** Structs, mappings, one-vote guard, and array iteration.
- **Tests:** Authorize three voters; vote; reject repeat and unauthorized votes; read winner.
- **Ganache proof:** Pending - save as `screenshots/06_compile.png`, `06_test1.png`.

## 07 MyToken
- **Function:** Implements core fungible-token transfers, approvals, and delegated transfers.
- **Key concept:** Nested allowance mapping and ERC-20-style approval flow.
- **Tests:** Transfer 500; approve 200; `transferFrom`; reject exhausted allowance.
- **Ganache proof:** Pending - save as `screenshots/07_compile.png`, `07_test1.png`.

## 08 Crowdfunding
- **Function:** Raises funds before a deadline, then pays the owner or refunds contributors.
- **Key concept:** Deadline state, contribution mapping, and one-shot safe refunds.
- **Tests:** Run a goal-met claim and failed-goal refund; reject a second refund.
- **Ganache proof:** Pending - save as `screenshots/08_compile.png`, `08_test1.png`.

## 09 Lottery
- **Function:** Collects fixed-fee entries and pays the complete pot to one selected player.
- **Key concept:** Dynamic player list and pseudo-random `blockhash` selection.
- **Tests:** Enter five players; reject wrong fee; select winner and start a new round.
- **Ganache proof:** Pending - save as `screenshots/09_compile.png`, `09_test1.png`. Blockhash randomness is not production-safe; use Chainlink VRF in production.

## 10 TimeLockVault
- **Function:** Holds ETH for a beneficiary until a configured unlock time.
- **Key concept:** `block.timestamp`, beneficiary authorization, and time extension.
- **Tests:** Deposit; reject early withdrawal; wait until expiry; withdraw successfully.
- **Ganache proof:** Pending - save as `screenshots/10_compile.png`, `10_test1.png`.

## 11 Escrow
- **Function:** Escrows buyer payment until delivery, refund, or arbiter dispute resolution.
- **Key concept:** Enum state machine and modifiers that enforce valid transitions.
- **Tests:** Test delivery, seller refund, and both arbiter outcomes; reject delivery while disputed.
- **Ganache proof:** Pending - save as `screenshots/11_compile.png`, `11_test1.png`.

## 12 SimpleNFT
- **Function:** Mints unique NFTs, transfers ownership, and supports per-token approval.
- **Key concept:** Token-ID ownership mapping and ERC-721-style delegated transfer.
- **Tests:** Mint two tokens; reject wrong payment; transfer and approved `transferFrom`; withdraw revenue.
- **Ganache proof:** Pending - save as `screenshots/12_compile.png`, `12_test1.png`.

## 13 EnglishAuction
- **Function:** Runs a timed auction with refunds for outbid participants.
- **Key concept:** Pull-payment pattern avoids pushing ETH while receiving a new bid.
- **Tests:** Place valid bids; reject too-low bid; withdraw pending return; end after expiry.
- **Ganache proof:** Pending - save as `screenshots/13_compile.png`, `13_test1.png`. Unlike Contract 05, refunds here are explicitly pulled by losing bidders.

## 14 MultisigWallet
- **Function:** Executes an ETH transfer only after the required owners confirm it.
- **Key concept:** N-of-M approval mapping, auto-execution, and executed-state guard.
- **Tests:** Fund wallet; submit 1 ETH transfer; obtain two confirmations; reject duplicate/non-owner calls.
- **Ganache proof:** Pending - save as `screenshots/14_compile.png`, `14_test1.png`.

## 15 StakingRewards
- **Function:** Lets users stake ETH and collect time-based ETH rewards from a funded pool.
- **Key concept:** Per-user reward debt, timestamps, reward-pool cap, and Checks-Effects-Interactions.
- **Tests:** Stake two users; verify pending reward; claim; unstake; reject second unstake.
- **Ganache proof:** Pending - save as `screenshots/15_compile.png`, `15_test1.png`.
