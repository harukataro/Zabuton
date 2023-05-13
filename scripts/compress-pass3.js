let svgPath = "M0,0h1080v1080H0V0z";

let compressPath = (path) => {
  let compressedPath = "";
  let parts = path.split(",");
  for (let part of parts) {
    let command = part.charAt(0);
    let params = part.substring(1);
    if (command === "M") compressedPath += "a";
    else if (command === "L") compressedPath += "b";
    else if (command === "H") compressedPath += "c";
    else if (command === "V") compressedPath += "d";
    else if (command === "l") compressedPath += "e";
    else if (command === "h") compressedPath += "f";
    else if (command === "v") compressedPath += "g";
    else if (command === "z" || command === "Z") compressedPath += "h";
    else if (command === "C") compressedPath += "i";
    else if (command === "S") compressedPath += "j";
    else if (command === "Q") compressedPath += "k";
    else if (command === "T") compressedPath += "l";
    else if (command === "A") compressedPath += "m";
    compressedPath += params;
  }
  return compressedPath;
};

let convertTo56Base = (number) => {
  const base = 56;
  let digits = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let result = "";
  while (number > 0) {
    let remainder = number % base;
    result = digits.charAt(remainder) + result;
    number = Math.floor(number / base);
  }
  return result;
};

let compressSVGPath = (path) => {
  let compressedPath = compressPath(path);
  let compressedNumbers = [];
  for (let i = 0; i < compressedPath.length; i += 2) {
    let number = parseInt(compressedPath.substr(i, 2), 23);
    compressedNumbers.push(number);
  }
  let compressedPath56 = "";
  for (let number of compressedNumbers) {
    let convertedNumber = convertTo56Base(number);
    compressedPath56 += convertedNumber;
  }
  return compressedPath56;
};

let decompressPath = (compressedPath) => {
  let digits = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let decompressedPath = "";
  let currentNumber = "";
  for (let char of compressedPath) {
    if (digits.includes(char)) {
      currentNumber += char;
    } else {
      let number = parseInt(currentNumber, 56);
      let decompressedChar = "";
      if (char === "a") decompressedChar = "M";
      else if (char === "b") decompressedChar = "L";
      else if (char === "c") decompressedChar = "H";
      else if (char === "d") decompressedChar = "V";
      else if (char === "e") decompressedChar = "l";
      else if (char === "f") decompressedChar = "h";
      else if (char === "g") decompressedChar = "v";
      else if (char === "h") decompressedChar = "Z";
      else if (char === "i") decompressedChar = "C";
      else if (char === "j") decompressedChar = "S";
      else if (char === "k") decompressedChar = "Q";
      else if (char === "l") decompressedChar ="T";
      else if (char === "m") decompressedChar = "A";
      decompressedPath += decompressedChar + number.toString(23);
      currentNumber = "";
    }
  }
  return decompressedPath;
};

let compressedPath56 = compressSVGPath(svgPath);
let decompressedPath = decompressPath(compressedPath56);

console.log("Original Path:", svgPath);
console.log("Compressed Path:", compressedPath56);
console.log("Decompressed Path:", decompressedPath);

console.log("Original Size:", svgPath.length);
console.log("Compressed Size:", compressedPath56.length);
console.log("Compression Ratio:", ((compressedPath56.length / svgPath.length) * 100).toFixed(2) + "%");

