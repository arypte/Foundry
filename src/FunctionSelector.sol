// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import { BytesLib } from './BytesLib.sol';
import {Test, console} from "forge-std/Test.sol";
import {Socket_Struct} from "./Socket_Struct.sol";


contract FunctionSelector {

    function getFunctionSelector(string memory _input) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(_input)));
    }

    function callTransfer(address to, uint256 amount, string memory _input) public pure returns (bytes memory) {
        bytes4 selector = getFunctionSelector(_input);
        return abi.encodeWithSelector(selector, to, amount);
    }


    function testqqq() public returns(bytes4){
    bytes4 selector = bytes4(keccak256("request(((bytes4,bytes16),(bytes32,bytes32,address,address,uint256,bytes)))"));
    // bytes4 selector = bytes4(keccak256("execute((bytes4,bytes16),(bytes32,bytes32,address,address,uint256,bytes))"));
    // console.logbtyes4
    // signature = "request((bytes4,bytes16),(bytes32,bytes32,address,address,uint256,bytes))"

    return selector;
    }

    function callDataDecodeStable(bytes memory _input) public pure returns(address,uint,uint256[] memory){

    bytes memory testData = BytesLib.slice(_input, 4, _input.length - 4);

    (address r1,uint r2,uint[] memory amountMins,,) = abi.decode(testData, (address,uint256,uint256[],address,uint256)); // removeLiquidityStableSwap
    // (address tokena,address tokenb,uint lq,uint b,uint a,address user,) = abi.decode(testData, (address,address,uint256,uint256,uint256,address,uint256)); // removeLiquidityStableSwap
     
    return (r1,r2,amountMins);
        
    }

    function callDataDecodeRemoveLq(bytes memory _input) public pure returns(address,address,uint, uint,address){

        bytes memory testData = BytesLib.slice(_input, 4, _input.length - 4);

        // (,,uint[] memory amountMins,,) = abi.decode(testData, (address,uint256,uint256[],address,uint256)); // removeLiquidityStableSwap
        (address tokena,address tokenb,uint lq,uint b,uint a,address user,) = abi.decode(testData, (address,address,uint256,uint256,uint256,address,uint256)); 
        
        return (tokena,tokenb,a,b,user);
        
    }

    enum ActionType {
        OneInchSwap,
        EverdexSwap,
        EverdexAddLiquidity,
        StargateBridge,
        CCCPV1Bridge,
        BTCFiDeposit,
        BTCFiRepay,
        EverdexRemoveLiquidity,
        EverdexStaking
    }

    struct Action {
        ActionType actionType;
        bytes actionData;
    }

    struct EverdexSwapAction {
        address targetContract;
        address[] path;
        bytes executionData;
        uint256 amountIn;
    }

    struct CCCPV1BridgeAction {
        address targetContract;
        address tokenAddressIn;
        bytes executionData;
        uint256 amountIn;
    }

    

    function execute(
        Action[] calldata _actionList,
        address _recipient,
        address _tokenAddr,
        uint256 _amount
    ) public returns(bytes memory){

        (CCCPV1BridgeAction memory actionData) = abi.decode(_actionList[0].actionData, (CCCPV1BridgeAction));
        bytes memory testData = BytesLib.slice(actionData.executionData, 4, actionData.executionData.length - 4);

        Socket_Struct.User_Request memory temp = abi.decode(testData, (Socket_Struct.User_Request));
        // console.logBytes(temp);
        // temp.Task_Params.amount = 1000 ;

        bytes4 signature;

        assembly {
            signature := mload(add(actionData.executionData, 32))
        }

        testData = abi.encodeWithSelector(signature, temp);

        // bytes memory returnValue = abi.encodeWithSelector

        return msg.data;

    }

    // function changeBridgeData(Action memory _action) public returns(bytes memory){
    //     (CCCPV1BridgeAction memory actionData) = abi.decode(_action.actionData, (CCCPV1BridgeAction));
    // }

    function changeChangeData(bytes memory _action) public returns(Socket_Struct.User_Request memory){
        (CCCPV1BridgeAction memory actionData) = abi.decode(_action, (CCCPV1BridgeAction));
        uint256 amount ;
        bytes memory testData = BytesLib.slice(actionData.executionData, 4, actionData.executionData.length - 4);

        // (,,uint[] memory amountMins,,) = abi.decode(testData, (address,uint256,uint256[],address,uint256)); // removeLiquidityStableSwap
        // (( , ) , ( , , , , amount, )) = abi.decode(testData, ((bytes4,bytes16),(bytes32,bytes32,address,address,uint256,bytes)) );
        Socket_Struct.User_Request memory temp = abi.decode(testData, (Socket_Struct.User_Request));
        // console.log(amount);
    
        // request(((bytes4,bytes16),(bytes32,bytes32,address,address,uint256,bytes)))

        return temp;

    }

    // function request(
    //     User_Request memory user_request
    // ) override external payable returns (bool) {
}

// swapExactETHForTokens(uint256,address[],address,uint256) 
//0x3f211408000000000000000000000000840cf4522ed96cbbeb0924672ea170456eea3a4c000000000000000000000000000000000000000000000002b5d1eb9d79a7800000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000f4f67e8fbd5071b11ba4266cc92e370588d8b1290000000000000000000000000000000000000000000000000384440ccc735c18000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

// struct CCCPV1BridgeAction {
//       address targetContract;
//       address tokenAddressIn;
//       bytes executionData;
//       uint256 amountIn;
// }