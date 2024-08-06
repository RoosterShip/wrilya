
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIWindowLogin from "../prefab/ui/window/UIWindowLogin";
import UIButtonWide from "../prefab/ui/button/UIButtonWide";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Login extends Phaser.Scene {

  constructor() {
    super("Login");

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  editorCreate(): void {

    // login_screen
    const login_screen = this.add.image(0, 0, "login_screen");
    login_screen.scaleX = 0.67;
    login_screen.scaleY = 0.67;
    login_screen.setOrigin(0, 0);

    // wndLogin
    const wndLogin = new UIWindowLogin(this, 490, 245);
    this.add.existing(wndLogin);

    // btnDiscord
    const btnDiscord = new UIButtonWide(this, 50, 650);
    this.add.existing(btnDiscord);

    // btnWebsite
    const btnWebsite = new UIButtonWide(this, 50, 600);
    this.add.existing(btnWebsite);

    // btnOptions
    const btnOptions = new UIButtonWide(this, 1070, 600);
    this.add.existing(btnOptions);

    // btnCredits
    const btnCredits = new UIButtonWide(this, 1070, 650);
    this.add.existing(btnCredits);

    // bgTitle
    const bgTitle = this.add.rectangle(0, 0, 1280, 144);
    bgTitle.setOrigin(0, 0);
    bgTitle.isFilled = true;
    bgTitle.fillColor = 790559;
    bgTitle.fillAlpha = 0.4;

    // lblTitle
    const lblTitle = this.add.text(640, 80, "", {});
    lblTitle.setOrigin(0.5, 0.5);
    lblTitle.text = "WRILYA";
    lblTitle.setStyle({ "fontFamily": "system-ui", "fontSize": "128px", "shadow.fill":true});

    // bloomFx
    lblTitle.preFX!.addBloom(16777215, 1, 1, 1, 1, 4);

    // btnDiscord (prefab fields)
    btnDiscord.lblText = "DISCORD";

    // btnWebsite (prefab fields)
    btnWebsite.lblText = "WEBSITE";

    // btnOptions (prefab fields)
    btnOptions.lblText = "OPTIONS";

    // btnCredits (prefab fields)
    btnCredits.lblText = "CREDITS";

    this.events.emit("scene-awake");
  }

  /* START-USER-CODE */

  // Write your code here

  create() {

    this.editorCreate();
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
