// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function token0() external view returns (address);

    function token1() external view returns (address);
}

contract WBTCUSDTPriceChecker {
    address public immutable wbtcAddress;
    address public immutable usdcAddress;
    address public immutable uniswapPair;

    constructor(
        address _wbtcAddress,
        address _usdcAddress,
        address _uniswapPair
    ) {
        wbtcAddress = _wbtcAddress;
        usdcAddress = _usdcAddress;
        uniswapPair = _uniswapPair;
    }

    function getWBTCPriceInUSDT() external view returns (uint256) {
        IUniswapV2Pair swapPair = IUniswapV2Pair(uniswapPair);

        (uint112 reserve0, uint112 reserve1, ) = swapPair.getReserves();

        address token0 = swapPair.token0();
        address token1 = swapPair.token1();

        if (token0 == wbtcAddress && token1 == usdcAddress) {
            // WBTC is token0, USDC is token1
            return (uint256(reserve1) * 1e18) / uint256(reserve0);
        } else if (token0 == usdcAddress && token1 == wbtcAddress) {
            // USDT is token0, WBTC is token1
            return (uint256(reserve0) * 1e18) / uint256(reserve1);
        } else {
            revert("Pair does not match WBTC-USDT");
        }
    }
}