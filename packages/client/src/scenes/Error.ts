
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Error extends Phaser.Scene {

  constructor() {
    super("Error");

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  editorCreate(): void {

    // text_1
    const text_1 = this.add.text(640, 360, "", {});
    text_1.setOrigin(0.5, 0.5);
    text_1.text = "ERROR!!!!!";
    text_1.setStyle({ "fontSize": "128px" });

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
