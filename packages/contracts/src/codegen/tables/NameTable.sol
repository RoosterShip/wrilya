// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

library NameTable {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "app", name: "NameTable", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746261707000000000000000000000004e616d655461626c6500000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0000000100000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes32)
  Schema constant _keySchema = Schema.wrap(0x002001005f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (string)
  Schema constant _valueSchema = Schema.wrap(0x00000001c5000000000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "id";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](1);
    fieldNames[0] = "value";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get value.
   */
  function getValue(bytes32 id) internal view returns (string memory value) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get value.
   */
  function _getValue(bytes32 id) internal view returns (string memory value) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get value.
   */
  function get(bytes32 id) internal view returns (string memory value) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get value.
   */
  function _get(bytes32 id) internal view returns (string memory value) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Set value.
   */
  function setValue(bytes32 id, string memory value) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((value)));
  }

  /**
   * @notice Set value.
   */
  function _setValue(bytes32 id, string memory value) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((value)));
  }

  /**
   * @notice Set value.
   */
  function set(bytes32 id, string memory value) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((value)));
  }

  /**
   * @notice Set value.
   */
  function _set(bytes32 id, string memory value) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((value)));
  }

  /**
   * @notice Get the length of value.
   */
  function lengthValue(bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of value.
   */
  function _lengthValue(bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of value.
   */
  function length(bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of value.
   */
  function _length(bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of value.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemValue(bytes32 id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of value.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemValue(bytes32 id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of value.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItem(bytes32 id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of value.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItem(bytes32 id, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Push a slice to value.
   */
  function pushValue(bytes32 id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to value.
   */
  function _pushValue(bytes32 id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to value.
   */
  function push(bytes32 id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to value.
   */
  function _push(bytes32 id, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from value.
   */
  function popValue(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from value.
   */
  function _popValue(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from value.
   */
  function pop(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from value.
   */
  function _pop(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Update a slice of value at `_index`.
   */
  function updateValue(bytes32 id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of value at `_index`.
   */
  function _updateValue(bytes32 id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of value at `_index`.
   */
  function update(bytes32 id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of value at `_index`.
   */
  function _update(bytes32 id, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(string memory value) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(bytes(value).length);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(string memory value) internal pure returns (bytes memory) {
    return abi.encodePacked(bytes((value)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(string memory value) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData;
    EncodedLengths _encodedLengths = encodeLengths(value);
    bytes memory _dynamicData = encodeDynamic(value);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(bytes32 id) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = id;

    return _keyTuple;
  }
}
