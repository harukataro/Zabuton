/* eslint-disable no-undef */
const { expect } = require("chai");
var fs = require("fs");

describe("ZabutonImage", function () {
    let za;
  
    beforeEach(async function () {
      //ZabutonImage
      const ZabutonImage = await ethers.getContractFactory("ZabutonImage");
      za = await ZabutonImage.deploy();
    });
  
    describe("Deployment", function () {
      
      it("Should return Image ", async function () {
        for(let i = 0; i <= 10; i++){
          const image = await za.getImage(i);
          const filename = "tmp/za" + (i) + ".svg";
          fs.writeFileSync(filename, image);
      }});
    
      it("Should Update svgHeader ", async function () {
        const newSvgHeader = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>';
        await za.setSvgHeader(newSvgHeader);
        const svgHeader = await za.getSvgHeader();
        expect(svgHeader).to.equal(newSvgHeader);
      });

      it("Should Update zabuton svgBlock ", async function () {
        const newZabuton = '<defs><g id="a"><path d="m646 589-87></g></defs>';
        await za.setZabuton(newZabuton);
        const zabuton = await za.getZabuton();
        expect(zabuton).to.equal(newZabuton);
      });

      it("Should Update frame svgBlock ", async function () {
        const newFrame = '<path fill="#40FF5C" d="M57 58h5v10h5v9h4V49h5v47H66v-9h-4V77"/>';
        await za.setFrame(newFrame);
        const frame = await za.getFrame();
        expect(frame).to.equal(newFrame);
      });

      it("Change color with svgHeader ", async function () {
        const newSvgHeader = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1080 1080" style="background-color: yellow;">';
        await za.setSvgHeader(newSvgHeader);
        const image = await za.getImage(5);
        const filename = "tmp/yellowBack.svg";
        fs.writeFileSync(filename, image);
      });

    });

  });