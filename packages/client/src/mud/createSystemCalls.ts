/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import { getComponentValue } from "@latticexyz/recs";
import { ClientComponents } from "./createClientComponents";
import { SetupNetworkResult } from "./setupNetwork";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { Home, Field } from "./index";
import { Entity } from "@latticexyz/recs";
//import { Entity, Voidsmen } from "../entity"
//
//import { runQuery, Has, HasValue, getComponentValueStrict } from "@latticexyz/recs";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  /*
   * The parameter list informs TypeScript that:
   *
   * - The first parameter is expected to be a
   *   SetupNetworkResult, as defined in setupNetwork.ts
   *
   *   Out of this parameter, we only care about two fields:
   *   - worldContract (which comes from getContract, see
   *     https://github.com/latticexyz/mud/blob/main/templates/vanilla/packages/client/src/mud/setupNetwork.ts#L63-L69).
   *
   *   - waitForTransaction (which comes from syncToRecs, see
   *     https://github.com/latticexyz/mud/blob/main/templates/vanilla/packages/client/src/mud/setupNetwork.ts#L77-L83).
   *
   * - From the second parameter, which is a ClientComponent,
   *   we only care about Counter. This parameter comes to use
   *   through createClientComponents.ts, but it originates in
   *   syncToRecs
   *   (https://github.com/latticexyz/mud/blob/main/templates/vanilla/packages/client/src/mud/setupNetwork.ts#L77-L83).
   */
  //{ walletClient, worldContract, waitForTransaction }: SetupNetworkResult,
  //{ Counter, Crew, OwnedBy, Persona, Traits }: ClientComponents,
  { worldContract, waitForTransaction }: SetupNetworkResult,
  { Counter }: ClientComponents,
) {
  const increment = async () => {
    /*
     * Because IncrementSystem
     * (https://mud.dev/templates/typescript/contracts#incrementsystemsol)
     * is in the root namespace, `.increment` can be called directly
     * on the World contract.
     */
    const tx = await worldContract.write.increment();
    await waitForTransaction(tx);
    return getComponentValue(Counter, singletonEntity);
  };

  const recruitCrew = async (name: string, portrait: string, home: Home) => {
    const tx = await worldContract.write.recruitVoidsman([name, portrait, home]);
    await waitForTransaction(tx);
  };

  const trainVoidsman = async (entity: Entity, field: Field) => {
    console.log("*** I am doing it");
    const tx = await worldContract.write.trainVoidsman([entity as `0x${string}`, field]);
    await waitForTransaction(tx);
    console.log("*** All Done");
  };

  const certifyVoidsman = async (entity: Entity) => {
    console.log("*** I am doing it");
    const tx = await worldContract.write.certifyVoidsman([entity as `0x${string}`]);
    await waitForTransaction(tx);
    console.log("*** All Done");
  };

  /**
   * 
   * @returns 
   */
  //const getCrew = async () => {
  //  const crew = new Map<string, object>();
  //  const owner: string = Entity.toID(walletClient.account.address);
  //  // Query for all the crew members that are owned by the player
  //  const entities = runQuery([
  //    Has(Crew),
  //    HasValue(OwnedBy, { value: owner })
  //  ]);

  //  // Now pull out the data for each crew member
  //  for (const entity of entities) { crew.set(entity, getVoidsmen(entity as string)); }
  //  return crew;
  //};

  //const getVoidsmen = async (entity: string): Promise<Voidsmen> => {
  //  const persona = getComponentValueStrict(Persona, entity as MUDEntity);
  //  const traits = getComponentValueStrict(Traits, entity as MUDEntity);
  //  const voidsmen = new Voidsmen(entity);
  //  voidsmen.load(persona, traits);
  //  return voidsmen;
  //}

  return {
    increment,
    recruitCrew,
    trainVoidsman,
    certifyVoidsman,
    //getCrew,
    //getVoidsmen
  };
}
