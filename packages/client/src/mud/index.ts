
export enum OperationEnum {
  UNKNOWN = 0,                          // 0,
  GAME_PAUSE,                           // 1
  GAME_UNPAUSE,                         // 2
  GAME_SET_ADMIN,                       // 3
  GAME_SET_GM,                          // 4
  GAME_SET_CURRENCY_PROXY,              // 5
  GAME_SET_ITEM_PROXY,                  // 6
  GAME_SET_ENTITY_PROXY,                // 7
  GAME_SET_GOVERNOR,                    // 8
  GAME_SET_VOTE_TOKEN,                  // 9
  GAME_SET_VOIDSMAN_CREATE_COST,        // 10 
  GAME_SET_VOIDSMAN_UPGRADE_TIME_BASE,  // 11
  GAME_SET_VOIDSMAN_UPGRADE_TIME_POWER, // 12
  GAME_SET_VOIDSMAN_UPGRADE_COST_BASE,  // 13
  GAME_SET_VOIDSMAN_UPGRADE_COST_POWER, // 14
  GAME_SET_VOIDSMAN_MAX_STATS,          // 15
  GAME_SET_VOIDSMAN_MAX_COMPETENCY,     // 16
  GAME_SET_STD_MAX_DEBIT,               // 17
  GAME_SET_COLLATERAL_DEBIT_RATIO,      // 18
  GAME_SET_CURRENCY_UNSTAKE_TIME,       // 19
  CURRENCY_MINT,                        // 20
  CURRENCY_STAKE,                       // 21
  CURRENCY_RELEASE,                     // 22
  CURRENCY_CLAIM,                       // 23
  CURRENCY_PAYMENT,                     // 24
  ENTITY_CREATE,                        // 25
  ENTITY_DESTROY,                       // 26
  ENTITY_TRANSFER,                      // 27
  ENTITY_UPDATE,                        // 28
  VOIDSMAN_TRAIN,                       // 29
  VOIDSMAN_TRAIN_CANCEL,                // 30
  VOIDSMAN_CERTIFY,                     // 31
  VOIDSMAN_SET_TRAINING_REQUIREMENT,    // 32

  __LENGTH
}

export enum EntityEnum {
  UNKNOWN = 0,
  VOIDSMAN,
  SHIP,
  STATION,
  PLANET,
  SOLARSYSTEM,
  __LENGTH
}

export enum HomeEnum {
  UNKNOWN = 0,
  ICOIR,
  VREL,
  PRIME,
  MILVEA,
  SAREA,
  GRAIK,
  CHIVEN,
  AIGEA,
  __LENGTH
}

export enum FieldEnum {
  UNKNOWN = 0,
  ARMOR,
  ENGINES,
  LEADERSHIP,
  NAVIGATION,
  NEGOTIATION,
  SHIPCRAFT,
  SENSORS,
  SHIELDS,
  WEAPONS,
  __LENGTH
}

export enum AbilityEnum {
  UNKNOWN = 0,
  STRENGTH,
  PSYCHE,
  TECHNIQUE,
  INTELLIGENCE,
  FOCUS,
  ENDURANCE,
  RELEXES,
  __LENGTH
}