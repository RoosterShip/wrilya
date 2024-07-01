// You can write more code here
import Phaser from "phaser";
import Button from "phaser3-rex-plugins/plugins/button";
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';

export default class ButtonStd extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);
  }

  setup(
    hitbox: Phaser.GameObjects.Rectangle,
    normal: Phaser.GameObjects.Image,
    pressed: Phaser.GameObjects.Image,
    highlight: Phaser.GameObjects.Image,
    disabled: Phaser.GameObjects.Image
  ) {
    const rexButton: ButtonPlugin = this.scene.plugins.get('rexButton') as ButtonPlugin;
    this.button = rexButton.add(hitbox, {});

    this.button.on('click', () => {
      normal.visible = true;
      pressed.visible = false;
      highlight.visible = false;
      disabled.visible = false;
      this.onClick();
    });
    this.button.on('down', () => {
      normal.visible = false;
      pressed.visible = true;
      highlight.visible = false;
      disabled.visible = false;
      this.onDown();
    });
    this.button.on('up', () => {
      normal.visible = true;
      pressed.visible = false;
      highlight.visible = false;
      disabled.visible = false;
      this.onUp();
    });
    this.button.on('over', () => {
      normal.visible = false;
      pressed.visible = false;
      highlight.visible = true;
      disabled.visible = false;
      this.onOver();
    });
    this.button.on('out', () => {
      normal.visible = true;
      pressed.visible = false;
      highlight.visible = false;
      disabled.visible = false;
      this.onOut();
    });
    this.button.on('enable', () => {
      normal.visible = true;
      pressed.visible = false;
      highlight.visible = false;
      disabled.visible = false;
    });
    this.button.on('disable', () => {
      normal.visible = false;
      pressed.visible = false;
      highlight.visible = false;
      disabled.visible = true;
    });
  }

  setEnabled(value: boolean) {
    this.button!.setEnable(value);
  }
  private button: Button | null = null;

  public onOver: () => void = () => { };
  public onDown: () => void = () => { };
  public onUp: () => void = () => { };
  public onOut: () => void = () => { };
  public onClick: () => void = () => { };

}
