// 10進数を16進数に変換する関数
function decimalToHex(decimal) {
    return decimal.toString(16);
  }
  
  // SVGパス文字列
  let svgPath = "M715,586l19,10l4,8l1,7l15,5l16-14l20-6l-2,9l-36,70l-2,41l-7,12l-17,14l-23-16l8-26L715,586z M892,377l-12-5h-24l1-49l-26-62l-33,24l-3-38l-65-59l-23,9v20l-26,24l-11-22l1-18l-21-13l-27,25l-34,2l33-20l6-42l-37-23l-36,8v27l19,7l10-17l13,26l-45,3l-45-19l-35,19l-25-13l-108,1l2,71l22,35l-47,6l-76,50l56,59l-24,26l-13,55l24,24l9,43l25,1l-1,27l11,26l-13-7l-19-16l-12,19l23,70l29,50l2,34l35,10l14,77l-6,38l52,56l22,6l29,25h82l29-35l50-28l11-51l5-49l25-57l-48,23l26-67l-18-31l18-12l27-53l4-12l10-7v-20l-32-32l-8-33l-39-5l-76,7l1,39l-14,19h-43l-13-7l4-39l-15-11l-91-1l-6,19l4,17l-28,6l8-95l59-82l53,8l15,12l44,3l25-17l44-14l67,27l13,98l12,35l12,10l18,35l26,29l33-29l20,4l25-11l-6-17v-43l51-21v-32l-14-14l22-9L892,377zM595,784l-16,40l-10,11l-10-11l1-8l4-15l-91,1l2,13l-4,15l-18-10l-41-108l73,26l74-2l61-29L595,784z M612,535l42,13l19,31l-3,40l-18,22l-35,15l-30-6l-25-18l-13-35l16-43L612,535z M487,649l8-33l1-26l6-8h22l8,10l27,56l30,20l-22,8l-24-20l-9,34l-31,7l-23-18l5-29l-29,24l-22-8l41-28L487,649z M412,536l46,18l16,39l-20,46l-43,17l-40-16l-22-47l16-40L412,536z M395,668l-24,40l17,43l-44-64l-8-82l24,37L395,668z";

  // d属性内の10進数を16進数に変換する関数
  function convertDecimalToHex(svgPath) {
    const decimalRegex = /(\d+)/g;
    return svgPath.replace(decimalRegex, (match, decimal) => {
      const hex = decimalToHex(parseInt(decimal));
      return hex;
    });
  }
  
  // 10進数を16進数に変換する関数
  function decimalToHex(decimal) {
    return decimal.toString(16);
  }
  
  // 10進数を16進数に変換したSVGパス文字列を取得
  const convertedSVGPath = convertDecimalToHex(svgPath);
  
  console.log(convertedSVGPath);
  console.log("compressed ratio is " + (convertedSVGPath.length / svgPath.length) * 100 + "%" );