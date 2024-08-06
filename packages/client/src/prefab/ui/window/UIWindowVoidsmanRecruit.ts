
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIButtonLast from "../button/UIButtonLast";
import UIButtonNext from "../button/UIButtonNext";
import UIButtonNormal from "../button/UIButtonNormal";
/* START-USER-IMPORTS */
import { HomeSystemEnum } from "../../../constants";
import portraitAssetPack from "../../../../public/assets/game/portraits/asset-pack.json";
import {AxiosResponse, AxiosError } from 'axios'
import axios from 'axios'
/* END-USER-IMPORTS */

export default class UIWindowVoidsmanRecruit extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // character_select_box_merge2
    const character_select_box_merge2 = scene.add.image(0, 0, "character_select_box_merge2");
    character_select_box_merge2.setOrigin(0, 0);
    this.add(character_select_box_merge2);

    // imgPortrait
    const imgPortrait = scene.add.image(193, 266, "h_f_001");
    imgPortrait.scaleX = 0.2;
    imgPortrait.scaleY = 0.2;
    this.add(imgPortrait);

    // glowFx
    imgPortrait.preFX!.addGlow(11127517, 0, 1, false);

    // inputName
    const inputName = scene.add.image(193, 90, "input_text_black_2");
    this.add(inputName);

    // btnLastPortrait
    const btnLastPortrait = new UIButtonLast(scene, 50, 250);
    btnLastPortrait.scaleX = 1;
    btnLastPortrait.scaleY = 1;
    this.add(btnLastPortrait);

    // btnNextPortrait
    const btnNextPortrait = new UIButtonNext(scene, 310, 250);
    btnNextPortrait.scaleX = 1;
    btnNextPortrait.scaleY = 1;
    this.add(btnNextPortrait);

    // btnRecruit
    const btnRecruit = new UIButtonNormal(scene, 236, 540);
    this.add(btnRecruit);

    // btnCancel
    const btnCancel = new UIButtonNormal(scene, 50, 540);
    this.add(btnCancel);

    // lblName
    const lblName = scene.add.text(193, 49, "", {});
    lblName.setOrigin(0.5, 0.5);
    lblName.text = "NAME";
    lblName.setStyle({ "align": "center", "fontSize": "24px" });
    this.add(lblName);

    // lblPortrait
    const lblPortrait = scene.add.text(193, 134, "", {});
    lblPortrait.setOrigin(0.5, 0.5);
    lblPortrait.text = "PORTRAIT";
    lblPortrait.setStyle({ "align": "center", "fontSize": "24px" });
    this.add(lblPortrait);

    // lblHomeWorld
    const lblHomeWorld = scene.add.text(193, 410, "", {});
    lblHomeWorld.setOrigin(0.5, 0.5);
    lblHomeWorld.text = "HOME SYSTEM";
    lblHomeWorld.setStyle({ "align": "center", "fontSize": "24px" });
    this.add(lblHomeWorld);

    // lblHomeWorldValue
    const lblHomeWorldValue = scene.add.text(192, 461, "", {});
    lblHomeWorldValue.setOrigin(0.5, 0.5);
    lblHomeWorldValue.text = "HOME SYSTEM NAME";
    lblHomeWorldValue.setStyle({ "align": "center", "fontSize": "24px" });
    this.add(lblHomeWorldValue);

    // btnNextSystem
    const btnNextSystem = new UIButtonNext(scene, 310, 448);
    btnNextSystem.scaleX = 1;
    btnNextSystem.scaleY = 1;
    this.add(btnNextSystem);

    // btnLastHomeSystem
    const btnLastHomeSystem = new UIButtonLast(scene, 50, 448);
    btnLastHomeSystem.scaleX = 1;
    btnLastHomeSystem.scaleY = 1;
    this.add(btnLastHomeSystem);

    // btnRecruit (prefab fields)
    btnRecruit.text = "RECRUIT";

    // btnCancel (prefab fields)
    btnCancel.text = "CANCEL";

    this.imgPortrait = imgPortrait;
    this.btnRecruit = btnRecruit;
    this.btnCancel = btnCancel;
    this.lblHomeWorldValue = lblHomeWorldValue;

    /* START-USER-CTR-CODE */
    btnNextPortrait.onClick = () => {
      let next: number =  this.portraitIndex + 1;
      if(next >= portraitAssetPack.section1.files.length){
        next = 0;
      }
      this.portraitIndex = next;
      this.imgPortrait.setTexture(portraitAssetPack.section1.files[next].key);
    }

    btnLastPortrait.onClick = () => {
      let last: number =  this.portraitIndex - 1;
      if(last <= 0){
        last = portraitAssetPack.section1.files.length - 1;
      }
      this.portraitIndex = last;
      this.imgPortrait.setTexture(portraitAssetPack.section1.files[last].key);
    }

    lblHomeWorldValue.text = HomeSystemEnum[this.homeSystemIndex];

    btnNextSystem.onClick = () => {
      let next: number =  this.homeSystemIndex + 1;
      if(next >= HomeSystemEnum.__LENGTH){
        next = 1;
      }
      this.homeSystemIndex = next;
      this.lblHomeWorldValue.text = HomeSystemEnum[next];
    }

    btnLastHomeSystem.onClick = () => {
      let last: number =  this.homeSystemIndex - 1;
      if(last <= 1){
        last = HomeSystemEnum.__LENGTH - 1;
      }
      this.homeSystemIndex = last;
      this.lblHomeWorldValue.text = HomeSystemEnum[last];
    }
    /* END-USER-CTR-CODE */
  }

  private imgPortrait: Phaser.GameObjects.Image;
  public btnRecruit: UIButtonNormal;
  public btnCancel: UIButtonNormal;
  private lblHomeWorldValue: Phaser.GameObjects.Text;

  /* START-USER-CODE */

  // Write your code here.
  private portraitIndex: number = 0;
  private homeSystemIndex: number = 1;

  public wipe() {
    this.homeSystemIndex = 1
    this.lblHomeWorldValue.text = HomeSystemEnum[1];
    this.portraitIndex = 0;
    this.imgPortrait.setTexture(portraitAssetPack.section1.files[0].key);
  }

  public execute(callback: () => void) {
    axios({
      method: 'post',
      url: __SERVER__ + '/api/session/voidsman/premint',
      withCredentials: true,
      data: {
        name: "Major Lee Burbank",
        portrait: portraitAssetPack.section1.files[this.portraitIndex].key,
        home: this.homeSystemIndex
      }
    })
    .then((response: AxiosResponse) => {
      console.log(JSON.stringify(response.data, null, 2));
    })
    .catch((error: AxiosError) => {
        console.log(error.message);
    })
    .finally(() => {
      callback();
    });
  }

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
