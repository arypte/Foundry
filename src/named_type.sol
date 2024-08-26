// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.0;

/**
* @title TODO__Comment
* @author Bifrost
*/

type ChainIndex is bytes4;
type RBCmethod is bytes16;
type Asset_Index is bytes32;

library named_type {
    function eq(ChainIndex self, ChainIndex other) internal pure returns (bool) {
        return ChainIndex.unwrap(self) == ChainIndex.unwrap(other);
    }
    function ne(ChainIndex self, ChainIndex other) internal pure returns (bool) {
        return ChainIndex.unwrap(self) != ChainIndex.unwrap(other);
    }

    function eq(RBCmethod self, RBCmethod other) internal pure returns (bool) {
        return RBCmethod.unwrap(self) == RBCmethod.unwrap(other);
    }
    function ne(RBCmethod self, RBCmethod other) internal pure returns (bool) {
        return RBCmethod.unwrap(self) != RBCmethod.unwrap(other);
    }

    function eq(Asset_Index self, Asset_Index other) internal pure returns (bool) {
        return Asset_Index.unwrap(self) == Asset_Index.unwrap(other);
    }
    function ne(Asset_Index self, Asset_Index other) internal pure returns (bool) {
        return Asset_Index.unwrap(self) != Asset_Index.unwrap(other);
    }
    function ne(Asset_Index self, bytes16 other) internal pure returns (bool) {
        return Asset_Index.unwrap(self) != other;
    }

    function get_asset_type(Asset_Index asset_index) internal pure returns (uint8) {
        return uint8(Asset_Index.unwrap(asset_index)[7]);
    }
    function get_symbol_type(Asset_Index asset_index) internal pure returns (uint8) {
        return uint8(Asset_Index.unwrap(asset_index)[3]);
    }
    function get_method_type(RBCmethod _method) internal pure returns (uint8) {
        return uint8(RBCmethod.unwrap(_method)[2]);
    }
    function get_asset_chain(Asset_Index asset_index) internal pure returns (ChainIndex) {
        bytes32 _asset_index = Asset_Index.unwrap(asset_index);
        bytes4 _chain_index = bytes4( _asset_index<<64 );
        return ChainIndex.wrap( _chain_index );
    }
}