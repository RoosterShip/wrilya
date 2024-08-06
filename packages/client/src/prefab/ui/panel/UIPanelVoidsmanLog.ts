
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIPanelVoidsmanLog extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // text_1
    const text_1 = scene.add.text(2, 2, "", {});
    text_1.text = "Missions";
    text_1.setStyle({ "fontFamily": "system-ui" });
    this.add(text_1);

    // text
    const text = scene.add.text(184, 2, "", {});
    text.setOrigin(1, 0);
    text.text = "000";
    text.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text);

    // text_2
    const text_2 = scene.add.text(2, 32, "", {});
    text_2.text = "Completed";
    text_2.setStyle({ "fontFamily": "system-ui" });
    this.add(text_2);

    // text_3
    const text_3 = scene.add.text(184, 32, "", {});
    text_3.setOrigin(1, 0);
    text_3.text = "000";
    text_3.setStyle({ "align": "right", "color": "#00ff00ff", "fontFamily": "system-ui" });
    this.add(text_3);

    // text_4
    const text_4 = scene.add.text(2, 62, "", {});
    text_4.text = "Failed";
    text_4.setStyle({ "fontFamily": "system-ui" });
    this.add(text_4);

    // text_5
    const text_5 = scene.add.text(184, 62, "", {});
    text_5.setOrigin(1, 0);
    text_5.text = "000";
    text_5.setStyle({ "align": "right", "color": "#FF0000FF", "fontFamily": "system-ui" });
    this.add(text_5);

    // text_6
    const text_6 = scene.add.text(2, 172, "", {});
    text_6.text = "Respecs";
    text_6.setStyle({ "fontFamily": "system-ui" });
    this.add(text_6);

    // text_7
    const text_7 = scene.add.text(184, 172, "", {});
    text_7.setOrigin(1, 0);
    text_7.text = "000";
    text_7.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_7);

    // text_8
    const text_8 = scene.add.text(2, 202, "", {});
    text_8.text = "Experience";
    text_8.setStyle({ "fontFamily": "system-ui" });
    this.add(text_8);

    // text_9
    const text_9 = scene.add.text(184, 202, "", {});
    text_9.setOrigin(1, 0);
    text_9.text = "00000";
    text_9.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_9);

    // text_10
    const text_10 = scene.add.text(2, 232, "", {});
    text_10.text = "Level";
    text_10.setStyle({ "fontFamily": "system-ui" });
    this.add(text_10);

    // text_11
    const text_11 = scene.add.text(184, 232, "", {});
    text_11.setOrigin(1, 0);
    text_11.text = "00000";
    text_11.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_11);

    // text_12
    const text_12 = scene.add.text(2, 262, "", {});
    text_12.text = "Next Level";
    text_12.setStyle({ "fontFamily": "system-ui" });
    this.add(text_12);

    // text_13
    const text_13 = scene.add.text(184, 262, "", {});
    text_13.setOrigin(1, 0);
    text_13.text = "00000";
    text_13.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_13);

    // text_14
    const text_14 = scene.add.text(2, 92, "", {});
    text_14.text = "Enemy Kills";
    text_14.setStyle({ "fontFamily": "system-ui" });
    this.add(text_14);

    // text_15
    const text_15 = scene.add.text(184, 92, "", {});
    text_15.setOrigin(1, 0);
    text_15.text = "000";
    text_15.setStyle({ "align": "right", "color": "#00ff00ff", "fontFamily": "system-ui" });
    this.add(text_15);

    // text_16
    const text_16 = scene.add.text(2, 122, "", {});
    text_16.text = "Cloned";
    text_16.setStyle({ "fontFamily": "system-ui" });
    this.add(text_16);

    // text_17
    const text_17 = scene.add.text(184, 122, "", {});
    text_17.setOrigin(1, 0);
    text_17.text = "000";
    text_17.setStyle({ "align": "right", "color": "#FF0000FF", "fontFamily": "system-ui" });
    this.add(text_17);

    // rep_empty_frame
    const rep_empty_frame = scene.add.image(2, 152, "rep_empty_frame");
    rep_empty_frame.setOrigin(0, 0);
    this.add(rep_empty_frame);

    // rep_empty_frame_1
    const rep_empty_frame_1 = scene.add.image(2, 292, "rep_empty_frame");
    rep_empty_frame_1.setOrigin(0, 0);
    this.add(rep_empty_frame_1);

    // text_18
    const text_18 = scene.add.text(2, 312, "", {});
    text_18.text = "Thing 1";
    text_18.setStyle({ "fontFamily": "system-ui" });
    this.add(text_18);

    // text_19
    const text_19 = scene.add.text(2, 342, "", {});
    text_19.text = "Thing 2";
    text_19.setStyle({ "fontFamily": "system-ui" });
    this.add(text_19);

    // text_20
    const text_20 = scene.add.text(2, 372, "", {});
    text_20.text = "Thing 3";
    text_20.setStyle({ "fontFamily": "system-ui" });
    this.add(text_20);

    // text_21
    const text_21 = scene.add.text(2, 402, "", {});
    text_21.text = "Thing 4";
    text_21.setStyle({ "fontFamily": "system-ui" });
    this.add(text_21);

    // text_22
    const text_22 = scene.add.text(2, 432, "", {});
    text_22.text = "Thing 5";
    text_22.setStyle({ "fontFamily": "system-ui" });
    this.add(text_22);

    // text_23
    const text_23 = scene.add.text(2, 462, "", {});
    text_23.text = "Thing 6";
    text_23.setStyle({ "fontFamily": "system-ui" });
    this.add(text_23);

    // text_24
    const text_24 = scene.add.text(184, 312, "", {});
    text_24.setOrigin(1, 0);
    text_24.text = "000";
    text_24.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_24);

    // text_25
    const text_25 = scene.add.text(184, 342, "", {});
    text_25.setOrigin(1, 0);
    text_25.text = "000";
    text_25.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_25);

    // text_26
    const text_26 = scene.add.text(184, 372, "", {});
    text_26.setOrigin(1, 0);
    text_26.text = "000";
    text_26.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_26);

    // text_27
    const text_27 = scene.add.text(184, 402, "", {});
    text_27.setOrigin(1, 0);
    text_27.text = "000";
    text_27.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_27);

    // text_28
    const text_28 = scene.add.text(184, 432, "", {});
    text_28.setOrigin(1, 0);
    text_28.text = "000";
    text_28.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_28);

    // text_29
    const text_29 = scene.add.text(183, 462, "", {});
    text_29.setOrigin(1, 0);
    text_29.text = "000";
    text_29.setStyle({ "align": "right", "fontFamily": "system-ui" });
    this.add(text_29);

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
