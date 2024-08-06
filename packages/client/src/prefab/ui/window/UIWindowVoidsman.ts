
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIPanelVoidsmanLog from "../panel/UIPanelVoidsmanLog";
import UIButtonTableTab from "../button/UIButtonTableTab";
import UIWindowClose from "../button/UIWindowClose";
/* START-USER-IMPORTS */

/* END-USER-IMPORTS */

export default class UIWindowVoidsman extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // h_m_004
    const h_m_004 = scene.add.image(199, 224, "h_m_004");
    h_m_004.scaleX = 0.25;
    h_m_004.scaleY = 0.25;
    this.add(h_m_004);

    // voidsman_box
    const voidsman_box = scene.add.image(0, 0, "voidsman_box");
    voidsman_box.setOrigin(0, 0);
    this.add(voidsman_box);

    // stats_carving
    const stats_carving = scene.add.image(114, 526, "stats_carving");
    this.add(stats_carving);

    // stats_carving_1
    const stats_carving_1 = scene.add.image(284, 526, "stats_carving");
    this.add(stats_carving_1);

    // dd_n
    const dd_n = scene.add.image(114, 463, "dd_n");
    this.add(dd_n);

    // dd_n_1
    const dd_n_1 = scene.add.image(284, 463, "dd_n");
    this.add(dd_n_1);

    // text_1
    const text_1 = scene.add.text(40, 455, "", {});
    text_1.text = "KNOWLEDGE";
    text_1.setStyle({ "fontFamily": "system-ui", "fontSize": "12px", "fontStyle": "bold" });
    this.add(text_1);

    // text
    const text = scene.add.text(211, 455, "", {});
    text.text = "ABILITIES";
    text.setStyle({ "fontFamily": "system-ui", "fontSize": "12px", "fontStyle": "bold" });
    this.add(text);

    // text_2
    const text_2 = scene.add.text(40, 480, "", {});
    text_2.text = "Command";
    text_2.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_2);

    // text_3
    const text_3 = scene.add.text(40, 499, "", {});
    text_3.text = "Pilot";
    text_3.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_3);

    // text_4
    const text_4 = scene.add.text(40, 517, "", {});
    text_4.text = "Weapons";
    text_4.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_4);

    // text_5
    const text_5 = scene.add.text(40, 535, "", {});
    text_5.text = "Shields";
    text_5.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_5);

    // text_6
    const text_6 = scene.add.text(40, 571, "", {});
    text_6.text = "Sensors";
    text_6.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_6);

    // text_7
    const text_7 = scene.add.text(40, 589, "", {});
    text_7.text = "Medical";
    text_7.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_7);

    // text_8
    const text_8 = scene.add.text(40, 553, "", {});
    text_8.text = "Shipcraft";
    text_8.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_8);

    // text_9
    const text_9 = scene.add.text(211, 480, "", {});
    text_9.text = "Fitness";
    text_9.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_9);

    // text_10
    const text_10 = scene.add.text(211, 499, "", {});
    text_10.text = "Psyche";
    text_10.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_10);

    // text_11
    const text_11 = scene.add.text(211, 517, "", {});
    text_11.text = "Technique";
    text_11.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_11);

    // text_12
    const text_12 = scene.add.text(211, 535, "", {});
    text_12.text = "Intelligence";
    text_12.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_12);

    // text_13
    const text_13 = scene.add.text(211, 571, "", {});
    text_13.text = "Endurance";
    text_13.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_13);

    // text_14
    const text_14 = scene.add.text(211, 589, "", {});
    text_14.text = "Reflex";
    text_14.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_14);

    // text_15
    const text_15 = scene.add.text(211, 553, "", {});
    text_15.text = "Focus";
    text_15.setStyle({ "color": "#737373ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_15);

    // text_16
    const text_16 = scene.add.text(190, 480, "", {});
    text_16.setOrigin(1, 0);
    text_16.text = "00";
    text_16.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_16);

    // text_17
    const text_17 = scene.add.text(190, 499, "", {});
    text_17.setOrigin(1, 0);
    text_17.text = "00";
    text_17.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_17);

    // text_18
    const text_18 = scene.add.text(190, 517, "", {});
    text_18.setOrigin(1, 0);
    text_18.text = "00";
    text_18.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_18);

    // text_19
    const text_19 = scene.add.text(190, 535, "", {});
    text_19.setOrigin(1, 0);
    text_19.text = "00";
    text_19.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_19);

    // text_20
    const text_20 = scene.add.text(190, 553, "", {});
    text_20.setOrigin(1, 0);
    text_20.text = "00";
    text_20.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_20);

    // text_21
    const text_21 = scene.add.text(190, 571, "", {});
    text_21.setOrigin(1, 0);
    text_21.text = "00";
    text_21.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_21);

    // text_22
    const text_22 = scene.add.text(190, 589, "", {});
    text_22.setOrigin(1, 0);
    text_22.text = "00";
    text_22.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_22);

    // text_23
    const text_23 = scene.add.text(360, 480, "", {});
    text_23.setOrigin(1, 0);
    text_23.text = "00";
    text_23.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_23);

    // text_24
    const text_24 = scene.add.text(360, 499, "", {});
    text_24.setOrigin(1, 0);
    text_24.text = "00";
    text_24.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_24);

    // text_25
    const text_25 = scene.add.text(360, 517, "", {});
    text_25.setOrigin(1, 0);
    text_25.text = "00";
    text_25.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_25);

    // text_26
    const text_26 = scene.add.text(360, 535, "", {});
    text_26.setOrigin(1, 0);
    text_26.text = "00";
    text_26.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_26);

    // text_27
    const text_27 = scene.add.text(360, 553, "", {});
    text_27.setOrigin(1, 0);
    text_27.text = "00";
    text_27.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_27);

    // text_28
    const text_28 = scene.add.text(360, 571, "", {});
    text_28.setOrigin(1, 0);
    text_28.text = "00";
    text_28.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_28);

    // text_29
    const text_29 = scene.add.text(360, 589, "", {});
    text_29.setOrigin(1, 0);
    text_29.text = "00";
    text_29.setStyle({ "color": "#00ff00ff", "fontFamily": "system-ui", "fontSize": "12px" });
    this.add(text_29);

    // text_30
    const text_30 = scene.add.text(307, 25, "", {});
    text_30.setOrigin(0.5, 0.5);
    text_30.text = "VOIDSMAN DATA SHEET";
    text_30.setStyle({ "color": "#b1d1e3ff", "fontFamily": "system-ui", "fontSize": "24px" });
    this.add(text_30);

    // uIPanelVoidsmanLog
    const uIPanelVoidsmanLog = new UIPanelVoidsmanLog(scene, 376, 110);
    this.add(uIPanelVoidsmanLog);

    // text_31
    const text_31 = scene.add.text(196, 82, "", {});
    text_31.setOrigin(0.5, 0.5);
    text_31.text = "VOIDSMAN NAME HERE";
    text_31.setStyle({ "align": "center", "color": "#b1d1e3ff", "fontFamily": "system-ui" });
    this.add(text_31);

    // uIButtonTableTab_1
    const uIButtonTableTab_1 = new UIButtonTableTab(scene, 470, 70);
    this.add(uIButtonTableTab_1);

    // uIButtonTableTab
    const uIButtonTableTab = new UIButtonTableTab(scene, 371, 70);
    this.add(uIButtonTableTab);

    // eq_slot_helmet_mask
    const eq_slot_helmet_mask = scene.add.image(54, 126, "box_portrait_mask");
    eq_slot_helmet_mask.scaleX = 0.7;
    eq_slot_helmet_mask.scaleY = 0.7;
    this.add(eq_slot_helmet_mask);

    // eq_slot_helmet
    const eq_slot_helmet = scene.add.image(54, 126, "eq_slot_helmet");
    this.add(eq_slot_helmet);

    // eq_slot_insignia_mask
    const eq_slot_insignia_mask = scene.add.image(343, 126, "box_portrait_mask");
    eq_slot_insignia_mask.scaleX = 0.7;
    eq_slot_insignia_mask.scaleY = 0.7;
    this.add(eq_slot_insignia_mask);

    // eq_slot_insignia
    const eq_slot_insignia = scene.add.image(343, 126, "eq_slot_insignia");
    this.add(eq_slot_insignia);

    // eq_slot_dogtags_mask
    const eq_slot_dogtags_mask = scene.add.image(54, 193, "box_portrait_mask");
    eq_slot_dogtags_mask.scaleX = 0.7;
    eq_slot_dogtags_mask.scaleY = 0.7;
    this.add(eq_slot_dogtags_mask);

    // eq_slot_dogtags
    const eq_slot_dogtags = scene.add.image(54, 193, "eq_slot_dogtags");
    this.add(eq_slot_dogtags);

    // box_portrait_mask_6
    const box_portrait_mask_6 = scene.add.image(343, 193, "box_portrait_mask");
    box_portrait_mask_6.scaleX = 0.7;
    box_portrait_mask_6.scaleY = 0.7;
    this.add(box_portrait_mask_6);

    // eq_slot_implant
    const eq_slot_implant = scene.add.image(343, 195, "eq_slot_implant");
    this.add(eq_slot_implant);

    // box_portrait_mask_2
    const box_portrait_mask_2 = scene.add.image(54, 260, "box_portrait_mask");
    box_portrait_mask_2.scaleX = 0.7;
    box_portrait_mask_2.scaleY = 0.7;
    this.add(box_portrait_mask_2);

    // eq_slot_gloves
    const eq_slot_gloves = scene.add.image(54, 255, "eq_slot_gloves");
    this.add(eq_slot_gloves);

    // box_portrait_mask_7
    const box_portrait_mask_7 = scene.add.image(343, 260, "box_portrait_mask");
    box_portrait_mask_7.scaleX = 0.7;
    box_portrait_mask_7.scaleY = 0.7;
    this.add(box_portrait_mask_7);

    // eq_slot_bracers
    const eq_slot_bracers = scene.add.image(344, 260, "eq_slot_bracers");
    this.add(eq_slot_bracers);

    // box_portrait_mask_4
    const box_portrait_mask_4 = scene.add.image(54, 326, "box_portrait_mask");
    box_portrait_mask_4.scaleX = 0.7;
    box_portrait_mask_4.scaleY = 0.7;
    this.add(box_portrait_mask_4);

    // eq_slot_chest
    const eq_slot_chest = scene.add.image(56, 327, "eq_slot_chest");
    this.add(eq_slot_chest);

    // box_portrait_mask_8
    const box_portrait_mask_8 = scene.add.image(343, 326, "box_portrait_mask");
    box_portrait_mask_8.scaleX = 0.7;
    box_portrait_mask_8.scaleY = 0.7;
    this.add(box_portrait_mask_8);

    // eq_slot_artifact
    const eq_slot_artifact = scene.add.image(342, 328, "eq_slot_artifact");
    this.add(eq_slot_artifact);

    // box_portrait_mask_1
    const box_portrait_mask_1 = scene.add.image(54, 392, "box_portrait_mask");
    box_portrait_mask_1.scaleX = 0.7;
    box_portrait_mask_1.scaleY = 0.7;
    this.add(box_portrait_mask_1);

    // eq_slot_pants
    const eq_slot_pants = scene.add.image(53, 394, "eq_slot_pants");
    this.add(eq_slot_pants);

    // box_portrait_mask_9
    const box_portrait_mask_9 = scene.add.image(343, 392, "box_portrait_mask");
    box_portrait_mask_9.scaleX = 0.7;
    box_portrait_mask_9.scaleY = 0.7;
    this.add(box_portrait_mask_9);

    // eq_slot_boots
    const eq_slot_boots = scene.add.image(342, 394, "eq_slot_boots");
    this.add(eq_slot_boots);

    // uIWindowClose
    const uIWindowClose = new UIWindowClose(scene, 562, 9);
    this.add(uIWindowClose);

    // text_32
    const text_32 = scene.add.text(200, 373, "", {});
    text_32.setOrigin(0.5, 0.5);
    text_32.text = "HOME WORLD";
    text_32.setStyle({ "align": "center", "color": "#ffffffff", "fontFamily": "system-ui" });
    this.add(text_32);

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
