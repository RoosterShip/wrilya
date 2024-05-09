
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class BtnSceneLoadText extends Phaser.GameObjects.Text {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0, "", {});

    /* START-USER-CTR-CODE */
    /* END-USER-CTR-CODE */
  }

  public next: string = "";

  /* START-USER-CODE */
  loadScene() {
    this.scene.scene.switch(this.next);
  }
  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
