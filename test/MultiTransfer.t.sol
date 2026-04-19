// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MultiTransfer} from "../src/MultiTransfer.sol";
import {UniToken} from "../src/UniToken.sol";

contract MultiTransferTest is Test {
    MultiTransfer internal m;
    UniToken internal token;
    address internal a = address(0xA);
    address internal b = address(0xB);

    function setUp() public {
        token = new UniToken();
        m = new MultiTransfer();
        m.setToken(token);
        token.transfer(address(m), 500 * 1e8);
        m.pushWallet(a);
        m.pushWallet(b);
    }

    function test_MultiTransferDistributes() public {
        m.multiTransfer(100 * 1e8);
        assertEq(token.balanceOf(a), 100 * 1e8);
        assertEq(token.balanceOf(b), 100 * 1e8);
        assertEq(token.balanceOf(address(m)), 300 * 1e8);
    }

    function test_RevertWhenInsufficient() public {
        // 2 получателя × 300 > 500 на балансе контракта
        vm.expectRevert(
            abi.encodeWithSelector(
                MultiTransfer.InsufficientContractBalance.selector, 600 * 1e8, 500 * 1e8
            )
        );
        m.multiTransfer(300 * 1e8);
    }
}
