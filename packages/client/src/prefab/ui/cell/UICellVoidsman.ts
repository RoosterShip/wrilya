
// You can write more code here

/* START OF COMPILED CODE */

import UICellStandard from "./UICellStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UICellVoidsman extends UICellStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // h_f_001_t
    const h_f_001_t = scene.add.image(39, 42, "h_f_001_t");
    this.add(h_f_001_t);

    // character_entry
    const character_entry = scene.add.image(3, 5, "character_entry");
    character_entry.setOrigin(0, 0);
    this.add(character_entry);

    // entry_select_effect
    const entry_select_effect = scene.add.image(0, 0, "entry_select_effect");
    entry_select_effect.setOrigin(0, 0);
    this.add(entry_select_effect);

    // entry_hover_effect
    const entry_hover_effect = scene.add.image(0, 1, "entry_hover_effect");
    entry_hover_effect.setOrigin(0, 0);
    this.add(entry_hover_effect);

    // lblName
    const lblName = scene.add.text(73, 20, "", {});
    lblName.text = "Voidsman Name";
    lblName.setStyle({ "fontFamily": "system-ui", "fontSize": "18px", "shadow.offsetX":1,"shadow.offsetY":1,"shadow.fill":true});
    this.add(lblName);

    // lblAssignment
    const lblAssignment = scene.add.text(73, 52, "", {});
    lblAssignment.text = "asgmt: NONE";
    lblAssignment.setStyle({ "fontFamily": "system-ui", "fontSize": "12px", "shadow.offsetX":1,"shadow.offsetY":1,"shadow.fill":true});
    this.add(lblAssignment);

    // lblLevel
    const lblLevel = scene.add.text(276, 52, "", {});
    lblLevel.setOrigin(1, 0);
    lblLevel.text = "lvl: 0";
    lblLevel.setStyle({ "align": "right", "fontFamily": "system-ui", "fontSize": "12px", "shadow.offsetX":1,"shadow.offsetY":1,"shadow.fill":true});
    this.add(lblLevel);

    // hitbox
    const hitbox = scene.add.rectangle(6, 6, 280, 70);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    this.h_f_001_t = h_f_001_t;
    this.lblName = lblName;
    this.lblAssignment = lblAssignment;
    this.lblLevel = lblLevel;
    // awake handler
    this.scene.events.once("scene-awake", () => this.awake());

    /* START-USER-CTR-CODE */
    this.scene.events.on('addedtoscene', () => this.awake());
    this.setup(
      hitbox,
      entry_select_effect,
      entry_hover_effect
    );
    /* END-USER-CTR-CODE */
  }

  private h_f_001_t: Phaser.GameObjects.Image;
  private lblName: Phaser.GameObjects.Text;
  private lblAssignment: Phaser.GameObjects.Text;
  private lblLevel: Phaser.GameObjects.Text;
  public level: string = "0";
  public name: string = "NOT SET";
  public assignment: string = "NOT TEST";
  public thumbnail: string = "h_f_001_t";

  /* START-USER-CODE */

  private awake(){
    this.h_f_001_t.setTexture(this.thumbnail);
    this.lblName.text  = this.name;
    this.lblAssignment.text = "asgmt: " + this.assignment;
    this.lblLevel.text = "lvl: " + this.level;
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
