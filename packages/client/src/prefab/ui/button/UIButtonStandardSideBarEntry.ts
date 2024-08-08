// You can write more code here
import Phaser from "phaser";
import Button from "phaser3-rex-plugins/plugins/button";
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';

export default class UIButtonStandardSideBarEntry extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);
  }

  setup(
    hitbox: Phaser.GameObjects.Rectangle,
    selected: Phaser.GameObjects.Image,
    hover: Phaser.GameObjects.Image,
  ) {
    const rexButton: ButtonPlugin = this.scene.plugins.get('rexButton') as ButtonPlugin;
    this.button = rexButton.add(hitbox, {});
    this.selected = selected;
    this.hover = hover;

    this.button.on('click', () => { this.setSelected(); });
    this.button.on('over', () => { this.setIn();});
    this.button.on('out', () => { this.setOut(); });
  }

  setSelected() {
    this.selected.visible = true;
    this.hover.visible = false;
    this.onSelected();
  }
  
  setUnselected() {
    this.selected.visible = false;
    this.hover.visible = false;
    this.onUnselected();
  }
  
  setIn() {
    if(!this.selected.visible){
      this.hover.visible = true;
    }
  }
  
  setOut() {
    if(!this.selected.visible){
      this.hover.visible = false;
    }
  }

  private selected: Phaser.GameObjects.Image;
  private hover: Phaser.GameObjects.Image;
  private button: Button | null = null;

  public onSelected: () => void = () => { };
  public onUnselected: () => void = () => { };

}