// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {UniToken} from "../src/UniToken.sol";

contract UniTokenTest is Test {
    UniToken internal t;
    address internal alice = address(0xA11CE);
    address internal bob = address(0xB0B);

    function setUp() public {
        t = new UniToken();
        vm.prank(address(this));
        t.transfer(alice, 1000 * 1e8);
    }

    function test_SupplyAndTransfer() public {
        vm.prank(alice);
        assertTrue(t.transfer(bob, 100 * 1e8));
        assertEq(t.balanceOf(bob), 100 * 1e8);
    }

    function test_ApproveAndTransferFrom() public {
        vm.prank(alice);
        assertTrue(t.approve(bob, 50 * 1e8));
        vm.prank(bob);
        assertTrue(t.transferFrom(alice, bob, 50 * 1e8));
        assertEq(t.balanceOf(bob), 50 * 1e8);
    }
}
