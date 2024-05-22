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

struct CurrencyTableData {
  uint256 tokens;
  uint256 credits;
  uint256 staked;
  uint256 unstaked;
  uint256 uts;
  uint256 debit;
}

library CurrencyTable {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "game", name: "CurrencyTable", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746267616d650000000000000000000043757272656e63795461626c65000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x00c0060020202020202000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes32)
  Schema constant _keySchema = Schema.wrap(0x002001005f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint256, uint256, uint256, uint256, uint256, uint256)
  Schema constant _valueSchema = Schema.wrap(0x00c006001f1f1f1f1f1f00000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "owner";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](6);
    fieldNames[0] = "tokens";
    fieldNames[1] = "credits";
    fieldNames[2] = "staked";
    fieldNames[3] = "unstaked";
    fieldNames[4] = "uts";
    fieldNames[5] = "debit";
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
   * @notice Get tokens.
   */
  function getTokens(bytes32 owner) internal view returns (uint256 tokens) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get tokens.
   */
  function _getTokens(bytes32 owner) internal view returns (uint256 tokens) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set tokens.
   */
  function setTokens(bytes32 owner, uint256 tokens) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((tokens)), _fieldLayout);
  }

  /**
   * @notice Set tokens.
   */
  function _setTokens(bytes32 owner, uint256 tokens) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((tokens)), _fieldLayout);
  }

  /**
   * @notice Get credits.
   */
  function getCredits(bytes32 owner) internal view returns (uint256 credits) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get credits.
   */
  function _getCredits(bytes32 owner) internal view returns (uint256 credits) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set credits.
   */
  function setCredits(bytes32 owner, uint256 credits) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((credits)), _fieldLayout);
  }

  /**
   * @notice Set credits.
   */
  function _setCredits(bytes32 owner, uint256 credits) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((credits)), _fieldLayout);
  }

  /**
   * @notice Get staked.
   */
  function getStaked(bytes32 owner) internal view returns (uint256 staked) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get staked.
   */
  function _getStaked(bytes32 owner) internal view returns (uint256 staked) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set staked.
   */
  function setStaked(bytes32 owner, uint256 staked) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((staked)), _fieldLayout);
  }

  /**
   * @notice Set staked.
   */
  function _setStaked(bytes32 owner, uint256 staked) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((staked)), _fieldLayout);
  }

  /**
   * @notice Get unstaked.
   */
  function getUnstaked(bytes32 owner) internal view returns (uint256 unstaked) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get unstaked.
   */
  function _getUnstaked(bytes32 owner) internal view returns (uint256 unstaked) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set unstaked.
   */
  function setUnstaked(bytes32 owner, uint256 unstaked) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((unstaked)), _fieldLayout);
  }

  /**
   * @notice Set unstaked.
   */
  function _setUnstaked(bytes32 owner, uint256 unstaked) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((unstaked)), _fieldLayout);
  }

  /**
   * @notice Get uts.
   */
  function getUts(bytes32 owner) internal view returns (uint256 uts) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get uts.
   */
  function _getUts(bytes32 owner) internal view returns (uint256 uts) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set uts.
   */
  function setUts(bytes32 owner, uint256 uts) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((uts)), _fieldLayout);
  }

  /**
   * @notice Set uts.
   */
  function _setUts(bytes32 owner, uint256 uts) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((uts)), _fieldLayout);
  }

  /**
   * @notice Get debit.
   */
  function getDebit(bytes32 owner) internal view returns (uint256 debit) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get debit.
   */
  function _getDebit(bytes32 owner) internal view returns (uint256 debit) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set debit.
   */
  function setDebit(bytes32 owner, uint256 debit) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((debit)), _fieldLayout);
  }

  /**
   * @notice Set debit.
   */
  function _setDebit(bytes32 owner, uint256 debit) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((debit)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(bytes32 owner) internal view returns (CurrencyTableData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

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
  function _get(bytes32 owner) internal view returns (CurrencyTableData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

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
  function set(
    bytes32 owner,
    uint256 tokens,
    uint256 credits,
    uint256 staked,
    uint256 unstaked,
    uint256 uts,
    uint256 debit
  ) internal {
    bytes memory _staticData = encodeStatic(tokens, credits, staked, unstaked, uts, debit);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes32 owner,
    uint256 tokens,
    uint256 credits,
    uint256 staked,
    uint256 unstaked,
    uint256 uts,
    uint256 debit
  ) internal {
    bytes memory _staticData = encodeStatic(tokens, credits, staked, unstaked, uts, debit);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(bytes32 owner, CurrencyTableData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.tokens,
      _table.credits,
      _table.staked,
      _table.unstaked,
      _table.uts,
      _table.debit
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(bytes32 owner, CurrencyTableData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.tokens,
      _table.credits,
      _table.staked,
      _table.unstaked,
      _table.uts,
      _table.debit
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  )
    internal
    pure
    returns (uint256 tokens, uint256 credits, uint256 staked, uint256 unstaked, uint256 uts, uint256 debit)
  {
    tokens = (uint256(Bytes.getBytes32(_blob, 0)));

    credits = (uint256(Bytes.getBytes32(_blob, 32)));

    staked = (uint256(Bytes.getBytes32(_blob, 64)));

    unstaked = (uint256(Bytes.getBytes32(_blob, 96)));

    uts = (uint256(Bytes.getBytes32(_blob, 128)));

    debit = (uint256(Bytes.getBytes32(_blob, 160)));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths,
    bytes memory
  ) internal pure returns (CurrencyTableData memory _table) {
    (_table.tokens, _table.credits, _table.staked, _table.unstaked, _table.uts, _table.debit) = decodeStatic(
      _staticData
    );
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(bytes32 owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(bytes32 owner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 tokens,
    uint256 credits,
    uint256 staked,
    uint256 unstaked,
    uint256 uts,
    uint256 debit
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(tokens, credits, staked, unstaked, uts, debit);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 tokens,
    uint256 credits,
    uint256 staked,
    uint256 unstaked,
    uint256 uts,
    uint256 debit
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(tokens, credits, staked, unstaked, uts, debit);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(bytes32 owner) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = owner;

    return _keyTuple;
  }
}
