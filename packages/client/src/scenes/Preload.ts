
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import PreloadBarUpdaterScript from "../script-nodes/PreloadBarUpdaterScript";
import {AxiosResponse, AxiosError } from 'axios'
import axios from 'axios'

/* START-USER-IMPORTS */
import Game from "../game";
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
    this.waitForMud(10);
    this.input.setDefaultCursor('url(assets/ui/cursors/cursor_normal.png), pointer');
  }

  waitForMud(count: number) {
    if(count > 0){
      setTimeout(() => {
        if(undefined == Game.GetGameConfig()){
          this.waitForMud(count - 1);
        }
        else {
          this.mudReady();
        }
      }, 100);
    }
    else{
      console.log("Failed to connect to Chain/MUD Indexder");
      this.scene.start("Error");
    }
  }

  mudReady() {
    if(Game.IsActive()){
      axios({
      method: 'get',
      url: __SERVER__ + '/api/session/info',
      withCredentials: true,
      })
      .then((response: AxiosResponse) => {
        Game.SetSessionData(response.data);
        this.scene.start("Main");
      })
      .catch((error: AxiosError) => {
        if(error.response?.status == 403){
          this.scene.start("Login");
        }
        else{
          console.log(error.message);
          this.scene.start("Error");
        }
      })
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
