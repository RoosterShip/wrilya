
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonNormal extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // button_normal_d
    const button_normal_d = scene.add.image(0, 0, "button_normal_d");
    button_normal_d.setOrigin(0, 0);
    this.add(button_normal_d);

    // button_normal_h
    const button_normal_h = scene.add.image(0, 0, "button_normal_h");
    button_normal_h.setOrigin(0, 0);
    this.add(button_normal_h);

    // button_normal_n
    const button_normal_n = scene.add.image(0, 0, "button_normal_n");
    button_normal_n.setOrigin(0, 0);
    this.add(button_normal_n);

    // button_normal_p
    const button_normal_p = scene.add.image(0, 0, "button_normal_p");
    button_normal_p.setOrigin(0, 0);
    this.add(button_normal_p);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 106, 28);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // lblText
    const lblText = scene.add.text(53, 14, "", {});
    lblText.setOrigin(0.5, 0.5);
    lblText.setStyle({ "align": "center", "fontFamily": "system-ui", "shadow.offsetY":1,"shadow.blur":1,"shadow.fill":true});
    this.add(lblText);

    this.lblText = lblText;
    // awake handler
    this.scene.events.once("scene-awake", () => this.awake());

    /* START-USER-CTR-CODE */
    this.setup(
      hitbox,
      button_normal_n,
      button_normal_p,
      button_normal_h,
      button_normal_d
    )
    /* END-USER-CTR-CODE */
  }

  private lblText: Phaser.GameObjects.Text;
  public text: string = "";

  /* START-USER-CODE */

  private awake() {
    this.lblText.text = this.text;
  } 

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
