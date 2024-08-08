
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import PreloadBarUpdaterScript from "../script-nodes/PreloadBarUpdaterScript";

/* START-USER-IMPORTS */
import Game from "../game";
import Service from "../service";
/* END-USER-IMPORTS */

export default class Preload extends Phaser.Scene {

  constructor() {
    super("Preload");

    /* START-USER-CTR-CODE */
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  editorCreate(): void {

    // progressBar
    const progressBar = this.add.rectangle(553.0120849609375, 361, 256, 20);
    progressBar.setOrigin(0, 0);
    progressBar.isFilled = true;
    progressBar.fillColor = 14737632;

    // preloadUpdater
    new PreloadBarUpdaterScript(progressBar);

    // progressBarBg
    const progressBarBg = this.add.rectangle(553.0120849609375, 361, 256, 20);
    progressBarBg.setOrigin(0, 0);
    progressBarBg.fillColor = 14737632;
    progressBarBg.isStroked = true;

    // loadingText
    const loadingText = this.add.text(552.0120849609375, 329, "", {});
    loadingText.text = "Loading...";
    loadingText.setStyle({ "color": "#e0e0e0", "fontFamily": "arial", "fontSize": "20px" });

    this.events.emit("scene-awake");
  }

  /* START-USER-CODE */
  preload() {
    this.editorCreate();
    this.load.pack("default", "assets/asset-pack.json");
    this.load.pack("portraits", "assets/game/portraits/asset-pack.json");
    this.load.pack("portraits-thumbnail", "assets/game/portraits/thumbnails/asset-pack.json");
  }
  create() {
    Game.MUDAddLiveShot(() => {
      this.mudReady();
    });
    this.input.setDefaultCursor('url(assets/ui/cursors/cursor_normal.png), pointer');
  }
  mudReady() {
    if(Game.IsActive()){
      Service.SessionInitialize(
        // Success Callback
        (data) => {
          Game.SetSessionData(data);
          this.scene.start("Main");
        },
        // Failure Callback
        (status, msg) => {
          if(status == 403){
            this.scene.start("Login");
          }
          else{
            console.log(msg);
            this.scene.start("Error");
          }
        }
      )
    }
    else {
      console.log("Game is Currently Disabled");
      this.scene.start("Error");
    }
  }
  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
