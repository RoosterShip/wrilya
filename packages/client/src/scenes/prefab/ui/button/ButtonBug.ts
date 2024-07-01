
// You can write more code here

/* START OF COMPILED CODE */

import ButtonStd from "./ButtonStd";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class ButtonBug extends ButtonStd {

    constructor(scene: Phaser.Scene, x?: number, y?: number) {
        super(scene, x ?? 0, y ?? 0);

        // img_button_d
        const img_button_d = scene.add.image(0, 0, "button_tab_d");
        img_button_d.setOrigin(0, 0);
        this.add(img_button_d);

        // img_button_h
        const img_button_h = scene.add.image(0, 0, "button_tab_h");
        img_button_h.setOrigin(0, 0);
        this.add(img_button_h);

        // img_button_p
        const img_button_p = scene.add.image(0, 0, "button_tab_p");
        img_button_p.setOrigin(0, 0);
        this.add(img_button_p);

        // img_button_n
        const img_button_n = scene.add.image(0, 0, "button_tab_n");
        img_button_n.setOrigin(0, 0);
        this.add(img_button_n);

        // img_icon_bugs
        const img_icon_bugs = scene.add.image(25, 26, "icon_bugs");
        this.add(img_icon_bugs);

        // lbl_bug_text
        const lbl_bug_text = scene.add.text(45, 15, "", {});
        lbl_bug_text.text = "Bug Report";
        lbl_bug_text.setStyle({ "color": "#4dd9f2", "fontFamily": "Eurostile Bold Extended", "fontSize": "24px", "shadow.offsetY":1,"shadow.blur":1,"shadow.fill":true});
        this.add(lbl_bug_text);

        // rec_hitbox
        const rec_hitbox = scene.add.rectangle(1, 1, 278, 51);
        rec_hitbox.setOrigin(0, 0);
        this.add(rec_hitbox);

        /* START-USER-CTR-CODE */
        super.setup(
            rec_hitbox,
            img_button_n,
            img_button_p,
            img_button_h,
            img_button_d
        );
        /* END-USER-CTR-CODE */
    }

    /* START-USER-CODE */

    // Write your code here.

    /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
