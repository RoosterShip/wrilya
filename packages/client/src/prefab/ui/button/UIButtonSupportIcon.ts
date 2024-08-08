
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonSupportIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // support_h
    const support_h = scene.add.image(0, 0, "support_h");
    support_h.setOrigin(0, 0);
    this.add(support_h);

    // support_n
    const support_n = scene.add.image(0, 0, "support_n");
    support_n.setOrigin(0, 0);
    this.add(support_n);

    // support_p
    const support_p = scene.add.image(0, 0, "support_p");
    support_p.setOrigin(0, 0);
    this.add(support_p);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 25, 24);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // support_d
    const support_d = scene.add.image(0, 0, "support_p");
    support_d.setOrigin(0, 0);
    this.add(support_d);

    // tooltip
    const tooltip = scene.add.text(-14, 24, "", {});
    tooltip.visible = false;
    tooltip.text = "Support";
    tooltip.setStyle({ "backgroundColor": "#000000c8", "fontFamily": "system-ui" });
    this.add(tooltip);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      support_n,
      support_p,
      support_h,
      support_d
    )
    this.onClick = () => {
      scene.scene.start("Support");
    }
    this.onOver = () => {
      tooltip.visible = true;
    }
    this.onOut = () => {
      tooltip.visible = false;
    }
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
