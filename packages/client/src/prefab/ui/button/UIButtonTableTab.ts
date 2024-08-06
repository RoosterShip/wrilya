
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonTableTab extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // tab_not_selected
    const tab_not_selected = scene.add.image(0, 0, "tab_not_selected");
    tab_not_selected.setOrigin(0, 0);
    this.add(tab_not_selected);

    // tab_hover
    const tab_hover = scene.add.image(0, 0, "tab_hovered");
    tab_hover.setOrigin(0, 0);
    this.add(tab_hover);

    // tab_pressed
    const tab_pressed = scene.add.image(0, 1, "tab_pressed");
    tab_pressed.setOrigin(0, 0);
    this.add(tab_pressed);

    // tab_selected
    const tab_selected = scene.add.image(0, -1, "tab_selected");
    tab_selected.setOrigin(0, 0);
    this.add(tab_selected);

    // text
    const text = scene.add.text(51, 16, "", {});
    text.setOrigin(0.5, 0.5);
    text.text = "Blah";
    text.setStyle({ "align": "center", "color": "#c6d3e5ff", "fontFamily": "system-ui" });
    this.add(text);

    // hitbox
    const hitbox = scene.add.rectangle(0, 2, 101, 26);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    this.text = text;

    /* START-USER-CTR-CODE */
    //super.setup(
    //  hitbox,
    //  dd_n,
    //  dd_p,
    //  dd_h,
    //  dd_d
    //);
    /* END-USER-CTR-CODE */
  }

  private text: Phaser.GameObjects.Text;
  public lblText: string = "NOT SET";

  /* START-USER-CODE */

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  update(_time: number, _delta: number) {
    this.text.text = this.lblText;
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
