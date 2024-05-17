// # GNU General Public License
// 
// ## Wrilya: A Community Oriented Game
// 
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

import { Entity } from "@latticexyz/recs";

/**
 * The base level class for all game entities. 
 */
export default class Actor {

  //---------------------------------------------------------------------------
  // Class Members
  //---------------------------------------------------------------------------
  private mID: Entity;

  //---------------------------------------------------------------------------
  // Class Methods
  //---------------------------------------------------------------------------
  constructor(id: string | number) {
    this.mID = Actor.toID(id);
  }

  /**
   * Get the Entity ID in the MUD format
   *  
   * @returns MUDEntity for this Entity
   */
  public getID(): Entity { return this.mID; }

  //---------------------------------------------------------------------------
  // Static Helper Functions
  //---------------------------------------------------------------------------

  /**
   * Convert a value into an entity ID.  It is assumed that string value is a
   * hex string (with our with the 0x header).  If not then please convert
   * to a hex first
   * 
   * @param val to convert into a entity ID.
   * @returns String Entity ID
   */
  public static toID(val: Entity | string | number): Entity {
    // Typescript doesn't have function overloading on types
    // convert to hex string.
    let id: string;
    let zeros: string = "";
    if (typeof val == "number") {
      id = val.toString(16);
    }
    else {
      id = val.toLowerCase();
      if (id.substring(0, 2) == "0x") {
        id = id.slice(2);
      }
    }

    if (id.length < 64) {
      zeros = "0".repeat(64 - id.length);
    }
    else if (id.length > 64) {
      throw "Value too large";
    }
    return "0x".concat(zeros).concat(id) as Entity;
  }

  /**
   * Check to see if this ID is formated in an entity expected style
   * Which is pretty much a bytes32 hex encoded string.
   * 
   * @param id string value to check
   * @returns if the format is correct
   */
  public static isID(id: string): boolean {
    let res = false;
    if (id.substring(0, 2) == "0x") {
      id = id.slice(2);
    }
    if (id.length <= 64) {
      const rx: RegExp = /^[0-9a-fA-F]+$/;
      res = rx.test(id);
    }
    return res;
  }
}
