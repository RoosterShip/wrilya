
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';
/* END-USER-IMPORTS */

export default class BtnStd extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // btnSTDA
    const btnSTDA = scene.add.image(0, 0, "BTNA");
    btnSTDA.setOrigin(0, 0);
    this.add(btnSTDA);

    // btnSTD
    const btnSTD = scene.add.image(0, 0, "BTN");
    btnSTD.setOrigin(0, 0);
    this.add(btnSTD);

    // hbBTN
    const hbBTN = scene.add.rectangle(0, 0, 421, 171);
    hbBTN.setOrigin(0, 0);
    this.add(hbBTN);

    /* START-USER-CTR-CODE */
    const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
    const button = rexButton.add(hbBTN, {});
    button.on('click', () => {
      this.onClick();
    });
    button.on('down', () => {
      btnSTD.visible = false;
      this.onDown();
    });
    button.on('up', () => {
      btnSTD.visible = true;
      this.onUp();
    });
    button.on('out', () => {
      btnSTD.visible = true;
      this.onOut();
    });

    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  public onDown: () => void = () => { };
  public onUp: () => void = () => { };
  public onOut: () => void = () => { };
  public onClick: () => void = () => { };

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
