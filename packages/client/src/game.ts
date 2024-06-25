// Copyright (C) 2024 Decentralized Consulting
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------

import { Actor, Voidsman, Ship } from "./actors";
import { SetupNetworkResult } from "./mud/setupNetwork";
import { ClientComponents } from "./mud/createClientComponents";
import { SystemCalls } from "./mud/createSystemCalls";
import portraitAssetPackUrl from "../static/assets/portrait-asset-pack.json";
import { HasValue, runQuery, Entity, getComponentValue, getComponentValueStrict } from "@latticexyz/recs";
import { EntityEnum, OperationEnum } from "./mud"
import { ethers } from "ethers"
import { singletonEntity } from "@latticexyz/store-sync/recs";

// ----------------------------------------------------------------------------
/**
 * A global singleton used for referencing items across the frameworks
 * (MUD, Phaser, etc)
 */
export default class Game {
  // --------------------------------------------------------------------------
  // Class Members
  private static sInstance: Game;

  private mMUDNetwork?: SetupNetworkResult;
  private mMUDComponents?: ClientComponents;
  private mMUDSystemCalls?: SystemCalls;
  private mPortraits: string[] = [];
  private mCrew: Map<Entity, Voidsman> = new Map<Entity, Voidsman>();
  private mFleet: Map<Entity, Ship> = new Map<Entity, Ship>();

  private mTokens: number = 0;
  private mCredits: number = 0;
  private mDebit: number = 0;
  private mStaked: number = 0;
  private mUnstaked: number = 0;
  private mUTS: number = 0;

  // --------------------------------------------------------------------------
  // Constructor

  /**
   * Private constructor,  never call this directly
   */
  private constructor() { }

  // --------------------------------------------------------------------------
  // Class Static Methods

  /**
   * Instance accessor.  If the instance hasn't been created yet, it will do so
   */
  public static Instance(): Game {
    if (!Game.sInstance) {
      Game.sInstance = new Game();
      for (const file in portraitAssetPackUrl.section1.files) {
        const key = portraitAssetPackUrl.section1.files[file].key
        Game.sInstance.mPortraits.push(key);
      }
    }

    return Game.sInstance;
  }

  /**
   * Set the MUD objects that we will need to access
   * 
   * @param network MUD network returnend structure
   * @param components MUD components returned structure
   * @param systemCalls MUD systemcalls returned structured
   */
  public static SetMUD(network: SetupNetworkResult, components: ClientComponents, systemCalls: SystemCalls) {
    console.log("[Game.SetMUD] Started");
    Game.Instance().mMUDNetwork = network;
    Game.Instance().mMUDComponents = components;
    Game.Instance().mMUDSystemCalls = systemCalls;

    // Load the crew up;
    console.log("[Game.SetMUD] Starting Monitor");
    Game.Instance().monitor();
    console.log("[Game.SetMUD] Complete");
  }

  public static MUDComponents(): ClientComponents {
    return Game.Instance().mMUDComponents!;
  }

  public static MUDNetwork(): SetupNetworkResult {
    return Game.Instance().mMUDNetwork!;
  }

  public static MUDSystemCalls(): SystemCalls {
    return Game.Instance().mMUDSystemCalls!;
  }

  public static Portraits(): string[] {
    return Game.Instance().mPortraits;
  }

  public static Crew(): Map<string, Voidsman> {
    return Game.Instance().mCrew;
  }

  public static Owner(): Entity {
    return Game.Instance().owner();
  }

  public static Address(): string {
    return Game.Instance().address();
  }

  public static Tokens(): number {
    return Game.Instance().mTokens;
  }

  public static Debit(): number {
    return Game.Instance().mDebit;
  }

  public static MaxDebit(): number {
    return Game.Instance().getMaxDebit();
  }

  public static Credits(): number {
    return Game.Instance().mCredits;
  }

  public static Stake(): number {
    return Game.Instance().mStaked;
  }

  public static Unstake(): number {
    return Game.Instance().mUnstaked;
  }

  public static UTS(): number {
    return Game.Instance().mUTS;
  }

  public static Start() {
    Game.Instance().start();
  }

  // --------------------------------------------------------------------------
  // Private Helpers
  // --------------------------------------------------------------------------

  private start() {
    this.loadCrew();
    this.loadCurrency();
  }

  private getMaxDebit() {
    const { GameConfigTable } = this.mMUDComponents!;
    const gameConfig = getComponentValue(GameConfigTable, singletonEntity)!;
    return Number(gameConfig.stdMaxDebit) + (this.mStaked * Number(gameConfig.collateralDebitRatio));
  }

  private loadCurrency() {
    const { CurrencyTable } = this.mMUDComponents!;
    const currency = getComponentValue(CurrencyTable, this.owner());
    if (currency) {
      this.mTokens = Number(currency.tokens);
      this.mCredits = Number(currency.credits);
      this.mDebit = Number(currency.debit);
      this.mStaked = Number(currency.staked);
      this.mUnstaked = Number(currency.unstaked);
      this.mUTS = Number(currency.uts);
    }
    else {
      this.mTokens = 0;
      this.mCredits = 0;
      this.mDebit = 0;
      this.mStaked = 0;
      this.mUnstaked = 0;
      this.mUTS = 0;
    }
  }

  private loadCrew() {
    const { EntityOwnerTable } = this.mMUDComponents!;
    this.mCrew.clear();
    // Query for all the crew members that are owned by the player
    const entities = runQuery([
      HasValue(EntityOwnerTable, { value: this.owner() }),
    ]);

    // Now pull out the data for each crew member
    for (const entity of entities) { this.mCrew.set(entity, new Voidsman(entity)); }
  }

  private onEntityCreate(data: string) { this.onEntityLoad(data); }
  private onEntityDestroy(data: string) { this.onEntityUnload(data); }
  private onVoidsmanTrain(data: string) { this.onEntityLoad(data); }
  private onVoidsmanTrainCancel(data: string) { this.onEntityLoad(data); }
  private onVoidsmanCertify(data: string) { this.onEntityLoad(data); }

  private onEntityLoad(data: string) {
    const { EntityTypeTable } = this.mMUDComponents!;
    const [owner, entity] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32', 'bytes32'], data);
    if (owner as Entity == this.owner()) {
      const etype: EntityEnum = getComponentValueStrict(EntityTypeTable, entity).value as EntityEnum;
      switch (etype) {
        case EntityEnum.VOIDSMAN:
          this.mCrew.set(entity as Entity, new Voidsman(entity as Entity));
          break;

        default:
          console.log("Unhandled type")
      }
    }
  }

  private onEntityUnload(data: string) {
    const { EntityTypeTable } = this.mMUDComponents!;
    const [owner, entity] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32', 'bytes32'], data);
    if (owner as Entity == this.owner()) {
      const etype: EntityEnum = getComponentValueStrict(EntityTypeTable, entity).value as EntityEnum;
      switch (etype) {
        case EntityEnum.VOIDSMAN:
          this.mCrew.delete(entity as Entity);
          break;

        default:
          console.log("Unhandled type")
      }
    }
  }

  private onCurrencyMint(data: string) {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const [owner, amt] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32', 'bytes32'], data);
    if (owner as Entity == this.owner()) {
      this.loadCurrency();
    }
  }

  private onCurrencyStake(data: string) {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const [owner, amt] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32', 'bytes32'], data);
    if (owner as Entity == this.owner()) {
      this.loadCurrency();
    }
  }

  private onCurrencyRelease(data: string) {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const [owner, amt] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32', 'bytes32'], data);
    if (owner as Entity == this.owner()) {
      this.loadCurrency();
    }
  }

  private onCurrencyClaim(data: string) {
    const [owner] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32'], data);
    if (owner as Entity == this.owner()) {
      this.loadCurrency();
    }
  }

  private onCurrencyPayment(data: string) {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const [owner, amt] = ethers.AbiCoder.defaultAbiCoder().decode(['bytes32', 'bytes32'], data);
    if (owner as Entity == this.owner()) {
      this.loadCurrency();
    }
  }

  private monitor() {
    const { NotificationTable } = this.mMUDComponents!;
    NotificationTable.update$.subscribe((update) => {
      this.loadCurrency();
      const { operation: op, data: data } = update.value[0]!;
      switch (op as OperationEnum) {
        case OperationEnum.GAME_PAUSE:
          break;
        case OperationEnum.GAME_UNPAUSE:
          break;
        case OperationEnum.GAME_SET_ADMIN:
          break;
        case OperationEnum.GAME_SET_GM:
          break;
        case OperationEnum.GAME_SET_CURRENCY_PROXY:
          break;
        case OperationEnum.GAME_SET_ITEM_PROXY:
          break;
        case OperationEnum.GAME_SET_ENTITY_PROXY:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_CREATE_COST:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_UPGRADE_TIME_BASE:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_UPGRADE_TIME_POWER:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_UPGRADE_COST_BASE:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_UPGRADE_COST_POWER:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_MAX_STATS:
          break;
        case OperationEnum.GAME_SET_VOIDSMAN_MAX_COMPETENCY:
          break;

        case OperationEnum.ENTITY_CREATE:
          this.onEntityCreate(data as string);
          break;

        case OperationEnum.ENTITY_DESTROY:
          this.onEntityDestroy(data as string);
          break;

        case OperationEnum.ENTITY_TRANSFER:
          break;
        case OperationEnum.ENTITY_UPDATE:
          break;

        case OperationEnum.VOIDSMAN_TRAIN:
          this.onVoidsmanTrain(data as string);
          break;

        case OperationEnum.VOIDSMAN_TRAIN_CANCEL:
          this.onVoidsmanTrainCancel(data as string);
          break;

        case OperationEnum.VOIDSMAN_CERTIFY:
          this.onVoidsmanCertify(data as string);
          break;

        case OperationEnum.VOIDSMAN_SET_TRAINING_REQUIREMENT:
          break;

        case OperationEnum.CURRENCY_MINT:
          this.onCurrencyMint(data as string);
          break;

        case OperationEnum.CURRENCY_STAKE:
          this.onCurrencyStake(data as string);
          break;

        case OperationEnum.CURRENCY_RELEASE:
          this.onCurrencyRelease(data as string);
          break;

        case OperationEnum.CURRENCY_CLAIM:
          this.onCurrencyClaim(data as string);
          break;

        case OperationEnum.CURRENCY_PAYMENT:
          this.onCurrencyPayment(data as string);
          break;

        default:
          break;
      }
    });
  }

  private owner(): Entity {
    return Actor.toID(this.address());
  }

  private address(): string {
    const { walletClient } = this.mMUDNetwork!;
    return walletClient.account.address;
  }
}