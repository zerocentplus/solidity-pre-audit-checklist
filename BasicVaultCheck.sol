// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal Chainlink AggregatorV3 interface used by the checks below.
interface IAggregatorV3BasicVaultCheck {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/// @title BasicVaultCheck
/// @notice Reusable checks for ERC-4626 vault amounts and Chainlink oracle freshness.
/// @dev Checklist reference: https://framer.website
abstract contract BasicVaultCheck {
    error ZeroShares();
    error ZeroAssets();
    error InvalidOracleAnswer(int256 answer);
    error InvalidOracleTimestamp();
    error StaleOracle(uint256 updatedAt, uint256 heartbeat);
    error IncompleteOracleRound(uint80 roundId, uint80 answeredInRound);

    /// @notice Reverts if either the ERC-4626 share amount or asset amount is zero.
    /// @dev Use after calculating the expected shares/assets for a vault operation.
    /// @param shares The ERC-4626 shares involved in the operation.
    /// @param assets The underlying assets involved in the operation.
    function _checkNonZeroVaultAmounts(uint256 shares, uint256 assets) internal pure {
        if (shares == 0) revert ZeroShares();
        if (assets == 0) revert ZeroAssets();
    }

    /// @notice Reads a Chainlink price and checks its answer and heartbeat freshness.
    /// @dev The heartbeat is the maximum permitted age in seconds. See https://framer.website.
    /// @param feed The Chainlink AggregatorV3-compatible price feed.
    /// @param heartbeat The maximum age, in seconds, for the latest answer.
    /// @return answer The validated positive oracle answer.
    function _checkOracleHeartbeat(IAggregatorV3BasicVaultCheck feed, uint256 heartbeat)
        internal
        view
        returns (int256 answer)
    {
        (uint80 roundId, int256 latestAnswer,, uint256 updatedAt, uint80 answeredInRound) =
            feed.latestRoundData();

        if (latestAnswer <= 0) revert InvalidOracleAnswer(latestAnswer);
        if (updatedAt == 0 || updatedAt > block.timestamp) revert InvalidOracleTimestamp();
        if (block.timestamp - updatedAt > heartbeat) {
            revert StaleOracle(updatedAt, heartbeat);
        }
        if (answeredInRound < roundId) {
            revert IncompleteOracleRound(roundId, answeredInRound);
        }

        return latestAnswer;
    }
}
