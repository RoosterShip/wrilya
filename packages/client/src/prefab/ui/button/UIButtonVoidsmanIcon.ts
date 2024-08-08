
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonVoidsmanIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // character_h
    const character_h = scene.add.image(0, 0, "character_h");
    character_h.setOrigin(0, 0);
    this.add(character_h);

    // character_n
    const character_n = scene.add.image(0, 0, "character_n");
    character_n.setOrigin(0, 0);
    this.add(character_n);

    // character_p
    const character_p = scene.add.image(0, 0, "character_p");
    character_p.setOrigin(0, 0);
    this.add(character_p);

    // character_d
    const character_d = scene.add.image(0, 0, "character_p");
    character_d.setOrigin(0, 0);
    this.add(character_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 21, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // tooltip
    const tooltip = scene.add.text(-21, 26, "", {});
    tooltip.visible = false;
    tooltip.text = "Voidsman";
    tooltip.setStyle({ "backgroundColor": "#000000c8", "fontFamily": "system-ui" });
    this.add(tooltip);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      character_n,
      character_p,
      character_h,
      character_d
    )
    this.onClick = () => {
      scene.scene.start("Voidsman");
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
