// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {UniToken} from "../src/UniToken.sol";
import {MultiTransfer} from "../src/MultiTransfer.sol";

/// forge script script/Deploy.s.sol:Deploy --rpc-url $RPC_URL --broadcast
contract Deploy is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        UniToken token = new UniToken();
        MultiTransfer batch = new MultiTransfer();
        batch.setToken(token);

        console2.log("UniToken", address(token));
        console2.log("MultiTransfer", address(batch));

        vm.stopBroadcast();
    }
}
