function compressSVGPath(path) {
    let compressedPath = '';
  
    for (let i = 0; i < path.length; i++) {
      let length = 0;
      let offset = 0;
  
      for (let j = 0; j < i; j++) {
        let k = 0;
  
        while (path[j + k] === path[i + k]) {
          k++;
  
          if (i + k === path.length) {
            break;
          }
        }
  
        if (k > length) {
          length = k;
          offset = i - j;
        }
      }
  
      if (length > 0) {
        compressedPath += `(${offset},${length})`;
        i += length - 1;
      } else {
        compressedPath += path[i];
      }
    }
  
    const originalSize = path.length;
    const compressedSize = compressedPath.length;
    const compressionRatio = (compressedSize / originalSize) * 100;
  
    console.log('Original Size:', originalSize);
    console.log('Compressed Size:', compressedSize);
    console.log('Compression Ratio:', compressionRatio.toFixed(2), '%');
  
    return compressedPath;
  }
  
  // 使用例
  const path = 'M435,450l30-15l28-1l53-11l39-1l12,5l-36,1l-72,14L435,450z M465,455l32-2l37-2l35-8l14,1l-52,14l-32,2L465,455z M707,555c14,8,33,32,33,40l-31-15l-2-5V555z M574,771l-40,17h-33l-44-20l-31-43l44,33l50,12l51-15l39-36L574,771z M644,572l-11-5l-26-4l-25,8l-22,12l8-15l24-17h30l14,8L644,572z';
  
  const compressedPath = compressSVGPath(path);
  console.log('Compressed Path:', compressedPath);
  