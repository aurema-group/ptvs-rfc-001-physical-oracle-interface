# APRIS Economic Model — Infrastructure Fee Architecture

## Overview

The APRIS module natively supports the sustainable economic model of the PTVS ecosystem through **atomic infrastructure fee deduction** during automated operations.

---

## Fee Structure

### 1. Platform Fee (PTCE Network)

- **Amount:** 15% of PTCE honorarios
- **Trigger:** Split payment via Stripe Connect when a PTCE invoices a client through the PTVS platform.
- **Recipient:** Aurema Group LLC (Delaware)
- **Purpose:** Access to the global PTCE network, methodology license, lead generation, and brand backing.

### 2. Royalty per QFER

- **Amount:** €150 - €500 per registered QFER (or 1-2% of PTCE honorarios)
- **Trigger:** On-chain injection of a QFER hash into the LO-PR Registry.
- **Recipient:** Aurema Group LLC (Delaware)
- **Purpose:** Right to use the "PTVS Verified" brand, methodology, and cryptographic anchoring.

### 3. Capex Release Micro-Fee

- **Amount:** 0.1% - 0.25% of released amount (or flat €50 per event)
- **Trigger:** `executeCapexRelease()` function call.
- **Recipient:** Aurema Group LLC (Delaware)
- **Purpose:** Infrastructure fee for deterministic escrow execution.
- **Example:** If €100,000 is released for roof repair, the fee is €100 - €250.

### 4. API Enterprise Subscription

- **Amount:** $1,000 - $5,000/month (depending on query volume)
- **Trigger:** Monthly billing via Stripe for LO-PR Registry queries.
- **Recipient:** Aurema Group LLC (Delaware)
- **Purpose:** High-performance infrastructure for banks and custodians.
- **Tiers:** Standard ($1,000), Professional ($2,500), Enterprise ($5,000).

### 5. Actuarial Data License

- **Amount:** $25,000 - $50,000/year + 0.5% basis point on PIPC premiums
- **Trigger:** Annual license agreement with insurers/reinsurers.
- **Recipient:** Aurema Group LLC (Delaware)
- **Purpose:** Access to the LGD Matrix and APRIS pricing function for PIPC policy issuance.

---

## Atomic Fee Deduction (Smart Contract)

The `executeCapexRelease()` function implements atomic fee deduction:

```solidity
function executeCapexRelease(
    bytes32 _assetId,
    uint256 _releaseAmount,
    bytes calldata _ptceSignature
) external nonReentrant {
    // 1. Verify PTCE signature
    require(_verifyPTCESignature(_ptceSignature), "Invalid PTCE signature");
    
    // 2. Enforce 72-hour cooldown
    require(
        block.timestamp >= lastCapexRelease[_assetId] + 72 hours,
        "Cooldown period not met"
    );
    
    // 3. Calculate infrastructure fee (0.15% default)
    uint256 fee = (_releaseAmount * 15) / 10000;
    uint256 netAmount = _releaseAmount - fee;
    
    // 4. Transfer fee to treasury
    IERC20(stablecoin).transfer(treasuryAddress, fee);
    
    // 5. Transfer net amount to beneficiary
    IERC20(stablecoin).transfer(beneficiary, netAmount);
    
    // 6. Update timestamp
    lastCapexRelease[_assetId] = block.timestamp;
    
    // 7. Emit event
    emit CapexEscrowReleased(_assetId, _releaseAmount, fee, netAmount, msg.sender);
}
