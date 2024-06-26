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

// Import user types
import { FieldEnum } from "./../common.sol";

struct VoidsmanRequirementsTableData {
  uint256 xp;
  uint8[] competencies;
  uint8[] stats;
}

library VoidsmanRequirementsTable {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "game", name: "VoidsmanRequirem", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746267616d6500000000000000000000566f6964736d616e526571756972656d);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0020010220000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (uint8, uint8)
  Schema constant _keySchema = Schema.wrap(0x0002020000000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint256, uint8[], uint8[])
  Schema constant _valueSchema = Schema.wrap(0x002001021f626200000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](2);
    keyNames[0] = "level";
    keyNames[1] = "field";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](3);
    fieldNames[0] = "xp";
    fieldNames[1] = "competencies";
    fieldNames[2] = "stats";
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
   * @notice Get xp.
   */
  function getXp(uint8 level, FieldEnum field) internal view returns (uint256 xp) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get xp.
   */
  function _getXp(uint8 level, FieldEnum field) internal view returns (uint256 xp) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set xp.
   */
  function setXp(uint8 level, FieldEnum field, uint256 xp) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((xp)), _fieldLayout);
  }

  /**
   * @notice Set xp.
   */
  function _setXp(uint8 level, FieldEnum field, uint256 xp) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((xp)), _fieldLayout);
  }

  /**
   * @notice Get competencies.
   */
  function getCompetencies(uint8 level, FieldEnum field) internal view returns (uint8[] memory competencies) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Get competencies.
   */
  function _getCompetencies(uint8 level, FieldEnum field) internal view returns (uint8[] memory competencies) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Set competencies.
   */
  function setCompetencies(uint8 level, FieldEnum field, uint8[] memory competencies) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((competencies)));
  }

  /**
   * @notice Set competencies.
   */
  function _setCompetencies(uint8 level, FieldEnum field, uint8[] memory competencies) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((competencies)));
  }

  /**
   * @notice Get the length of competencies.
   */
  function lengthCompetencies(uint8 level, FieldEnum field) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of competencies.
   */
  function _lengthCompetencies(uint8 level, FieldEnum field) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of competencies.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemCompetencies(uint8 level, FieldEnum field, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Get an item of competencies.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemCompetencies(uint8 level, FieldEnum field, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Push an element to competencies.
   */
  function pushCompetencies(uint8 level, FieldEnum field, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to competencies.
   */
  function _pushCompetencies(uint8 level, FieldEnum field, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from competencies.
   */
  function popCompetencies(uint8 level, FieldEnum field) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop an element from competencies.
   */
  function _popCompetencies(uint8 level, FieldEnum field) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Update an element of competencies at `_index`.
   */
  function updateCompetencies(uint8 level, FieldEnum field, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of competencies at `_index`.
   */
  function _updateCompetencies(uint8 level, FieldEnum field, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get stats.
   */
  function getStats(uint8 level, FieldEnum field) internal view returns (uint8[] memory stats) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Get stats.
   */
  function _getStats(uint8 level, FieldEnum field) internal view returns (uint8[] memory stats) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Set stats.
   */
  function setStats(uint8 level, FieldEnum field, uint8[] memory stats) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((stats)));
  }

  /**
   * @notice Set stats.
   */
  function _setStats(uint8 level, FieldEnum field, uint8[] memory stats) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((stats)));
  }

  /**
   * @notice Get the length of stats.
   */
  function lengthStats(uint8 level, FieldEnum field) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of stats.
   */
  function _lengthStats(uint8 level, FieldEnum field) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of stats.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemStats(uint8 level, FieldEnum field, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Get an item of stats.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemStats(uint8 level, FieldEnum field, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Push an element to stats.
   */
  function pushStats(uint8 level, FieldEnum field, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to stats.
   */
  function _pushStats(uint8 level, FieldEnum field, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from stats.
   */
  function popStats(uint8 level, FieldEnum field) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 1, 1);
  }

  /**
   * @notice Pop an element from stats.
   */
  function _popStats(uint8 level, FieldEnum field) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 1, 1);
  }

  /**
   * @notice Update an element of stats at `_index`.
   */
  function updateStats(uint8 level, FieldEnum field, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of stats at `_index`.
   */
  function _updateStats(uint8 level, FieldEnum field, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get(uint8 level, FieldEnum field) internal view returns (VoidsmanRequirementsTableData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(uint8 level, FieldEnum field) internal view returns (VoidsmanRequirementsTableData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(uint8 level, FieldEnum field, uint256 xp, uint8[] memory competencies, uint8[] memory stats) internal {
    bytes memory _staticData = encodeStatic(xp);

    EncodedLengths _encodedLengths = encodeLengths(competencies, stats);
    bytes memory _dynamicData = encodeDynamic(competencies, stats);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(uint8 level, FieldEnum field, uint256 xp, uint8[] memory competencies, uint8[] memory stats) internal {
    bytes memory _staticData = encodeStatic(xp);

    EncodedLengths _encodedLengths = encodeLengths(competencies, stats);
    bytes memory _dynamicData = encodeDynamic(competencies, stats);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(uint8 level, FieldEnum field, VoidsmanRequirementsTableData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.xp);

    EncodedLengths _encodedLengths = encodeLengths(_table.competencies, _table.stats);
    bytes memory _dynamicData = encodeDynamic(_table.competencies, _table.stats);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(uint8 level, FieldEnum field, VoidsmanRequirementsTableData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.xp);

    EncodedLengths _encodedLengths = encodeLengths(_table.competencies, _table.stats);
    bytes memory _dynamicData = encodeDynamic(_table.competencies, _table.stats);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(bytes memory _blob) internal pure returns (uint256 xp) {
    xp = (uint256(Bytes.getBytes32(_blob, 0)));
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    EncodedLengths _encodedLengths,
    bytes memory _blob
  ) internal pure returns (uint8[] memory competencies, uint8[] memory stats) {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    competencies = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_uint8());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(1);
    }
    stats = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_uint8());
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths _encodedLengths,
    bytes memory _dynamicData
  ) internal pure returns (VoidsmanRequirementsTableData memory _table) {
    (_table.xp) = decodeStatic(_staticData);

    (_table.competencies, _table.stats) = decodeDynamic(_encodedLengths, _dynamicData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint8 level, FieldEnum field) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint8 level, FieldEnum field) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(uint256 xp) internal pure returns (bytes memory) {
    return abi.encodePacked(xp);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(
    uint8[] memory competencies,
    uint8[] memory stats
  ) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(competencies.length * 1, stats.length * 1);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(uint8[] memory competencies, uint8[] memory stats) internal pure returns (bytes memory) {
    return abi.encodePacked(EncodeArray.encode((competencies)), EncodeArray.encode((stats)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 xp,
    uint8[] memory competencies,
    uint8[] memory stats
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(xp);

    EncodedLengths _encodedLengths = encodeLengths(competencies, stats);
    bytes memory _dynamicData = encodeDynamic(competencies, stats);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(uint8 level, FieldEnum field) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(level));
    _keyTuple[1] = bytes32(uint256(uint8(field)));

    return _keyTuple;
  }
}
