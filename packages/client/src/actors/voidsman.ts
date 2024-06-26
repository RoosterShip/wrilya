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

import { HomeEnum, FieldEnum } from "../mud";
import Game from "../game";
import Actor from "./actor";
import { getComponentValue, getComponentValueStrict } from "@latticexyz/recs";

/**
 * One of your game 
 */
export default class Voidsman extends Actor {

  //---------------------------------------------------------------------------
  // Class Members
  //---------------------------------------------------------------------------
  private mName: string = "";
  private mPortrait: string = "";
  private mHome: HomeEnum = HomeEnum.ICOIR;
  private mXP: number = 0;
  private mCompetencies: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  private mStats: number[] = [0, 0, 0, 0, 0, 0];
  private mTrainingComplete: number = 0;

  //---------------------------------------------------------------------------
  // Class Methods
  //---------------------------------------------------------------------------
  constructor(entityID: string) {
    super(entityID);
    this.fetch();
  }

  //---------------------------------------------------------------------------
  // Accessors
  //---------------------------------------------------------------------------

  public name() { return this.mName; }
  public portrait() { return this.mPortrait; }
  public home() { return this.mHome; }
  public xp() { return this.mXP; }
  public competencies() { return this.mCompetencies; }
  public stats() { return this.mStats; }

  public isTraining() { return this.mTrainingComplete != 0; }
  public isCertifiable() { return this.mTrainingComplete < (Date.now() / 1000); }
  public trainingComplete() { return this.mTrainingComplete; }

  //---------------------------------------------------------------------------
  // Transactions
  //---------------------------------------------------------------------------
  public async beginTraining(field: FieldEnum) {
    // This is where I would want to fetch the contract and do an operation
    await Game.MUDSystemCalls().voidsmanTrain(super.getID(), field);
  }

  public async certifyTraining() {
    // This is where I would want to fetch the contract and do an operation
    await Game.MUDSystemCalls().voidsmanCertify(super.getID());
  }

  //---------------------------------------------------------------------------
  // Setters
  //---------------------------------------------------------------------------

  public setCompetencies(comps: number[]) {
    this.mCompetencies = comps;
  }

  public setStats(stats: number[]) {
    this.mStats = stats;
  }

  public setXP(xp: number) {
    this.mXP = xp;
  }

  //---------------------------------------------------------------------------
  // Static Helper Functions
  //---------------------------------------------------------------------------
  private fetch() {
    const {
      VoidsmanPersonaTable,
      VoidsmanInfoTable,
      VoidsmanTrainingTable
    } = Game.MUDComponents();

    const entity = super.getID();

    // Read out the mostly static data
    const persona = getComponentValueStrict(VoidsmanPersonaTable, entity);
    this.mName = persona.name as string;
    this.mHome = persona.home as HomeEnum;
    this.mPortrait = persona.portrait as string;


    // Readout persona data
    const info = getComponentValueStrict(VoidsmanInfoTable, entity);

    this.mXP = info.xp as number;
    this.mCompetencies = info.comps as number[];
    this.mStats = info.stats as number[];


    // Readout training data
    const training = getComponentValue(VoidsmanTrainingTable, entity);
    if (training) {
      this.mTrainingComplete = Number(training.time);
    }
    else {
      this.mTrainingComplete = 0;
    }
  }
}
