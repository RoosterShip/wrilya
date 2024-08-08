
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIPanelMainSceneTutorial extends Phaser.GameObjects.Container {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // sizeBox
    const sizeBox = scene.add.rectangle(0, 0, 680, 1000);
    sizeBox.setOrigin(0, 0);
    this.add(sizeBox);

    // text_1
    const text_1 = scene.add.text(26, 0, "", {});
    text_1.text = "Tutorials";
    text_1.setStyle({ "fontFamily": "system-ui", "fontSize": "32px" });
    this.add(text_1);

    // text_2
    const text_2 = scene.add.text(26, 100, "", {});
    text_2.text = "Python is an easy to learn, powerful programming language. It has efficient high-level data structures and a simple but effective approach to object-oriented programming. Python’s elegant syntax and dynamic typing, together with its interpreted nature, make it an ideal language for scripting and rapid application development in many areas on most platforms.\n\nThe Python interpreter and the extensive standard library are freely available in source or binary form for all major platforms from the Python web site, https://www.python.org/, and may be freely distributed. The same site also contains distributions of and pointers to many free third party Python modules, programs and tools, and additional documentation.\n\nThe Python interpreter is easily extended with new functions and data types implemented in C or C++ (or other languages callable from C). Python is also suitable as an extension language for customizable applications.\n\nThis tutorial introduces the reader informally to the basic concepts and features of the Python language and system. It helps to have a Python interpreter handy for hands-on experience, but all examples are self-contained, so the tutorial can be read off-line as well.";
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
