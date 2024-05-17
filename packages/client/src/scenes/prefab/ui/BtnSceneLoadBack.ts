
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';
/* END-USER-IMPORTS */

export default class BtnSceneLoadBack extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // btnBackA
    const btnBackA = scene.add.image(0, 0, "Backward_BTNA");
    btnBackA.scaleX = 0.5;
    btnBackA.scaleY = 0.5;
    btnBackA.setOrigin(0, 0);
    this.add(btnBackA);

    // btnBack
    const btnBack = scene.add.image(0, 0, "Backward_BTN");
    btnBack.name = "btnBack";
    btnBack.scaleX = 0.5;
    btnBack.scaleY = 0.5;
    btnBack.setOrigin(0, 0);
    this.add(btnBack);

    // recHitBox
    const recHitBox = scene.add.rectangle(0, 0, 210, 210);
    recHitBox.scaleX = 0.5;
    recHitBox.scaleY = 0.5;
    recHitBox.setOrigin(0, 0);
    this.add(recHitBox);

    this.btnBackA = btnBackA;
    this.btnBack = btnBack;
    this.recHitBox = recHitBox;

    /* START-USER-CTR-CODE */
    const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
    const button = rexButton.add(this.recHitBox, {});
    button.on('click', () => {
      this.scene.scene.start(this.nextScene);
    });
    button.on('down', () => {
      this.btnBack.visible = false;
    });
    button.on('up', () => {
      this.btnBack.visible = true;
    });
    button.on('out', () => {
      this.btnBack.visible = true;
    });
    /* END-USER-CTR-CODE */
  }

  private btnBackA: Phaser.GameObjects.Image;
  private btnBack: Phaser.GameObjects.Image;
  private recHitBox: Phaser.GameObjects.Rectangle;
  public nextScene: string = "Main";

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
