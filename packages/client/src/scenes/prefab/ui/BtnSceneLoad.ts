
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';
/* END-USER-IMPORTS */

export default class BtnSceneLoad extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // btna
    const btna = scene.add.image(0, 0, "BTNA");
    btna.setOrigin(0, 0);
    this.add(btna);

    // btn
    const btn = scene.add.image(0, 0, "BTN");
    btn.setOrigin(0, 0);
    this.add(btn);

    // recHitBox
    const recHitBox = scene.add.rectangle(0, 0, 421, 171);
    recHitBox.setOrigin(0, 0);
    this.add(recHitBox);

    /* START-USER-CTR-CODE */
    this.onClick = () => { };
    this.onUp = () => { };
    this.onDown = () => { };
    this.onOut = () => { };

    const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
    const button = rexButton.add(recHitBox, {});
    button.on('click', () => {
      this.scene.scene.start(this.nextScene);
      this.onClick();
    });
    button.on('down', () => {
      btn.visible = false;
      this.onDown();
    });
    button.on('up', () => {
      btn.visible = true;
      this.onUp();
    });
    button.on('out', () => {
      btn.visible = true;
      this.onOut();
    });


    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  public nextScene: string = "";

  /* START-USER-CODE */

  public onDown: () => void;
  public onUp: () => void;
  public onOut: () => void;
  public onClick: () => void;

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
