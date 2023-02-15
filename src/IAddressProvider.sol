pragma solidity 0.8.17;

/// @notice The default deployment of the `AddressProvider` contract on chains that support Curve
IAddressProvider constant DEFAULT_DEPLOYMENT = IAddressProvider(0x0000000022D53366457F9d5E68Ec105046FC4383);

interface IAddressProvider {
    /// @notice Get the address of the main registry contract
    /// @dev This is a gas-efficient way of calling `AddressProvider.get_address(0)`
    /// @return main registry contract
    function get_registry() external view returns (address);

    /// @notice Get the highest ID set within the address provider
    /// @return max ID
    function max_id() external view returns (uint256);

    /// @notice Fetch the address associated with `id`
    /// @dev Returns ZERO_ADDRESS if `id` has not been defined, or has been unset
    /// @param id Identifier to fetch an address for
    /// @return Current address associated to `id`
    function get_address(uint256 id) external view returns (address);

    /// @notice Fetch information about the given id.
    /// @param id Identifier to fetch an address for
    /// @return addr Address associated to the ID.
    /// @return active Is the address at this ID currently set?
    /// @return Version Version of the current ID. Each time the address is modified, this number increments.
    /// @return lastModified Epoch timestamp this ID was last modified.
    /// @return description Human-readable description of the ID.
    function get_id_info(uint256 id)
        external
        view
        returns (
            address addr,
            bool active,
            uint256 version,
            uint256 lastModified,
            string memory description
        );
}