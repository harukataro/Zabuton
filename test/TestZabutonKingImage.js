/* eslint-disable no-undef */
const { expect } = require("chai");
var fs = require("fs");

describe("ZabutonKingImage", function () {
    let za;
  
    beforeEach(async function () {
      //ZabutonKingImage
      const ZabutonImage = await ethers.getContractFactory("ZabutonKingImage");
      za = await ZabutonImage.deploy();
    });
  
    describe("Deployment", function () {
      
      it("Should return Image ", async function () {
        for(let i = 0; i < 5 ; i++){
          const image = await za.getImage(i);
          const filename = "tmp/king" + (i) + ".svg";
          fs.writeFileSync(filename, image);
      }});
    });

  });