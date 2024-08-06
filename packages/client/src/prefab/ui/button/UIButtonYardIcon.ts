
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonYardIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // yard_h
    const yard_h = scene.add.image(0, 0, "talents_h");
    yard_h.setOrigin(0, 0);
    this.add(yard_h);

    // yard_n
    const yard_n = scene.add.image(0, 0, "talents_n");
    yard_n.setOrigin(0, 0);
    this.add(yard_n);

    // yard_p
    const yard_p = scene.add.image(0, 0, "talents_p");
    yard_p.setOrigin(0, 0);
    this.add(yard_p);

    // yard_d
    const yard_d = scene.add.image(0, 0, "talents_p");
    yard_d.setOrigin(0, 0);
    this.add(yard_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 23, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      yard_n,
      yard_p,
      yard_h,
      yard_d
    )
    this.onClick = () => {
      scene.scene.start("Yard");
    }
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
