// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.0;

import "./named_type.sol";

/**
* @title TODO__Comment
* @author Bifrost
*/
abstract contract Socket_Struct {
    using named_type for ChainIndex;    // size 4
    using named_type for RBCmethod;     // size 16
    using named_type for Asset_Index;   // size 32

    struct User_Request {
        Instruction ins_code;   // size 24
        Task_Params params;
    }
    function _hash_req(User_Request memory _req) internal pure returns (bytes32) {
        return keccak256( abi.encode(_req) );
    }

    struct Instruction {    // size 24
        ChainIndex chain;   // size 4
        RBCmethod method;   // size 16
    }

    struct Task_Params {
        Asset_Index tokenIDX0;  // size 32
        Asset_Index tokenIDX1;  // size 32
        address refund;         // size 20
        address to;             // size 20
        uint256 amount;         // size 32
        bytes variants;
    }

    struct RequestID {      // size 32
        ChainIndex chain;   // size 4
        uint64 round_id;    // size 8
        uint128 sequence;   // size 16
    }
    function _rid_pack(RequestID memory _rid) internal pure returns (bytes32) {
        return bytes32( abi.encodePacked(_rid.chain, _rid.round_id, _rid.sequence) );
    }

    struct RequestInfo {
        uint8[32] field;
        bytes32 msg_hash;
        uint256 registered_time;
    }

    struct Poll_Submit {
        Socket_Message msg;
        Signatures sigs;
        uint256 option;
    }

    struct Socket_Message {
        RequestID req_id;
        Task_Status status;
        Instruction ins_code;
        Task_Params params;
    }

    struct Signatures {
        bytes32[] r;
        bytes32[] s;
        bytes     v;
    }

    struct Round_Up_Submit {
        uint256 round;
        address[] new_relayers;
        Signatures sigs;
    }

    enum Task_Status {
        None,
        Requested,
        Failed,
        Executed,
        Reverted,
        Accepted,
        Rejected,
        Committed,
        Rollbacked,
        Round_Up,
        Round_Up_Committed
    }

    enum Service_ID {
        None,
        Oracle,
        Swap,
        Lending,
        Reserved
    }
}