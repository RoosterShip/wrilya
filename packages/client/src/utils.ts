
import Phaser from "phaser";
import { ScrollablePanel } from 'phaser3-rex-plugins/templates/ui/ui-components.js';

export function createScrollablePanel(scene: Phaser.Scene, area: Phaser.GameObjects.Rectangle, con: Phaser.GameObjects.Container) : ScrollablePanel{
  let bottom = 0;
  let right = 0;

  con.iterate((child: Phaser.GameObjects.GameObject) => {
    if( child instanceof Phaser.GameObjects.Rectangle){
      const childH = child.height + child.y;
      const childW = child.width + child.x;
      if (childH > bottom) {
          bottom = childH;
      }
      if (childW > right) {
          right = childW;
      }
    }
  });
  //set the container size
  con.setPosition(0,0);
  con.setSize(right, bottom);

  scene.add.existing(con);

  const thumb = scene.add.image(0, 0, "slider_n");
  const track = scene.add.image(0, 0, "rail");

  const scrollablePanel = new ScrollablePanel(scene, {
    x: area.x,
    y: area.y,
    width: area.width,
    height: area.height,
    originX: area.originX,
    originY: area.originY,
    scrollMode: 0,
    mouseWheelScroller: {
         focus: true,
         speed: 0.5
    },
    panel: {
      child: con,
      mask: {
        padding: 0
      },
    },
    slider: {
      track: track,
      thumb: thumb,
    },
    space: {
      left: 10,
      right: 0,
      top: 10,
      bottom: 10,
      panel: 0,
    }
  });
  scene.add.existing(scrollablePanel);
  scrollablePanel.layout();
  return scrollablePanel;
} 