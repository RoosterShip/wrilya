// You can write more code here
import Phaser from "phaser";
import Button from "phaser3-rex-plugins/plugins/button";
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';

export default class UIButtonStandardSelected extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);
    scene.events.on('update', this.update, this);
  }

  setup(
    hitbox: Phaser.GameObjects.Rectangle,
    selected: Phaser.GameObjects.Image,
    notSelected: Phaser.GameObjects.Image,
    pressed: Phaser.GameObjects.Image,
    hover: Phaser.GameObjects.Image,
  ) {
    const rexButton: ButtonPlugin = this.scene.plugins.get('rexButton') as ButtonPlugin;
    this.button = rexButton.add(hitbox, {});
    this.selected = selected;
    this.notSelected = notSelected;
    this.pressed = pressed;
    this.hover = hover;

    this.button.on('click', () => { this.setSelected(); });
    this.button.on('over', () => { this.setIn();});
    this.button.on('out', () => { this.setOut(); });
  }

  setSelected() {
    this.selected.visible = true;
    this.notSelected.visible = false;
    this.pressed.visible = false;
    this.hover.visible = false;
    this.onSelected();
  }
  
  setUnselected() {
    this.selected.visible = true;
    this.notSelected.visible = false;
    this.pressed.visible = false;
    this.hover.visible = false;
    this.onUnselected();
  }
  
  setIn() {
    this.selected.visible = true;
    this.notSelected.visible = false;
    this.pressed.visible = false;
    this.hover.visible = false;
  }
  
  setOut() {
    this.selected.visible = true;
    this.notSelected.visible = false;
    this.pressed.visible = false;
    this.hover.visible = false;
  }


  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  update(_time: number, _delta: number) {
  }

  private selected: Phaser.GameObjects.Image;
  private notSelected: Phaser.GameObjects.Image;
  private hover: Phaser.GameObjects.Image;
  private pressed: Phaser.GameObjects.Image;
  private button: Button | null = null;

  public onSelected: () => void = () => { };
  public onUnselected: () => void = () => { };

}