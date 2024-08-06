
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonMissionIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // missions_h
    const missions_h = scene.add.image(0, 0, "missions_h");
    missions_h.setOrigin(0, 0);
    this.add(missions_h);

    // missions_n
    const missions_n = scene.add.image(0, 0, "missions_n");
    missions_n.setOrigin(0, 0);
    this.add(missions_n);

    // missions_p
    const missions_p = scene.add.image(0, 0, "missions_p");
    missions_p.setOrigin(0, 0);
    this.add(missions_p);

    // missions_d
    const missions_d = scene.add.image(0, 0, "missions_p");
    missions_d.setOrigin(0, 0);
    this.add(missions_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 22, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    /* START-USER-CTR-CODE */
   this.setup(
      hitbox,
      missions_n,
      missions_p,
      missions_h,
      missions_d
    )
    this.onClick = () => {
      scene.scene.start("Mission");
    }
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
