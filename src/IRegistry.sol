pragma solidity 0.8.17;

interface IRegistry {
    /// @notice The number of pools currently registered within the contract.
    function pool_count() external view returns (uint256);

    /// @notice Master list of registered pool addresses.
    /// @dev Note that the ordering of this list is not fixed. Index values of addresses may change as pools are
    ///      added or removed.
    /// @dev Querying values greater than `Registry.pool_count` returns `0x0`.
    function pool_list(uint256 i) external view returns (address pool);

    /// @notice Get the pool address for a given Curve LP token.
    function get_pool_from_lp_token(address token) external view returns (address pool);

    /// @notice Get the LP token address for a given Curve pool.
    function get_lp_token(address pool) external view returns (address);

    /// @notice Finds a pool that allows for swaps between `from` and `to`. You can optionally include `i` to get the
    ///         n-th pool, when multiple pools exist for the given pairing.
    /// @dev The order of `from` and `to` does not affect the result.
    /// @dev Returns 0x00 when swaps are not possible for the pair or `i` exceeds the number of available pools.
    function find_pool_for_coins(address from, address to, uint256 i) external view returns (address pool);

    /// @notice Get the number of coins and underlying coins within a pool.
    /// @return A fixed array with the first element being the number of coins that the pool directly within the pool,
    ///         and the second element being the number of underlying coins within the pool.
    function get_n_coins(address pool) external view returns (uint256[2] memory);

    /// @notice Get a list of the swappable coins within a pool.
    function get_coins(address pool) external view returns (address[8] memory);

    /// @notice Get a list of the swappable underlying coins within a pool.
    /// @dev For pools that do not involve lending, the return value is identical to `Registry.get_coins`.
    function get_underlying_coins(address pool) external view returns (address[8] memory);

    /// @notice Get the number of decimals for each coin within a pool.
    function get_decimals(address pool) external view returns (uint256[8] memory);

    /// @notice Get a list of decimal places for each underlying coin within a pool.
    /// @dev For pools that do not involve lending, the return value is identical to `Registry.get_decimals`.
    /// @dev Non-lending coins that still involve querying a rate (e.g. renBTC) are marked as having 0 decimals.
    function get_underlying_decimals(address pool) external view returns (uint256[8] memory);

    /// @notice Convert coin addresses into indices for use with pool methods.
    function get_coin_indices(address pool, address from, address to)
        external
        view
        returns (
            int128 i,
            int128 j,
            bool underlying
        );

    /// @notice Get available balances for each coin within a pool.
    /// @dev These values are not necessarily the same as calling `Token.balanceOf(pool)` as the total balance
    ///      also includes unclaimed admin fees.
    function get_balances(address pool) external view returns (uint256[8] memory);

    /// @notice Get balances for each underlying coin within a pool.
    /// @dev For pools that do not involve lending, the return value is identical to `Registry.get_balances`.
    function get_underlying_balances(address pool) external view returns (uint256[8] memory);

    /// @notice Get the current admin balances (uncollected fees) for a pool.
    function get_admin_balances(address) external view returns (uint256[8] memory);

    /// @notice Get the exchange rates between coins and underlying coins within a pool, normalized to a 1e18 precision.
    /// @dev For non-lending pools or non-lending coins within a lending pool, the rate is 1e18.
    function get_rates(address pool) external view returns (uint256[8] memory);

    /// @notice Get the virtual price of a pool's LP token.
    function get_virtual_price_from_lp_token(address pool) external view returns (uint256);

    /// @notice Get the current amplification coefficient for a pool.
    function get_A(address pool) external view returns (uint256);

    /// @notice Get the fees for a pool.
    /// @dev Fees are expressed as integers with a 1e10 precision. The first value is the total fee, the second is
    ///      the percentage of the fee taken as an admin fee.
    function get_fees(address pool) external view returns (uint256[2] memory);

    /// @notice Get all parameters for a given pool.
    /// @dev For older pools where `initial_A` is not public, this value is set to 0.
    function get_parameters(address pool)
        external
        view
        returns (
            uint256 A,
            uint256 future_A,
            uint256 fee,
            uint256 admin_fee,
            uint256 future_admin_fee,
            address future_owner,
            uint256 initial_A,
            uint256 initial_A_time,
            uint256 future_A_time
        );

    /// @notice Get an estimate on the upper bound for gas used in an exchange.
    function estimate_gas_used(address pool, address from, address to) external view returns (uint256);

    /// @notice Get a boolean identifying whether pool is a metapool.
    function is_meta(address pool) external view returns (bool);

    /// @notice Get the name given to a pool upon registration.
    function get_pool_name(address pool) external view returns (string memory);

    /// @notice Get the asset type of specific pool as an integer.
    function get_pool_asset_type(address pool) external view returns (uint256);

    /// @notice Get the address of the Curve DAO GaugeController contract.
    function gauge_controller() external view returns (address);

    /// @notice Get a list of `LiquidityGauge` contracts associated with a pool, and their gauge types.
    function get_gauge(address pool) external view returns (address[10] memory gauges, int128[10] memory types);

    /// @notice Get the total number of unique coins throughout all registered curve pools.
    function coin_count() external view returns (uint256);

    /// @notice Get the _i-th_ unique coin throughout all registered curve pools.
    /// @dev Returns `0x0000000000000000000000000000000000000000` for values of `i` greater than the return value of
    ///      `Registry.coin_count`.
    function get_coin(uint256 i) external view returns (address);

    /// @notice Get the total number of unique swaps available for coin.
    function get_coin_swap_count(address coin) external view returns (uint256);

    /// @notice Get the _i-th_ unique coin available for swapping against coin across all registered curve pools.
    function get_coin_swap_complement(address coin, uint256 i) external view returns (address);

    /// @notice Get the epoch time of the last registry update.
    function last_updated() external view returns (uint256);
}