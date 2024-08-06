
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonWide extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // wide_button_d
    const wide_button_d = scene.add.image(0, 0, "wide_button_d");
    wide_button_d.setOrigin(0, 0);
    this.add(wide_button_d);

    // wide_button_h
    const wide_button_h = scene.add.image(0, 0, "wide_button_h");
    wide_button_h.setOrigin(0, 0);
    this.add(wide_button_h);

    // wide_button_p
    const wide_button_p = scene.add.image(0, 0, "wide_button_p");
    wide_button_p.setOrigin(0, 0);
    this.add(wide_button_p);

    // wide_button_n
    const wide_button_n = scene.add.image(0, 0, "wide_button_n");
    wide_button_n.setOrigin(0, 0);
    this.add(wide_button_n);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 161, 28);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    // text
    const text = scene.add.text(81, 15, "", {});
    text.setOrigin(0.5, 0.5);
    text.setStyle({ "align": "center", "backgroundColor": "#0000000f", "fontFamily": "system-ui", "fontSize": "20px", "shadow.offsetY":1,"shadow.blur":1,"shadow.fill":true});
    this.add(text);

    this.text = text;
    // awake handler
    this.scene.events.once("scene-awake", () => this.awake());

    /* START-USER-CTR-CODE */
    super.setup(
      hitbox,
      wide_button_n,
      wide_button_p,
      wide_button_h,
      wide_button_d
    );
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  private text: Phaser.GameObjects.Text;
  public lblText: string = "Not Set";

  /* START-USER-CODE */

  private awake() {
    this.text.text = this.lblText;
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
