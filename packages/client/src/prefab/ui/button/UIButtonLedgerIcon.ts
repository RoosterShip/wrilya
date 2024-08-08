
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonLedgerIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // ledger_h
    const ledger_h = scene.add.image(0, 0, "skills_h");
    ledger_h.setOrigin(0, 0);
    this.add(ledger_h);

    // ledger_n
    const ledger_n = scene.add.image(0, 0, "skills_n");
    ledger_n.setOrigin(0, 0);
    this.add(ledger_n);

    // ledger_p
    const ledger_p = scene.add.image(0, 0, "skills_p");
    ledger_p.setOrigin(0, 0);
    this.add(ledger_p);

    // ledger_d
    const ledger_d = scene.add.image(0, 0, "skills_p");
    ledger_d.setOrigin(0, 0);
    this.add(ledger_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 20, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // tooltip
    const tooltip = scene.add.text(-12, 26, "", {});
    tooltip.visible = false;
    tooltip.text = "Wallet";
    tooltip.setStyle({ "backgroundColor": "#000000c8", "fontFamily": "system-ui" });
    this.add(tooltip);

    /* START-USER-CTR-CODE */
        this.setup(
      hitbox,
      ledger_n,
      ledger_p,
      ledger_h,
      ledger_d
    )
    this.onClick = () => {
      scene.scene.start("Ledger");
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
