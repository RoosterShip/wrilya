
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIWindowVoidsman from "../prefab/ui/window/UIWindowVoidsman";
import UIWindowVoidsmanRecruit from "../prefab/ui/window/UIWindowVoidsmanRecruit";
import UIWindowVoidsmanRoster from "../prefab/ui/window/UIWindowVoidsmanRoster";
import UIPanelSceneLinks from "../prefab/ui/panel/UIPanelSceneLinks";
/* START-USER-IMPORTS */
import Game from "../game";
/* END-USER-IMPORTS */

export default class Voidsman extends Phaser.Scene {

  constructor() {
    super("Voidsman");

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  editorCreate(): void {

    // voidsman_screen
    const voidsman_screen = this.add.image(0, 0, "voidsman_screen");
    voidsman_screen.scaleX = 0.67;
    voidsman_screen.scaleY = 0.67;
    voidsman_screen.setOrigin(0, 0);

    // wndVoidsman
    const wndVoidsman = new UIWindowVoidsman(this, 616, 46);
    this.add.existing(wndVoidsman);
    wndVoidsman.scaleX = 1;
    wndVoidsman.scaleY = 1;
    wndVoidsman.visible = false;

    // wndRecruit
    const wndRecruit = new UIWindowVoidsmanRecruit(this, 750, 70);
    this.add.existing(wndRecruit);
    wndRecruit.visible = false;

    // wndRoster
    const wndRoster = new UIWindowVoidsmanRoster(this, 90, 86);
    this.add.existing(wndRoster);

    // uIPanelSceneLinks
    const uIPanelSceneLinks = new UIPanelSceneLinks(this, 423, 0);
    this.add.existing(uIPanelSceneLinks);

    this.wndVoidsman = wndVoidsman;
    this.wndRecruit = wndRecruit;
    this.wndRoster = wndRoster;

    this.events.emit("scene-awake");
  }

  private wndVoidsman!: UIWindowVoidsman;
  private wndRecruit!: UIWindowVoidsmanRecruit;
  private wndRoster!: UIWindowVoidsmanRoster;

  /* START-USER-CODE */
  // Write your code here

  create() {

    this.editorCreate();
    this.wndRoster.btnRecruit.onClick = () => {

      if(Game.IsActive()){
        console.log("*** GAME IS ACTIVE");
      }
      else {
        console.log("*** GAME IS INACTIVE");
      }


      //this.wndRoster.btnRecruit.setEnabled(false);
      //this.wndRecruit.wipe();
      //this.wndRecruit.setVisible(true);
      //this.wndVoidsman.setVisible(false);
    };

    this.wndRecruit.btnCancel.onClick = () => {
      this.wndRoster.btnRecruit.setEnabled(true);
      this.wndRecruit.setVisible(false);
      this.wndVoidsman.setVisible(false);
    };

    this.wndRecruit.btnRecruit.onClick = () => {
      this.wndRecruit.execute(() => {
        //this.wndSpinner.setVisible(false);
        //wndRoster.reload();
      });
      this.wndRoster.btnRecruit.setEnabled(true);
      this.wndRecruit.setVisible(false);
      this.wndVoidsman.setVisible(false);
      //this.wndSpinner.setVisible(true);
    };
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
