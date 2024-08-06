
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonNext extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // right_arrow_h
    const right_arrow_h = scene.add.image(0, 0, "right_arrow_h");
    right_arrow_h.setOrigin(0, 0);
    this.add(right_arrow_h);

    // right_arrow_n
    const right_arrow_n = scene.add.image(0, 0, "right_arrow_n");
    right_arrow_n.setOrigin(0, 0);
    this.add(right_arrow_n);

    // right_arrow_p
    const right_arrow_p = scene.add.image(0, 0, "right_arrow_p");
    right_arrow_p.setOrigin(0, 0);
    this.add(right_arrow_p);

    // right_arrow_d
    const right_arrow_d = scene.add.image(0, 0, "right_arrow_p");
    right_arrow_d.setOrigin(0, 0);
    this.add(right_arrow_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 21, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      right_arrow_n,
      right_arrow_p,
      right_arrow_h,
      right_arrow_d
    );
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
