// SPDX-License-Identifier: CC-BY-ND-4.0
pragma solidity ^0.8.20;

/**
 * @title IPTVSClaimInjector
 * @author Forensics Oracle Initiative (PFOI)
 * @notice Interface for the Physical Oracle Interface (POI) defined in PTVS-RFC-001.
 * @dev Resolves the Physical Oracle Gap by anchoring eIDAS 2.0 QES-signed forensic 
 *      reports (QFER) to on-chain identity registries (ERC-3643 / ONCHAINID).
 *      Complies with Corpus Legislativum PTVS v1.0 (CL-PTVS I.5) and MiCA Art. 58.
 */
interface IPTVSClaimInjector {

    /// @notice Emitted when a valid Qualified Forensic Evidence Record (QFER) is anchored on-chain.
    /// @param assetId The unique identifier of the tokenized RWA (e.g., ISIN or Token Address).
    /// @param qferHash The SHA-256 / Keccak-256 hash of the PDF/A-3 forensic report.
    /// @param ptvsScore The deterministic physical integrity score (0-100).
    /// @param prrbRating The Prop Trust Risk Rating (1=AAA to 8=F).
    /// @param ptceAddress The Ethereum address of the Prop Trust Certified Expert (PTCE).
    /// @param timestamp The RFC 3161 Qualified Timestamp of the signature.
    event QFERInjected(
        bytes32 indexed assetId,
        bytes32 indexed qferHash,
        uint8 ptvsScore,
        uint8 prrbRating,
        address indexed ptceAddress,
        uint256 timestamp
    );

    /// @notice Emitted when a physical pathology triggers a protective circuit breaker.
    /// @dev Complies with MiCA Art. 58 (Operational Resilience).
    /// @param assetId The unique identifier of the tokenized RWA.
    /// @param reason The specific forensic trigger (e.g., "PTE-1: Structural Collapse", "PTE-3: Registry Divergence").
    /// @param timestamp The time of the circuit breaker activation.
    event ForensicFreezeTriggered(
        bytes32 indexed assetId,
        string reason,
        uint256 timestamp
    );

    /// @notice Emitted when the yield distribution is adjusted based on physical degradation.
    /// @param assetId The unique identifier of the tokenized RWA.
    /// @param newYieldBps The new yield in basis points.
    event YieldRatingAdjusted(
        bytes32 indexed assetId,
        uint256 newYieldBps
    );

    /**
     * @notice Injects a forensic claim into the on-chain registry.
     * @dev Must verify that msg.sender is a registered PTCE with active eIDAS 2.0 QES.
     * @param _assetId The ID of the RWA.
     * @param _qferHash The hash of the QFER.
     * @param _ptvsScore The 0-100 integrity score.
     * @param _prrbRating The risk rating.
     * @param _signature The cryptographic proof of the PTCE's QES.
     */
    function injectQFER(
        bytes32 _assetId,
        bytes32 _qferHash,
        uint8 _ptvsScore,
        uint8 _prrbRating,
        bytes calldata _signature
    ) external;

    /**
     * @notice Triggers a circuit breaker to halt secondary transfers of a compromised asset.
     * @dev Calls the underlying token contract's pause/freeze function.
     * @param _assetId The ID of the RWA.
     * @param _reason The PTE (Parametric Trigger Event) code.
     */
    function triggerCircuitBreaker(
        bytes32 _assetId,
        string calldata _reason
    ) external;
}
