
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIPanelSceneLinks from "../prefab/ui/panel/UIPanelSceneLinks";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Main extends Phaser.Scene {

  constructor() {
    super("Main");

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  editorCreate(): void {

    // login_screen
    const login_screen = this.add.image(0, 0, "login_screen");
    login_screen.scaleX = 0.67;
    login_screen.scaleY = 0.67;
    login_screen.setOrigin(0, 0);

    // uIPanelSceneLinks
    const uIPanelSceneLinks = new UIPanelSceneLinks(this, 423, 0);
    this.add.existing(uIPanelSceneLinks);

    this.events.emit("scene-awake");
  }

  /* START-USER-CODE */

  // Write your code here

  create() {
    this.editorCreate();
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
