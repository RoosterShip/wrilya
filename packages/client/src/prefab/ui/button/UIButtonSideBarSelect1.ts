
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandardSideBarEntry from "./UIButtonStandardSideBarEntry";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonSideBarSelect1 extends UIButtonStandardSideBarEntry {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // background
    const background = scene.add.image(2, 4, "select_box_bottom_texture");
    background.setOrigin(0, 0);
    this.add(background);

    // hover
    const hover = scene.add.image(0, 0, "entry_select_effect");
    hover.scaleX = 1.12;
    hover.scaleY = 0.9;
    hover.setOrigin(0, 0);
    hover.visible = false;
    this.add(hover);

    // select
    const select = scene.add.image(0, 0, "entry_hover_effect");
    select.scaleX = 1.12;
    select.scaleY = 0.9;
    select.setOrigin(0, 0);
    select.visible = false;
    this.add(select);

    // hitbox
    const hitbox = scene.add.rectangle(2, 4, 327, 65);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      select,
      hover
    );
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
