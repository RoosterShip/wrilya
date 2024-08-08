
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIPanelMainSceneCommunityUpdate extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // sizebox
    const sizebox = scene.add.rectangle(0, 0, 680, 1000);
    sizebox.setOrigin(0, 0);
    this.add(sizebox);

    // text_1
    const text_1 = scene.add.text(26, 16, "", {});
    text_1.text = "Community Updates!";
    text_1.setStyle({ "fontFamily": "system-ui", "fontSize": "32px" });
    this.add(text_1);

    // text_2
    const text_2 = scene.add.text(26, 104, "", {});
    text_2.text = "Community engagement is an important component of a thriving game. Weekly updates provide information about planned work and opportunities to provide feedback and get involved. \n\nThe Community Update newsletter includes information about upcoming events and game improvements, collaborations with partner and community organizations, goverance meetings, openings on boards and commissions, and many other items of interest.\n\n\n8/7/2024 - Live Stream with Devs\n\nOur first live stream with the devs is planned to for 8/24/2024 at 7pm EST, 4pm PST.  Please come and chat with us.\n\n\n7/30/2024 - User Created Content\n\nWe got a new plan or UCC and we want to hear what you think.  Come see a live demo of this new feature and see how you can engage for both fun and profit!\n\n\n";
    text_2.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });
    text_2.setWordWrapWidth(650, true);
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
