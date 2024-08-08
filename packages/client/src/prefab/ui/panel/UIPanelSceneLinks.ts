
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIButtonVoidsmanIcon from "../button/UIButtonVoidsmanIcon";
import UIButtonShipsIcon from "../button/UIButtonShipsIcon";
import UIButtonMissionIcon from "../button/UIButtonMissionIcon";
import UIButtonYardIcon from "../button/UIButtonYardIcon";
import UIButtonGalaxyIcon from "../button/UIButtonGalaxyIcon";
import UIButtonLedgerIcon from "../button/UIButtonLedgerIcon";
import UIButtonMainIcon from "../button/UIButtonMainIcon";
import UIButtonSupportIcon from "../button/UIButtonSupportIcon";
import UIButtonMarketIcon from "../button/UIButtonMarketIcon";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIPanelSceneLinks extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // links_panel
    const links_panel = scene.add.image(0, 0, "links_panel");
    links_panel.setOrigin(0, 0);
    this.add(links_panel);

    // uIButtonVoidsmanIcon
    const uIButtonVoidsmanIcon = new UIButtonVoidsmanIcon(scene, 30, 5);
    this.add(uIButtonVoidsmanIcon);

    // uIButtonShipsIcon
    const uIButtonShipsIcon = new UIButtonShipsIcon(scene, 73, 5);
    this.add(uIButtonShipsIcon);

    // uIButtonMissionIcon
    const uIButtonMissionIcon = new UIButtonMissionIcon(scene, 116, 5);
    this.add(uIButtonMissionIcon);

    // uIButtonYardIcon
    const uIButtonYardIcon = new UIButtonYardIcon(scene, 159, 5);
    this.add(uIButtonYardIcon);

    // uIButtonGalaxyIcon
    const uIButtonGalaxyIcon = new UIButtonGalaxyIcon(scene, 202, 5);
    this.add(uIButtonGalaxyIcon);

    // uIButtonLedgerIcon
    const uIButtonLedgerIcon = new UIButtonLedgerIcon(scene, 245, 5);
    this.add(uIButtonLedgerIcon);

    // uIButtonMainIcon
    const uIButtonMainIcon = new UIButtonMainIcon(scene, 375, 5);
    this.add(uIButtonMainIcon);

    // uIButtonSupportIcon
    const uIButtonSupportIcon = new UIButtonSupportIcon(scene, 331, 5);
    this.add(uIButtonSupportIcon);

    // uIButtonMarketIcon
    const uIButtonMarketIcon = new UIButtonMarketIcon(scene, 288, 5);
    this.add(uIButtonMarketIcon);

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
