
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import UIButtonSideBarSelect1 from "../prefab/ui/button/UIButtonSideBarSelect1";
import UIPanelSceneLinks from "../prefab/ui/panel/UIPanelSceneLinks";
/* START-USER-IMPORTS */
import { createScrollablePanel } from "../utils";
import UIPanelMainSceneVerseNewsNetwork from "../prefab/ui/panel/UIPanelMainSceneVerseNewsNetwork";
import UIPanelMainSceneCommunityUpdate from "../prefab/ui/panel/UIPanelMainSceneCommunityUpdate";
import UIPanelMainSceneTutorial from "../prefab/ui/panel/UIPanelMainSceneTutorial";
/* END-USER-IMPORTS */

export default class Main extends Phaser.Scene {

  constructor() {
    super("Main");

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

    // large_1_box
    this.add.image(640, 381, "large_1_box");

    // mainmenu_p_1
    this.add.image(1097, 65, "mainmenu_p");

    // btnVerseNewsNetwork
    const btnVerseNewsNetwork = new UIButtonSideBarSelect1(this, 178, 174);
    this.add.existing(btnVerseNewsNetwork);
    btnVerseNewsNetwork.scaleX = 0.6;
    btnVerseNewsNetwork.scaleY = 0.5;

    // lblVerseNewNetwork
    const lblVerseNewNetwork = this.add.text(198, 184, "", {});
    lblVerseNewNetwork.text = "Galactic New Network";
    lblVerseNewNetwork.setStyle({ "fontFamily": "system-ui" });

    // btnCommunityUpdates
    const btnCommunityUpdates = new UIButtonSideBarSelect1(this, 178, 224);
    this.add.existing(btnCommunityUpdates);
    btnCommunityUpdates.scaleX = 0.6;
    btnCommunityUpdates.scaleY = 0.5;

    // lblCommunityUpdates
    const lblCommunityUpdates = this.add.text(198, 233, "", {});
    lblCommunityUpdates.text = "Community Updates";
    lblCommunityUpdates.setStyle({ "fontFamily": "system-ui" });

    // btnTutorials
    const btnTutorials = new UIButtonSideBarSelect1(this, 178, 274);
    this.add.existing(btnTutorials);
    btnTutorials.scaleX = 0.6;
    btnTutorials.scaleY = 0.5;

    // lblTutorials
    const lblTutorials = this.add.text(198, 283, "", {});
    lblTutorials.text = "Tutorial";
    lblTutorials.setStyle({ "fontFamily": "system-ui" });

    // btnFAQ
    const btnFAQ = new UIButtonSideBarSelect1(this, 178, 324);
    this.add.existing(btnFAQ);
    btnFAQ.scaleX = 0.6;
    btnFAQ.scaleY = 0.5;

    // lblFAQ
    const lblFAQ = this.add.text(198, 333, "", {});
    lblFAQ.text = "FAQ";
    lblFAQ.setStyle({ "fontFamily": "system-ui" });

    // btnEvents
    const btnEvents = new UIButtonSideBarSelect1(this, 178, 374);
    this.add.existing(btnEvents);
    btnEvents.scaleX = 0.6;
    btnEvents.scaleY = 0.5;

    // lblEvents
    const lblEvents = this.add.text(198, 383, "", {});
    lblEvents.text = "Events";
    lblEvents.setStyle({ "fontFamily": "system-ui" });

    // btnGovernance
    const btnGovernance = new UIButtonSideBarSelect1(this, 178, 424);
    this.add.existing(btnGovernance);
    btnGovernance.scaleX = 0.6;
    btnGovernance.scaleY = 0.5;

    // lblGovernance
    const lblGovernance = this.add.text(198, 433, "", {});
    lblGovernance.text = "Governance";
    lblGovernance.setStyle({ "fontFamily": "system-ui" });

    // btnGameUpdates
    const btnGameUpdates = new UIButtonSideBarSelect1(this, 178, 474);
    this.add.existing(btnGameUpdates);
    btnGameUpdates.scaleX = 0.6;
    btnGameUpdates.scaleY = 0.5;

    // lblGameUpdates
    const lblGameUpdates = this.add.text(198, 483, "", {});
    lblGameUpdates.text = "Game Updates";
    lblGameUpdates.setStyle({ "fontFamily": "system-ui" });

    // btnCredits
    const btnCredits = new UIButtonSideBarSelect1(this, 178, 524);
    this.add.existing(btnCredits);
    btnCredits.scaleX = 0.6;
    btnCredits.scaleY = 0.5;

    // lblCredits
    const lblCredits = this.add.text(198, 532, "", {});
    lblCredits.text = "Credits";
    lblCredits.setStyle({ "fontFamily": "system-ui" });

    // btnWebsite
    const btnWebsite = new UIButtonSideBarSelect1(this, 178, 574);
    this.add.existing(btnWebsite);
    btnWebsite.scaleX = 0.6;
    btnWebsite.scaleY = 0.5;

    // lblWebsite
    const lblWebsite = this.add.text(198, 583, "", {});
    lblWebsite.text = "Website";
    lblWebsite.setStyle({ "fontFamily": "system-ui" });

    // btnDiscord
    const btnDiscord = new UIButtonSideBarSelect1(this, 178, 624);
    this.add.existing(btnDiscord);
    btnDiscord.scaleX = 0.6;
    btnDiscord.scaleY = 0.5;

    // lblDiscord
    const lblDiscord = this.add.text(198, 632, "", {});
    lblDiscord.text = "Discord";
    lblDiscord.setStyle({ "fontFamily": "system-ui" });

    // panelMain
    const panelMain = this.add.rectangle(394, 163, 710, 518);
    panelMain.setOrigin(0, 0);

    // text_1
    const text_1 = this.add.text(649, 69, "", {});
    text_1.setOrigin(0.5, 0.5);
    text_1.text = "MAIN MENU";
    text_1.setStyle({ "align": "center", "color": "#b1d1e3ff", "fontFamily": "system-ui", "fontSize": "24px" });

    // text_2
    const text_2 = this.add.text(185, 121, "", {});
    text_2.text = "Market Movements:";
    text_2.setStyle({ "fontFamily": "system-ui", "fontSize": "24px" });

    // text_3
    const text_3 = this.add.text(431, 121, "", {});
    text_3.text = "GOLD +2.45";
    text_3.setStyle({ "color": "#12f419ff", "fontFamily": "system-ui", "fontSize": "24px" });

    // text
    const text = this.add.text(595, 120, "", {});
    text.text = "Soy -1.2";
    text.setStyle({ "color": "#f42a12ff", "fontFamily": "system-ui", "fontSize": "24px" });

    // text_4
    const text_4 = this.add.text(712, 120, "", {});
    text_4.text = "Dilithium  +0.2";
    text_4.setStyle({ "color": "#22f412ff", "fontFamily": "system-ui", "fontSize": "24px" });

    // text_5
    const text_5 = this.add.text(918, 121, "", {});
    text_5.text = "Latinum  -1.8";
    text_5.setStyle({ "color": "#f43512ff", "fontFamily": "system-ui", "fontSize": "24px" });

    // uIPanelSceneLinks
    const uIPanelSceneLinks = new UIPanelSceneLinks(this, 423, 0);
    this.add.existing(uIPanelSceneLinks);

    this.btnVerseNewsNetwork = btnVerseNewsNetwork;
    this.btnCommunityUpdates = btnCommunityUpdates;
    this.btnTutorials = btnTutorials;
    this.btnFAQ = btnFAQ;
    this.btnEvents = btnEvents;
    this.btnGovernance = btnGovernance;
    this.btnGameUpdates = btnGameUpdates;
    this.btnCredits = btnCredits;
    this.btnWebsite = btnWebsite;
    this.btnDiscord = btnDiscord;
    this.panelMain = panelMain;

    this.events.emit("scene-awake");
  }

  private btnVerseNewsNetwork!: UIButtonSideBarSelect1;
  private btnCommunityUpdates!: UIButtonSideBarSelect1;
  private btnTutorials!: UIButtonSideBarSelect1;
  private btnFAQ!: UIButtonSideBarSelect1;
  private btnEvents!: UIButtonSideBarSelect1;
  private btnGovernance!: UIButtonSideBarSelect1;
  private btnGameUpdates!: UIButtonSideBarSelect1;
  private btnCredits!: UIButtonSideBarSelect1;
  private btnWebsite!: UIButtonSideBarSelect1;
  private btnDiscord!: UIButtonSideBarSelect1;
  private panelMain!: Phaser.GameObjects.Rectangle;

  /* START-USER-CODE */

  // Write your code here

  create() {
    this.editorCreate();
    const gnn = new UIPanelMainSceneVerseNewsNetwork(this, 0, 0);
    this.add.existing(gnn);
    const gnnPanel = createScrollablePanel(this, this.panelMain, gnn);
    gnnPanel.visible = true;
    this.btnVerseNewsNetwork.setSelected()

    // btnVerseNewsNetwork
    this.btnVerseNewsNetwork.onSelected = () => {
      gnnPanel.visible = true;
      this.btnCommunityUpdates.setUnselected();
      this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnVerseNewsNetwork.onUnselected = () => {
      gnnPanel.visible = false;
    }

    // btnCommunityUpdates
    const cu = new UIPanelMainSceneCommunityUpdate(this, 0, 0);
    this.add.existing(cu);
    const cuPanel = createScrollablePanel(this, this.panelMain, cu);
    cuPanel.visible = false;
    this.btnCommunityUpdates.onSelected = () => {
      cuPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnCommunityUpdates.onUnselected = () => {
      cuPanel.visible = false;
    }

    // btnTutorial
    const tut = new UIPanelMainSceneTutorial(this, 0, 0);
    this.add.existing(tut);
    const tutPanel = createScrollablePanel(this, this.panelMain, tut);
    tutPanel.visible = false;
    this.btnTutorials.onSelected = () => {
      tutPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnCommunityUpdates.setUnselected();
      //this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnTutorials.onUnselected = () => {
      tutPanel.visible = false;
    }

    // btnFAQ
    const faq = new UIPanelMainSceneTutorial(this, 0, 0);
    this.add.existing(faq);
    const faqPanel = createScrollablePanel(this, this.panelMain, faq);
    faqPanel.visible = false;
    this.btnFAQ.onSelected = () => {
      faqPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnCommunityUpdates.setUnselected();
      this.btnTutorials.setUnselected();
      //this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnFAQ.onUnselected = () => {
      faqPanel.visible = false;
    }

    // btnEvents
    const evt = new UIPanelMainSceneTutorial(this, 0, 0);
    this.add.existing(evt);
    const evtPanel = createScrollablePanel(this, this.panelMain, evt);
    evtPanel.visible = false;
    this.btnEvents.onSelected = () => {
      evtPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnCommunityUpdates.setUnselected();
      this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      //this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnEvents.onUnselected = () => {
      evtPanel.visible = false;
    }

    // btnGovernance
    const gov = new UIPanelMainSceneTutorial(this, 0, 0);
    this.add.existing(gov);
    const govPanel = createScrollablePanel(this, this.panelMain, gov);
    govPanel.visible = false;
    this.btnGovernance.onSelected = () => {
      govPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnCommunityUpdates.setUnselected();
      this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      //this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnGovernance.onUnselected = () => {
      govPanel.visible = false;
    }

    // btnGameUpdates
    const gu = new UIPanelMainSceneTutorial(this, 0, 0);
    this.add.existing(gu);
    const guPanel = createScrollablePanel(this, this.panelMain, gu);
    guPanel.visible = false;
    this.btnGameUpdates.onSelected = () => {
      guPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnCommunityUpdates.setUnselected();
      this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      //this.btnGameUpdates.setUnselected();
      this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnGameUpdates.onUnselected = () => {
      guPanel.visible = false;
    }

    // btnCredits
    const credits = new UIPanelMainSceneTutorial(this, 0, 0);
    this.add.existing(credits);
    const creditsPanel = createScrollablePanel(this, this.panelMain, credits);
    creditsPanel.visible = false;
    this.btnCredits.onSelected = () => {
      creditsPanel.visible = true;
      this.btnVerseNewsNetwork.setUnselected();
      this.btnCommunityUpdates.setUnselected();
      this.btnTutorials.setUnselected();
      this.btnFAQ.setUnselected();
      this.btnEvents.setUnselected();
      this.btnGovernance.setUnselected();
      this.btnGameUpdates.setUnselected();
      //this.btnCredits.setUnselected();
      this.btnWebsite.setUnselected();
      this.btnDiscord.setUnselected();
    }
    this.btnCredits.onUnselected = () => {
      creditsPanel.visible = false;
    }

    // btnWebsite
    this.btnWebsite.onSelected = () => {
      const win = window.open("https://wrilya.com", '_blank')!;
      win.focus();
    }

    // btnDiscord
    this.btnDiscord.onSelected = () => {
      const win = window.open("https://discord.gg/v4rGcsS8", '_blank')!;
      win.focus();
    }
  }
  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
