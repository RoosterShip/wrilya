
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIButtonWide from "../button/UIButtonWide";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIWindowLogin extends Phaser.GameObjects.Container {

    constructor(scene: Phaser.Scene, x?: number, y?: number) {
        super(scene, x ?? 0, y ?? 0);

        // boxLogin
        const boxLogin = scene.add.image(0, 0, "login_box");
        boxLogin.setOrigin(0, 0);
        this.add(boxLogin);

        // btnConnect
        const btnConnect = new UIButtonWide(scene, 74, 270);
        this.add(btnConnect);

        // lblTitle
        const lblTitle = scene.add.text(153, 39, "", {});
        lblTitle.setOrigin(0.5, 0.5);
        lblTitle.text = "LOGIN PANEL";
        lblTitle.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
        this.add(lblTitle);

        // iconDiscord
        const iconDiscord = scene.add.image(149, 174, "discord-logo-blue");
        iconDiscord.scaleX = 0.1;
        iconDiscord.scaleY = 0.1;
        this.add(iconDiscord);

        // btnConnect (prefab fields)
        btnConnect.lblText = "CONNECT";

        /* START-USER-CTR-CODE */
        btnConnect.onClick = () => {
            window.location.href = __SERVER__ + "/auth/discord";
        };
        // Write your code here.
        /* END-USER-CTR-CODE */
    }

    /* START-USER-CODE */

    // Write your code here.

    /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
