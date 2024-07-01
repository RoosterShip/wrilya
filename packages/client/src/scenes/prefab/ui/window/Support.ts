
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import ButtonNormal from "../button/ButtonNormal";
import ButtonSmallClose from "../button/ButtonSmallClose";
import ButtonBug from "../button/ButtonBug";
import ButtonCommunityGuidelines from "../button/ButtonCommunityGuidelines";
import ButtonKey from "../button/ButtonKey";
import ButtonSecurity from "../button/ButtonSecurity";
import ButtonGuides from "../button/ButtonGuides";
import ButtonPrivacy from "../button/ButtonPrivacy";
import ButtonSuggestions from "../button/ButtonSuggestions";
import ButtonHelp from "../button/ButtonHelp";
import ButtonSupport from "../button/ButtonSupport";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Support extends Phaser.GameObjects.Container {

    constructor(scene: Phaser.Scene, x?: number, y?: number) {
        super(scene, x ?? 0, y ?? 0);

        // iconSupport
        const iconSupport = scene.add.image(4, 4, "support_box_icon");
        iconSupport.setOrigin(0, 0);
        this.add(iconSupport);

        // window
        const window = scene.add.image(0, 1, "support_box_1");
        window.setOrigin(0, 0);
        this.add(window);

        // WEBSITE
        const wEBSITE = new ButtonNormal(scene, 69, 580);
        wEBSITE.scaleX = 1;
        wEBSITE.scaleY = 1;
        this.add(wEBSITE);

        // EXIT
        const eXIT = new ButtonNormal(scene, 624, 580);
        eXIT.scaleX = 1;
        eXIT.scaleY = 1;
        this.add(eXIT);

        // buttonSmallClose
        const buttonSmallClose = new ButtonSmallClose(scene, 746, 19);
        buttonSmallClose.scaleX = 1;
        buttonSmallClose.scaleY = 1;
        this.add(buttonSmallClose);

        // buttonBug
        const buttonBug = new ButtonBug(scene, 30, 84);
        this.add(buttonBug);

        // buttonCommunityGuidelines
        const buttonCommunityGuidelines = new ButtonCommunityGuidelines(scene, 30, 137);
        this.add(buttonCommunityGuidelines);

        // buttonKey
        const buttonKey = new ButtonKey(scene, 30, 190);
        this.add(buttonKey);

        // buttonSecurity
        const buttonSecurity = new ButtonSecurity(scene, 30, 243);
        this.add(buttonSecurity);

        // buttonGuides
        const buttonGuides = new ButtonGuides(scene, 30, 296);
        this.add(buttonGuides);

        // buttonPrivacy
        const buttonPrivacy = new ButtonPrivacy(scene, 30, 349);
        this.add(buttonPrivacy);

        // buttonSuggestions
        const buttonSuggestions = new ButtonSuggestions(scene, 30, 402);
        this.add(buttonSuggestions);

        // buttonHelp
        const buttonHelp = new ButtonHelp(scene, 30, 455);
        this.add(buttonHelp);

        // buttonSupport
        const buttonSupport = new ButtonSupport(scene, 30, 509);
        this.add(buttonSupport);

        // text_1
        const text_1 = scene.add.text(218, 16, "", {});
        text_1.text = "HELP AND SUPPORT";
        text_1.setStyle({ "align": "center", "color": "#bae4fe", "fontFamily": "Eurostile Bold Extended", "fontSize": "38px", "shadow.offsetY":1,"shadow.blur":1,"shadow.fill":true});
        this.add(text_1);

        // wEBSITE (prefab fields)
        wEBSITE.label = "WEBSITE";

        // eXIT (prefab fields)
        eXIT.label = "EXIT";

        /* START-USER-CTR-CODE */
        buttonSmallClose.onClick = () => {
            console.log("X was clicked");
            this.destroy();
        };
        /* END-USER-CTR-CODE */
    }

    /* START-USER-CODE */

    // Write your code here.

    /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
