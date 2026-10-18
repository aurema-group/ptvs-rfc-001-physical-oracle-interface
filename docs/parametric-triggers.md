# APRIS Parametric Trigger Events (PTEs) — Full Specification

## Overview

Parametric Trigger Events (PTEs) are predefined forensic conditions that, when verified by a Prop Trust Certified Expert (PTCE) with a valid eIDAS 2.0 QES signature, trigger deterministic smart contract responses in the APRIS module.

---

## PTE-1: Structural Collapse / Critical Pathology

**Trigger Condition:** A PTCE certifies that the physical asset has suffered structural collapse or critical pathology that renders it uninhabitable or non-operational.

**APRIS Response:**
1. Emit `ForensicFreezeTriggered` event.
2. Call `ITokenTransferPolicy(tokenPolicyContract).setTokenPaused(true)`.
3. Notify PIPC insurance contract for potential payout.

**MiCA Reference:** Art. 58 (Operational Resilience)

**Reversal Condition:** Requires a new QFER from a PTCE certifying that the pathology has been remediated.

---

## PTE-2: PRRB Downgrade to Speculative

**Trigger Condition:** A PTCE certifies that the PRRB (Prop Trust Risk Rating) of the asset has dropped to BB or below (speculative grade).

**APRIS Response:**
1. Emit `YieldRatingAdjusted` event with new yield (e.g., from 500 bps to 200 bps).
2. Redirect all future distributions to the maintenance escrow.
3. Mandate annual re-audit (per CL-PTVS I.3).

**MiCA Reference:** Art. 36.8 (Reserve Sufficiency)

**Reversal Condition:** PRRB upgrade to investment grade (BBB or above) via new QFER.

---

## PTE-3: Registry Divergence / Double Pledge

**Trigger Condition:** A PTCE certifies that the LO-PR Registry shows a divergence with the physical registry (e.g., the asset has been pledged to a third party not recorded on-chain).

**APRIS Response:**
1. Emit `ForensicFreezeTriggered` event.
2. Halt all secondary transfers.
3. Invoke `AtomicReceiver` protocol (CL-PTVS IV.4).
4. Notify all token holders via on-chain event.

**MiCA Reference:** Art. 46 (Custody & Segregation)

**Reversal Condition:** Requires multi-signature validation from 3 independent PTCEs confirming the divergence has been resolved.

---

## PTE-4: Telemetry Loss > 72h

**Trigger Condition:** Vector V5 (telemetry) has been inactive for more than 72 hours without a valid PTCE override.

**APRIS Response:**
1. Automatic PRRB downgrade by one notch.
2. Emit `YieldRatingAdjusted` event.
3. Mandate mandatory re-inspection within 7 days.

**MiCA Reference:** Art. 58 (Business Continuity)

**Reversal Condition:** Reactivation of telemetry + PTCE certification of asset integrity.

---

## PTE-5: Operator Control Loss

**Trigger Condition:** The asset operator has lost control or is obstructing PTCE access for more than 30 days.

**APRIS Response:**
1. Invoke `AtomicReceiver` protocol.
2. Transfer administrative control to the designated bankruptcy-remote receiver.
3. Emit `AtomicReceiverInvoked` event.

**CL-PTVS Reference:** Liber IV, Clause 4 (Atomic Receiver Protocol)

**Reversal Condition:** Requires court order or multi-signature PTCE validation.
