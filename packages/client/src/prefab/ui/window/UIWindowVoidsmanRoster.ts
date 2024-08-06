
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIButtonWide from "../button/UIButtonWide";
/* START-USER-IMPORTS */
import UICellVoidsman from "../cell/UICellVoidsman";
import { ScrollablePanel } from 'phaser3-rex-plugins/templates/ui/ui-components.js';
import { Sizer } from 'phaser3-rex-plugins/templates/ui/ui-components.js';
import {AxiosResponse, AxiosError } from 'axios'
import axios from 'axios'
/* END-USER-IMPORTS */

export default class UIWindowVoidsmanRoster extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // cosmetics_box_merge2
    const cosmetics_box_merge2 = scene.add.image(0, 0, "cosmetics_box_merge2");
    cosmetics_box_merge2.setOrigin(0, 0);
    this.add(cosmetics_box_merge2);

    // select_box_bottom_texture
    const select_box_bottom_texture = scene.add.image(193, 518, "select_box_bottom_texture");
    this.add(select_box_bottom_texture);

    // btnRecruit
    const btnRecruit = new UIButtonWide(scene, 113, 504);
    this.add(btnRecruit);

    // text_1
    const text_1 = scene.add.text(193, 26, "", {});
    text_1.setOrigin(0.5, 0.5);
    text_1.text = "CREW MANIFEST";
    text_1.setStyle({ "color": "#b1d1e3ff", "fontFamily": "system-ui", "fontSize": "24px" });
    this.add(text_1);

    // btnRecruit (prefab fields)
    btnRecruit.lblText = "RECRUIT";

    this.btnRecruit = btnRecruit;

    /* START-USER-CTR-CODE */
    axios({
     method: 'get',
     url: __SERVER__ + '/api/session/voidsman/manifest',
     withCredentials: true,
    })
    .then((response: AxiosResponse) => {
      console.log(JSON.stringify(response.data, null, 2));
      /// TODO:
      /// This is not attaching to the scene correctly so these values
      /// are tuned specifically for the Voidsman recruitment scene.
      ///
      /// More time is needed to figure out the RexUI way of handling
      /// this because I can seem to get them to attach to the container
      /// `this.add(panel)` but it breaks the masking and other junk.
      /// I have also tried adding all the items, etc but there is
      /// some magic combo I am just not getting yet.
      const panel = new ScrollablePanel(scene, {
        x: -165,
        y: 140,
        originX: 0,
        originY: 0,
        width: 600,
        height: 430,
        scrollMode: 0,
        panel: {
          child: this.createPanel(scene, response.data),
          mask: {
            padding: 1 
          }
        },
        //slider: {
        //  track: this.rexUI.add.roundRectangle(0, 0, 20, 10, 10, COLOR_DARK),
        //  thumb: this.rexUI.add.roundRectangle(0, 0, 0, 0, 13, COLOR_LIGHT),
        //},
        mouseWheelScroller: {
          focus: false,
          speed: 0.1
        },
        space: {
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,

          panel: 0,
          // slider: { left: 30, right: 30 },
        }

      }).layout();
      scene.add.existing(panel);
    })
    .catch((error: AxiosError) => {
        console.log(error.message);
    });

    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  public btnRecruit: UIButtonWide;

  /* START-USER-CODE */

  private createPanel(scene: Phaser.Scene, data: [{name: string, portrait: string, level: string}]): Sizer {
    const sizer = new Sizer(scene, {
      orientation: 'y',
      space: { item: 82}
    });
    scene.add.existing(sizer);
    data.forEach((voidsman: {name: string, portrait: string, level: string}) =>{
      sizer.add(
        this.createCell(scene, voidsman),
        {expand: true}
      );
    });
    if(data.length > 5){
      sizer.add(
        this.createCell(scene, data[0]),
        {expand: true}
      );
    }
    sizer.layout();
    return sizer;
  }

  private createCell(scene: Phaser.Scene, data: {name: string, portrait: string, level: string}): Phaser.GameObjects.GameObject {
    const cell = new UICellVoidsman(scene, 0, 0);
    cell.setDepth(1000);
    cell.level = data.level;
    cell.thumbnail = data.portrait + "_t";
    cell.assignment = "NONE";
    cell.name = data.name;
    cell.onClick = () => {
      if(this.showing == cell){
        this.showing?.onDisable();
        this.showing = undefined;
      }
      else
      {
        this.showing?.onDisable();
        this.showing = cell;
      }
    }
    scene.add.existing(cell);
    return cell;
  }
  // Write your code here.

  private showing?: UICellVoidsman;

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
