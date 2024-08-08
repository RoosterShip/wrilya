
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonMarketIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // market_h
    const market_h = scene.add.image(0, 0, "social_h");
    market_h.setOrigin(0, 0);
    this.add(market_h);

    // market_n
    const market_n = scene.add.image(0, 0, "social_n");
    market_n.setOrigin(0, 0);
    this.add(market_n);

    // market_p
    const market_p = scene.add.image(0, 0, "social_p");
    market_p.setOrigin(0, 0);
    this.add(market_p);

    // market_d
    const market_d = scene.add.image(0, 0, "social_p");
    market_d.setOrigin(0, 0);
    this.add(market_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 24, 24);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // tooltip
    const tooltip = scene.add.text(-36, 24, "", {});
    tooltip.visible = false;
    tooltip.text = "Market Place";
    tooltip.setStyle({ "backgroundColor": "#000000c8", "fontFamily": "system-ui" });
    this.add(tooltip);

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      market_n,
      market_p,
      market_h,
      market_d
    )
    this.onClick = () => {
      scene.scene.start("Market");
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
