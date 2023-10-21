pragma solidity ^0.8.9;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "hardhat/console.sol";
import "./interfaces/ISyncRouter.sol";
import "./interfaces/IWeth.sol";

// https://onthis.xyz
/*
 .d88b.  d8b   db d888888b db   db d888888b .d8888. 
.8P  Y8. 888o  88    88    88   88    88    88   YP 
88    88 88V8o 88    88    88ooo88    88     8bo.   
88    88 88 V8o88    88    88   88    88       Y8b. 
`8b  d8' 88  V888    88    88   88    88    db   8D 
 `Y88P'  VP   V8P    YP    YP   YP Y888888P  8888Y  
*/

contract SyncSwapper is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    address public constant SYNC_ROUTER =
        0x80e38291e06339d10AAB483C65695D004dBD5C69;
    address public constant POOL = 0x814A23B053FD0f102AEEda0459215C2444799C70;
    address public constant USDC = 0x06eFdBFf2a14a7c8E15944D1F4A48F9F95F663A4;

    uint256[50] private _gap;

    function initialize() public initializer {
        __Ownable_init();
    }

    function swapAndProveLiqudity(address maker) public payable {
        address wETH = ISyncRouter(SYNC_ROUTER).wETH();

        IWeth(wETH).deposit{value: msg.value / 2}();

        bytes memory swapData = abi.encode(wETH, address(this), 2);

        ISyncRouter.SwapStep[] memory step = new ISyncRouter.SwapStep[](1);
        step[0] = ISyncRouter.SwapStep(
            POOL,
            swapData,
            0x0000000000000000000000000000000000000000,
            "0x"
        );

        ISyncRouter.SwapPath[] memory path = new ISyncRouter.SwapPath[](1);
        path[0] = ISyncRouter.SwapPath(
            step,
            0x0000000000000000000000000000000000000000,
            msg.value / 2
        );
        ISyncRouter(SYNC_ROUTER).swap{value: msg.value / 2}(
            path,
            0,
            block.timestamp
        );

        IWeth(wETH).approve(SYNC_ROUTER, IWeth(wETH).balanceOf(address(this)));
        IWeth(USDC).approve(SYNC_ROUTER, IWeth(USDC).balanceOf(address(this)));

        ISyncRouter.TokenInput[] memory inputs = new ISyncRouter.TokenInput[](
            2
        );
        inputs[0] = ISyncRouter.TokenInput(
            wETH,
            IWeth(wETH).balanceOf(address(this))
        );
        inputs[1] = ISyncRouter.TokenInput(
            USDC,
            IWeth(USDC).balanceOf(address(this))
        );
        bytes memory addLiqudityData = abi.encode(maker);
        ISyncRouter(SYNC_ROUTER).addLiquidity(
            POOL,
            inputs,
            addLiqudityData,
            0,
            0x0000000000000000000000000000000000000000,
            "0x"
        );
    }

    receive() external payable {
        swapAndProveLiqudity(msg.sender);
    }
}
