
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIPanelMainSceneVerseNewsNetwork extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // sizeBox
    const sizeBox = scene.add.rectangle(0, 0, 680, 2300);
    sizeBox.setOrigin(0, 0);
    this.add(sizeBox);

    // gnn
    const gnn = scene.add.image(331, 128, "gnn");
    gnn.scaleX = 0.8;
    gnn.scaleY = 0.8;
    this.add(gnn);

    // lblStarDate5342-21
    const lblStarDate5342_21 = scene.add.text(26, 253, "", {});
    lblStarDate5342_21.text = "Star Date: 5342.21";
    lblStarDate5342_21.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    this.add(lblStarDate5342_21);

    // colonize
    const colonize = scene.add.image(323, 451, "Colonize");
    this.add(colonize);

    // text
    const text = scene.add.text(25, 610, "", {});
    text.text = "Today colonization began on the newly discovered world of Tinope.\n\nRecently discovered deposits of Apatite will allow for high crop yields of much needed soy foods in the region.\n\nAs quoted from the newly appointed magistrate \"We are aiming for 100 tons of sellable crops by the end of next year. ";
    text.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    text.setWordWrapWidth(600);
    this.add(text);

    // rep_empty_frame
    const rep_empty_frame = scene.add.image(323, 939, "rep_empty_frame");
    this.add(rep_empty_frame);

    // lblStarDate5341-13
    const lblStarDate5341_13 = scene.add.text(26, 1000, "", {});
    lblStarDate5341_13.text = "Star Date: 5342.21";
    lblStarDate5341_13.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    this.add(lblStarDate5341_13);

    // planetP
    const planetP = scene.add.image(323, 1160, "PlanetP");
    this.add(planetP);

    // text_1
    const text_1 = scene.add.text(36, 1281, "", {});
    text_1.text = "Planet P is no more!\n\nThe long awaited astroid Helana impacted with the planet destroying all life.\n\nKnowing that this impact would happen well in advance, everyone was safely evacuated months ago.  However the economic impact is wide spread as Planet P was a major source of multiple resources needed throughout the empire.";
    text_1.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    text_1.setWordWrapWidth(600);
    this.add(text_1);

    // rep_empty_frame_1
    const rep_empty_frame_1 = scene.add.image(284, 1645, "rep_empty_frame");
    this.add(rep_empty_frame_1);

    // lblStarDate
    const lblStarDate = scene.add.text(26, 1677, "", {});
    lblStarDate.text = "Star Date: 5341.74";
    lblStarDate.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    this.add(lblStarDate);

    // invision
    const invision = scene.add.image(320, 1839, "Invision");
    this.add(invision);

    // text_2
    const text_2 = scene.add.text(26, 1984, "", {});
    text_2.text = "The war on planet Netera has escalated dramatically with the annihilation of the rebel stronghold of Lophion.\n\nAs quoted by one millitary leader \"This operation will server multiple purposes";
    text_2.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    text_2.setWordWrapWidth(600);
    this.add(text_2);

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
