
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonGalaxyIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // galaxy_h
    const galaxy_h = scene.add.image(0, 0, "worldmap_h");
    galaxy_h.setOrigin(0, 0);
    this.add(galaxy_h);

    // galaxy_n
    const galaxy_n = scene.add.image(0, 0, "worldmap_n");
    galaxy_n.setOrigin(0, 0);
    this.add(galaxy_n);

    // galaxy_p
    const galaxy_p = scene.add.image(0, 0, "worldmap_p");
    galaxy_p.setOrigin(0, 0);
    this.add(galaxy_p);

    // galaxy_d
    const galaxy_d = scene.add.image(0, 0, "worldmap_p");
    galaxy_d.setOrigin(0, 0);
    this.add(galaxy_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 25, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // tooltip
    const tooltip = scene.add.text(-12, 24, "", {});
    tooltip.visible = false;
    tooltip.text = "Galaxy";
    tooltip.setStyle({ "backgroundColor": "#000000c8", "fontFamily": "system-ui" });
    this.add(tooltip);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      galaxy_n,
      galaxy_p,
      galaxy_h,
      galaxy_d
    )
    this.onClick = () => {
      scene.scene.start("Galaxy");
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
