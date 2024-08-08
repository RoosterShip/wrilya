
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonMainIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // mainmenu_h
    const mainmenu_h = scene.add.image(0, 0, "mainmenu_h");
    mainmenu_h.setOrigin(0, 0);
    this.add(mainmenu_h);

    // mainmenu_n
    const mainmenu_n = scene.add.image(0, 0, "mainmenu_n");
    mainmenu_n.setOrigin(0, 0);
    this.add(mainmenu_n);

    // mainmenu_p
    const mainmenu_p = scene.add.image(0, 0, "mainmenu_p");
    mainmenu_p.setOrigin(0, 0);
    this.add(mainmenu_p);

    // mainmenu_d
    const mainmenu_d = scene.add.image(0, 0, "mainmenu_p");
    mainmenu_d.setOrigin(0, 0);
    this.add(mainmenu_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 25, 24);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // tooltip
    const tooltip = scene.add.text(-27, 24, "", {});
    tooltip.visible = false;
    tooltip.text = "Main Menu";
    tooltip.setStyle({ "backgroundColor": "#000000c8", "fontFamily": "system-ui" });
    this.add(tooltip);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      mainmenu_n,
      mainmenu_p,
      mainmenu_h,
      mainmenu_d
    )
    this.onClick = () => {
      scene.scene.start("Main");
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
