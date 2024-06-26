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

struct GameConfigTableData {
  bool active;
  address admin;
  address gm;
  address currencyProxy;
  address governor;
  address voteToken;
  address itemProxy;
  address entityProxy;
  uint256 voidsmanCreateCost;
  uint256 voidsmanUpgradeTimeBase;
  uint256 voidsmanUpgradeTimePower;
  uint256 voidsmanUpgradeCostBase;
  uint256 voidsmanUpgradeCostPower;
  uint8 voidsmanMaxStats;
  uint8 voidsmanMaxCompetency;
  uint256 stdMaxDebit;
  uint256 collateralDebitRatio;
  uint256 currencyUnstakeTime;
}

library GameConfigTable {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "game", name: "GameConfigTable", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746267616d650000000000000000000047616d65436f6e6669675461626c6500);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x018f120001141414141414142020202020010120202000000000000000000000);

  // Hex-encoded key schema of ()
  Schema constant _keySchema = Schema.wrap(0x0000000000000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (bool, address, address, address, address, address, address, address, uint256, uint256, uint256, uint256, uint256, uint8, uint8, uint256, uint256, uint256)
  Schema constant _valueSchema = Schema.wrap(0x018f120060616161616161611f1f1f1f1f00001f1f1f00000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](0);
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](18);
    fieldNames[0] = "active";
    fieldNames[1] = "admin";
    fieldNames[2] = "gm";
    fieldNames[3] = "currencyProxy";
    fieldNames[4] = "governor";
    fieldNames[5] = "voteToken";
    fieldNames[6] = "itemProxy";
    fieldNames[7] = "entityProxy";
    fieldNames[8] = "voidsmanCreateCost";
    fieldNames[9] = "voidsmanUpgradeTimeBase";
    fieldNames[10] = "voidsmanUpgradeTimePower";
    fieldNames[11] = "voidsmanUpgradeCostBase";
    fieldNames[12] = "voidsmanUpgradeCostPower";
    fieldNames[13] = "voidsmanMaxStats";
    fieldNames[14] = "voidsmanMaxCompetency";
    fieldNames[15] = "stdMaxDebit";
    fieldNames[16] = "collateralDebitRatio";
    fieldNames[17] = "currencyUnstakeTime";
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
   * @notice Get active.
   */
  function getActive() internal view returns (bool active) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get active.
   */
  function _getActive() internal view returns (bool active) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set active.
   */
  function setActive(bool active) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((active)), _fieldLayout);
  }

  /**
   * @notice Set active.
   */
  function _setActive(bool active) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((active)), _fieldLayout);
  }

  /**
   * @notice Get admin.
   */
  function getAdmin() internal view returns (address admin) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get admin.
   */
  function _getAdmin() internal view returns (address admin) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set admin.
   */
  function setAdmin(address admin) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((admin)), _fieldLayout);
  }

  /**
   * @notice Set admin.
   */
  function _setAdmin(address admin) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((admin)), _fieldLayout);
  }

  /**
   * @notice Get gm.
   */
  function getGm() internal view returns (address gm) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get gm.
   */
  function _getGm() internal view returns (address gm) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set gm.
   */
  function setGm(address gm) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((gm)), _fieldLayout);
  }

  /**
   * @notice Set gm.
   */
  function _setGm(address gm) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((gm)), _fieldLayout);
  }

  /**
   * @notice Get currencyProxy.
   */
  function getCurrencyProxy() internal view returns (address currencyProxy) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get currencyProxy.
   */
  function _getCurrencyProxy() internal view returns (address currencyProxy) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set currencyProxy.
   */
  function setCurrencyProxy(address currencyProxy) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((currencyProxy)), _fieldLayout);
  }

  /**
   * @notice Set currencyProxy.
   */
  function _setCurrencyProxy(address currencyProxy) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((currencyProxy)), _fieldLayout);
  }

  /**
   * @notice Get governor.
   */
  function getGovernor() internal view returns (address governor) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get governor.
   */
  function _getGovernor() internal view returns (address governor) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set governor.
   */
  function setGovernor(address governor) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((governor)), _fieldLayout);
  }

  /**
   * @notice Set governor.
   */
  function _setGovernor(address governor) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked((governor)), _fieldLayout);
  }

  /**
   * @notice Get voteToken.
   */
  function getVoteToken() internal view returns (address voteToken) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get voteToken.
   */
  function _getVoteToken() internal view returns (address voteToken) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set voteToken.
   */
  function setVoteToken(address voteToken) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((voteToken)), _fieldLayout);
  }

  /**
   * @notice Set voteToken.
   */
  function _setVoteToken(address voteToken) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((voteToken)), _fieldLayout);
  }

  /**
   * @notice Get itemProxy.
   */
  function getItemProxy() internal view returns (address itemProxy) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get itemProxy.
   */
  function _getItemProxy() internal view returns (address itemProxy) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set itemProxy.
   */
  function setItemProxy(address itemProxy) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((itemProxy)), _fieldLayout);
  }

  /**
   * @notice Set itemProxy.
   */
  function _setItemProxy(address itemProxy) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((itemProxy)), _fieldLayout);
  }

  /**
   * @notice Get entityProxy.
   */
  function getEntityProxy() internal view returns (address entityProxy) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get entityProxy.
   */
  function _getEntityProxy() internal view returns (address entityProxy) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set entityProxy.
   */
  function setEntityProxy(address entityProxy) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((entityProxy)), _fieldLayout);
  }

  /**
   * @notice Set entityProxy.
   */
  function _setEntityProxy(address entityProxy) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((entityProxy)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanCreateCost.
   */
  function getVoidsmanCreateCost() internal view returns (uint256 voidsmanCreateCost) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get voidsmanCreateCost.
   */
  function _getVoidsmanCreateCost() internal view returns (uint256 voidsmanCreateCost) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 8, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set voidsmanCreateCost.
   */
  function setVoidsmanCreateCost(uint256 voidsmanCreateCost) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((voidsmanCreateCost)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanCreateCost.
   */
  function _setVoidsmanCreateCost(uint256 voidsmanCreateCost) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 8, abi.encodePacked((voidsmanCreateCost)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanUpgradeTimeBase.
   */
  function getVoidsmanUpgradeTimeBase() internal view returns (uint256 voidsmanUpgradeTimeBase) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 9, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get voidsmanUpgradeTimeBase.
   */
  function _getVoidsmanUpgradeTimeBase() internal view returns (uint256 voidsmanUpgradeTimeBase) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 9, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set voidsmanUpgradeTimeBase.
   */
  function setVoidsmanUpgradeTimeBase(uint256 voidsmanUpgradeTimeBase) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 9, abi.encodePacked((voidsmanUpgradeTimeBase)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanUpgradeTimeBase.
   */
  function _setVoidsmanUpgradeTimeBase(uint256 voidsmanUpgradeTimeBase) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 9, abi.encodePacked((voidsmanUpgradeTimeBase)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanUpgradeTimePower.
   */
  function getVoidsmanUpgradeTimePower() internal view returns (uint256 voidsmanUpgradeTimePower) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 10, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get voidsmanUpgradeTimePower.
   */
  function _getVoidsmanUpgradeTimePower() internal view returns (uint256 voidsmanUpgradeTimePower) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 10, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set voidsmanUpgradeTimePower.
   */
  function setVoidsmanUpgradeTimePower(uint256 voidsmanUpgradeTimePower) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 10, abi.encodePacked((voidsmanUpgradeTimePower)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanUpgradeTimePower.
   */
  function _setVoidsmanUpgradeTimePower(uint256 voidsmanUpgradeTimePower) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 10, abi.encodePacked((voidsmanUpgradeTimePower)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanUpgradeCostBase.
   */
  function getVoidsmanUpgradeCostBase() internal view returns (uint256 voidsmanUpgradeCostBase) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 11, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get voidsmanUpgradeCostBase.
   */
  function _getVoidsmanUpgradeCostBase() internal view returns (uint256 voidsmanUpgradeCostBase) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 11, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set voidsmanUpgradeCostBase.
   */
  function setVoidsmanUpgradeCostBase(uint256 voidsmanUpgradeCostBase) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 11, abi.encodePacked((voidsmanUpgradeCostBase)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanUpgradeCostBase.
   */
  function _setVoidsmanUpgradeCostBase(uint256 voidsmanUpgradeCostBase) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 11, abi.encodePacked((voidsmanUpgradeCostBase)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanUpgradeCostPower.
   */
  function getVoidsmanUpgradeCostPower() internal view returns (uint256 voidsmanUpgradeCostPower) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 12, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get voidsmanUpgradeCostPower.
   */
  function _getVoidsmanUpgradeCostPower() internal view returns (uint256 voidsmanUpgradeCostPower) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 12, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set voidsmanUpgradeCostPower.
   */
  function setVoidsmanUpgradeCostPower(uint256 voidsmanUpgradeCostPower) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 12, abi.encodePacked((voidsmanUpgradeCostPower)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanUpgradeCostPower.
   */
  function _setVoidsmanUpgradeCostPower(uint256 voidsmanUpgradeCostPower) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 12, abi.encodePacked((voidsmanUpgradeCostPower)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanMaxStats.
   */
  function getVoidsmanMaxStats() internal view returns (uint8 voidsmanMaxStats) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 13, _fieldLayout);
    return (uint8(bytes1(_blob)));
  }

  /**
   * @notice Get voidsmanMaxStats.
   */
  function _getVoidsmanMaxStats() internal view returns (uint8 voidsmanMaxStats) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 13, _fieldLayout);
    return (uint8(bytes1(_blob)));
  }

  /**
   * @notice Set voidsmanMaxStats.
   */
  function setVoidsmanMaxStats(uint8 voidsmanMaxStats) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 13, abi.encodePacked((voidsmanMaxStats)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanMaxStats.
   */
  function _setVoidsmanMaxStats(uint8 voidsmanMaxStats) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 13, abi.encodePacked((voidsmanMaxStats)), _fieldLayout);
  }

  /**
   * @notice Get voidsmanMaxCompetency.
   */
  function getVoidsmanMaxCompetency() internal view returns (uint8 voidsmanMaxCompetency) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 14, _fieldLayout);
    return (uint8(bytes1(_blob)));
  }

  /**
   * @notice Get voidsmanMaxCompetency.
   */
  function _getVoidsmanMaxCompetency() internal view returns (uint8 voidsmanMaxCompetency) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 14, _fieldLayout);
    return (uint8(bytes1(_blob)));
  }

  /**
   * @notice Set voidsmanMaxCompetency.
   */
  function setVoidsmanMaxCompetency(uint8 voidsmanMaxCompetency) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 14, abi.encodePacked((voidsmanMaxCompetency)), _fieldLayout);
  }

  /**
   * @notice Set voidsmanMaxCompetency.
   */
  function _setVoidsmanMaxCompetency(uint8 voidsmanMaxCompetency) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 14, abi.encodePacked((voidsmanMaxCompetency)), _fieldLayout);
  }

  /**
   * @notice Get stdMaxDebit.
   */
  function getStdMaxDebit() internal view returns (uint256 stdMaxDebit) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 15, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get stdMaxDebit.
   */
  function _getStdMaxDebit() internal view returns (uint256 stdMaxDebit) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 15, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set stdMaxDebit.
   */
  function setStdMaxDebit(uint256 stdMaxDebit) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 15, abi.encodePacked((stdMaxDebit)), _fieldLayout);
  }

  /**
   * @notice Set stdMaxDebit.
   */
  function _setStdMaxDebit(uint256 stdMaxDebit) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 15, abi.encodePacked((stdMaxDebit)), _fieldLayout);
  }

  /**
   * @notice Get collateralDebitRatio.
   */
  function getCollateralDebitRatio() internal view returns (uint256 collateralDebitRatio) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 16, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get collateralDebitRatio.
   */
  function _getCollateralDebitRatio() internal view returns (uint256 collateralDebitRatio) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 16, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set collateralDebitRatio.
   */
  function setCollateralDebitRatio(uint256 collateralDebitRatio) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 16, abi.encodePacked((collateralDebitRatio)), _fieldLayout);
  }

  /**
   * @notice Set collateralDebitRatio.
   */
  function _setCollateralDebitRatio(uint256 collateralDebitRatio) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 16, abi.encodePacked((collateralDebitRatio)), _fieldLayout);
  }

  /**
   * @notice Get currencyUnstakeTime.
   */
  function getCurrencyUnstakeTime() internal view returns (uint256 currencyUnstakeTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 17, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get currencyUnstakeTime.
   */
  function _getCurrencyUnstakeTime() internal view returns (uint256 currencyUnstakeTime) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 17, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set currencyUnstakeTime.
   */
  function setCurrencyUnstakeTime(uint256 currencyUnstakeTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 17, abi.encodePacked((currencyUnstakeTime)), _fieldLayout);
  }

  /**
   * @notice Set currencyUnstakeTime.
   */
  function _setCurrencyUnstakeTime(uint256 currencyUnstakeTime) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 17, abi.encodePacked((currencyUnstakeTime)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get() internal view returns (GameConfigTableData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

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
  function _get() internal view returns (GameConfigTableData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

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
    bool active,
    address admin,
    address gm,
    address currencyProxy,
    address governor,
    address voteToken,
    address itemProxy,
    address entityProxy,
    uint256 voidsmanCreateCost,
    uint256 voidsmanUpgradeTimeBase,
    uint256 voidsmanUpgradeTimePower,
    uint256 voidsmanUpgradeCostBase,
    uint256 voidsmanUpgradeCostPower,
    uint8 voidsmanMaxStats,
    uint8 voidsmanMaxCompetency,
    uint256 stdMaxDebit,
    uint256 collateralDebitRatio,
    uint256 currencyUnstakeTime
  ) internal {
    bytes memory _staticData = encodeStatic(
      active,
      admin,
      gm,
      currencyProxy,
      governor,
      voteToken,
      itemProxy,
      entityProxy,
      voidsmanCreateCost,
      voidsmanUpgradeTimeBase,
      voidsmanUpgradeTimePower,
      voidsmanUpgradeCostBase,
      voidsmanUpgradeCostPower,
      voidsmanMaxStats,
      voidsmanMaxCompetency,
      stdMaxDebit,
      collateralDebitRatio,
      currencyUnstakeTime
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bool active,
    address admin,
    address gm,
    address currencyProxy,
    address governor,
    address voteToken,
    address itemProxy,
    address entityProxy,
    uint256 voidsmanCreateCost,
    uint256 voidsmanUpgradeTimeBase,
    uint256 voidsmanUpgradeTimePower,
    uint256 voidsmanUpgradeCostBase,
    uint256 voidsmanUpgradeCostPower,
    uint8 voidsmanMaxStats,
    uint8 voidsmanMaxCompetency,
    uint256 stdMaxDebit,
    uint256 collateralDebitRatio,
    uint256 currencyUnstakeTime
  ) internal {
    bytes memory _staticData = encodeStatic(
      active,
      admin,
      gm,
      currencyProxy,
      governor,
      voteToken,
      itemProxy,
      entityProxy,
      voidsmanCreateCost,
      voidsmanUpgradeTimeBase,
      voidsmanUpgradeTimePower,
      voidsmanUpgradeCostBase,
      voidsmanUpgradeCostPower,
      voidsmanMaxStats,
      voidsmanMaxCompetency,
      stdMaxDebit,
      collateralDebitRatio,
      currencyUnstakeTime
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(GameConfigTableData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.active,
      _table.admin,
      _table.gm,
      _table.currencyProxy,
      _table.governor,
      _table.voteToken,
      _table.itemProxy,
      _table.entityProxy,
      _table.voidsmanCreateCost,
      _table.voidsmanUpgradeTimeBase,
      _table.voidsmanUpgradeTimePower,
      _table.voidsmanUpgradeCostBase,
      _table.voidsmanUpgradeCostPower,
      _table.voidsmanMaxStats,
      _table.voidsmanMaxCompetency,
      _table.stdMaxDebit,
      _table.collateralDebitRatio,
      _table.currencyUnstakeTime
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(GameConfigTableData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.active,
      _table.admin,
      _table.gm,
      _table.currencyProxy,
      _table.governor,
      _table.voteToken,
      _table.itemProxy,
      _table.entityProxy,
      _table.voidsmanCreateCost,
      _table.voidsmanUpgradeTimeBase,
      _table.voidsmanUpgradeTimePower,
      _table.voidsmanUpgradeCostBase,
      _table.voidsmanUpgradeCostPower,
      _table.voidsmanMaxStats,
      _table.voidsmanMaxCompetency,
      _table.stdMaxDebit,
      _table.collateralDebitRatio,
      _table.currencyUnstakeTime
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

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
    returns (
      bool active,
      address admin,
      address gm,
      address currencyProxy,
      address governor,
      address voteToken,
      address itemProxy,
      address entityProxy,
      uint256 voidsmanCreateCost,
      uint256 voidsmanUpgradeTimeBase,
      uint256 voidsmanUpgradeTimePower,
      uint256 voidsmanUpgradeCostBase,
      uint256 voidsmanUpgradeCostPower,
      uint8 voidsmanMaxStats,
      uint8 voidsmanMaxCompetency,
      uint256 stdMaxDebit,
      uint256 collateralDebitRatio,
      uint256 currencyUnstakeTime
    )
  {
    active = (_toBool(uint8(Bytes.getBytes1(_blob, 0))));

    admin = (address(Bytes.getBytes20(_blob, 1)));

    gm = (address(Bytes.getBytes20(_blob, 21)));

    currencyProxy = (address(Bytes.getBytes20(_blob, 41)));

    governor = (address(Bytes.getBytes20(_blob, 61)));

    voteToken = (address(Bytes.getBytes20(_blob, 81)));

    itemProxy = (address(Bytes.getBytes20(_blob, 101)));

    entityProxy = (address(Bytes.getBytes20(_blob, 121)));

    voidsmanCreateCost = (uint256(Bytes.getBytes32(_blob, 141)));

    voidsmanUpgradeTimeBase = (uint256(Bytes.getBytes32(_blob, 173)));

    voidsmanUpgradeTimePower = (uint256(Bytes.getBytes32(_blob, 205)));

    voidsmanUpgradeCostBase = (uint256(Bytes.getBytes32(_blob, 237)));

    voidsmanUpgradeCostPower = (uint256(Bytes.getBytes32(_blob, 269)));

    voidsmanMaxStats = (uint8(Bytes.getBytes1(_blob, 301)));

    voidsmanMaxCompetency = (uint8(Bytes.getBytes1(_blob, 302)));

    stdMaxDebit = (uint256(Bytes.getBytes32(_blob, 303)));

    collateralDebitRatio = (uint256(Bytes.getBytes32(_blob, 335)));

    currencyUnstakeTime = (uint256(Bytes.getBytes32(_blob, 367)));
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
  ) internal pure returns (GameConfigTableData memory _table) {
    (
      _table.active,
      _table.admin,
      _table.gm,
      _table.currencyProxy,
      _table.governor,
      _table.voteToken,
      _table.itemProxy,
      _table.entityProxy,
      _table.voidsmanCreateCost,
      _table.voidsmanUpgradeTimeBase,
      _table.voidsmanUpgradeTimePower,
      _table.voidsmanUpgradeCostBase,
      _table.voidsmanUpgradeCostPower,
      _table.voidsmanMaxStats,
      _table.voidsmanMaxCompetency,
      _table.stdMaxDebit,
      _table.collateralDebitRatio,
      _table.currencyUnstakeTime
    ) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    bool active,
    address admin,
    address gm,
    address currencyProxy,
    address governor,
    address voteToken,
    address itemProxy,
    address entityProxy,
    uint256 voidsmanCreateCost,
    uint256 voidsmanUpgradeTimeBase,
    uint256 voidsmanUpgradeTimePower,
    uint256 voidsmanUpgradeCostBase,
    uint256 voidsmanUpgradeCostPower,
    uint8 voidsmanMaxStats,
    uint8 voidsmanMaxCompetency,
    uint256 stdMaxDebit,
    uint256 collateralDebitRatio,
    uint256 currencyUnstakeTime
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        active,
        admin,
        gm,
        currencyProxy,
        governor,
        voteToken,
        itemProxy,
        entityProxy,
        voidsmanCreateCost,
        voidsmanUpgradeTimeBase,
        voidsmanUpgradeTimePower,
        voidsmanUpgradeCostBase,
        voidsmanUpgradeCostPower,
        voidsmanMaxStats,
        voidsmanMaxCompetency,
        stdMaxDebit,
        collateralDebitRatio,
        currencyUnstakeTime
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    bool active,
    address admin,
    address gm,
    address currencyProxy,
    address governor,
    address voteToken,
    address itemProxy,
    address entityProxy,
    uint256 voidsmanCreateCost,
    uint256 voidsmanUpgradeTimeBase,
    uint256 voidsmanUpgradeTimePower,
    uint256 voidsmanUpgradeCostBase,
    uint256 voidsmanUpgradeCostPower,
    uint8 voidsmanMaxStats,
    uint8 voidsmanMaxCompetency,
    uint256 stdMaxDebit,
    uint256 collateralDebitRatio,
    uint256 currencyUnstakeTime
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(
      active,
      admin,
      gm,
      currencyProxy,
      governor,
      voteToken,
      itemProxy,
      entityProxy,
      voidsmanCreateCost,
      voidsmanUpgradeTimeBase,
      voidsmanUpgradeTimePower,
      voidsmanUpgradeCostBase,
      voidsmanUpgradeCostPower,
      voidsmanMaxStats,
      voidsmanMaxCompetency,
      stdMaxDebit,
      collateralDebitRatio,
      currencyUnstakeTime
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple() internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    return _keyTuple;
  }
}

/**
 * @notice Cast a value to a bool.
 * @dev Boolean values are encoded as uint8 (1 = true, 0 = false), but Solidity doesn't allow casting between uint8 and bool.
 * @param value The uint8 value to convert.
 * @return result The boolean value.
 */
function _toBool(uint8 value) pure returns (bool result) {
  assembly {
    result := value
  }
}
