// You can write more code here
import Phaser from "phaser";
import Button from "phaser3-rex-plugins/plugins/button";
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';

export default class UIButtonCell extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);
  }

  protected setup(
    hitbox: Phaser.GameObjects.Rectangle,
    pressed: Phaser.GameObjects.Image,
    highlight: Phaser.GameObjects.Image,
  ) {
    const rexButton: ButtonPlugin = this.scene.plugins.get('rexButton') as ButtonPlugin;
    this.button = rexButton.add(hitbox, {});

    pressed.visible = false;
    highlight.visible = false;

    this.button.on('click', () => {
      pressed.visible = true;
      highlight.visible = false;
      this.onClick();
    });
    this.button.on('down', () => {
      highlight.visible = false;
      this.onDown();
    });
    this.button.on('up', () => {
      highlight.visible = false;
      this.onUp();
    });
    this.button.on('over', () => {
      highlight.visible = true;
      this.onOver();
    });
    this.button.on('out', () => {
      highlight.visible = false;
      this.onOut();
    });

    this.onDisable = () => {
      pressed.visible = false;
    };
  }


  private button: Button | null = null;

  public onDisable: () => void;
  public onOver: () => void = () => { };
  public onDown: () => void = () => { };
  public onUp: () => void = () => { };
  public onOut: () => void = () => { };
  public onClick: () => void = () => { };
}