# 🛡️ Solidity & Foundry Pre-Audit Security Checklist

A concise, practical security reference for Solidity developers and DeFi teams preparing smart contracts for mainnet deployment or external audits.

## 🔍 Top 5 Critical Vulnerability Vectors

1. **ERC-4626 First-Depositor Share Inflation**
   - Always protect vault share pricing against `1 wei` deposit + direct token donation manipulation using OpenZeppelin's virtual shares/assets offset or dead shares.
2. **Read-Only Reentrancy on View Functions**
   - Ensure external protocols reading share prices or pool reserves cannot observe stale intermediate balances during active state transitions.
3. **Stale Chainlink Oracle Feeds & L2 Sequencer Uptime**
   - Validate `updatedAt > 0`, enforce strict heartbeat thresholds (`block.timestamp - updatedAt <= MAX_DELAY`), and check L2 sequencer uptime feeds on Arbitrum, Optimism, and Base.
4. **Non-Standard ERC-20 Token Edge Cases**
   - Measure actual received balances (`balanceAfter - balanceBefore`) for fee-on-transfer tokens and always use `SafeERC20` for tokens missing boolean return values.
5. **Stateful Invariant Fuzzing Over Unit Tests**
   - Model multi-actor adversarial sequences with ghost variables in **Foundry** to verify protocol solvency across thousands of randomized calls.

---

## 📦 Full 45-Point Pre-Audit Checklist & Foundry Vault Invariant Suite

Want the complete, structured **45-Point Smart Contract Pre-Audit Checklist** along with a ready-to-run **Foundry Vault Invariant & Solvency Test Template (`VaultInvariant.t.sol`)**?

👉 **[Get the ZeroCentPlus Security Kit ($29)](https://framer.website)**

---

*Research & Security Tooling by [ZeroCentPlus](https://framer.website)*
