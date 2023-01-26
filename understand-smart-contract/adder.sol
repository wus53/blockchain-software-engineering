// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract adder {
    int256 total;

    constructor() {
        total = 0;
    }

    function getTotal() public view returns (int256) {
        return total;
    }

    function addToTotal(int256 add) public returns (int256) {
        total = total + add;
        return total;
    }

    function addToTotalConst(int256 add) public view returns (int256) {
        return total + add;
    }
}
