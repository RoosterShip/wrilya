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
import { Has, HasValue, runQuery, Entity } from "@latticexyz/recs";

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
    console.log("[Game.SetMUD] Loading Crew");
    Game.Instance().loadCrew();
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

  private loadCrew(): Map<Entity, Voidsman> {
    const { VoidsmenTable, OwnedByTable, PersonaTable } = this.mMUDComponents!;
    const crew = new Map<Entity, Voidsman>();
    // Query for all the crew members that are owned by the player
    const entities = runQuery([
      HasValue(OwnedByTable, { value: this.owner() }),
      Has(VoidsmenTable),
      Has(PersonaTable),
    ]);

    // Now pull out the data for each crew member
    for (const entity of entities) { crew.set(entity, new Voidsman(entity)); }
    return crew;
  }

  private monitor() {
    this.mMUDComponents!.OwnedByTable.update$.subscribe((update) => {
      const owner = update.value[0]?.value as Entity;
      if (owner == this.owner()) {
        this.mCrew.set(update.entity, new Voidsman(update.entity));
      }
    });
    this.mMUDComponents!.TrainingTable.update$.subscribe((update) => {
      if (this.mCrew.has(update.entity)) {
        this.mCrew.set(update.entity, new Voidsman(update.entity));
      }
    });
    this.mMUDComponents!.PersonaTable.update$.subscribe((update) => {
      if (this.mCrew.has(update.entity)) {
        this.mCrew.set(update.entity, new Voidsman(update.entity));
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