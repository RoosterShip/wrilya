
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIWindowClose extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // close_d
    const close_d = scene.add.image(0, 0, "close_d");
    close_d.setOrigin(0, 0);
    this.add(close_d);

    // close_p
    const close_p = scene.add.image(0, 0, "close_p");
    close_p.setOrigin(0, 0);
    this.add(close_p);

    // close_h
    const close_h = scene.add.image(0, 0, "close_h");
    close_h.setOrigin(0, 0);
    this.add(close_h);

    // close_n
    const close_n = scene.add.image(0, 0, "close_n");
    close_n.setOrigin(0, 0);
    this.add(close_n);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 27, 27);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      close_n,
      close_p,
      close_h,
      close_d
    )
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
