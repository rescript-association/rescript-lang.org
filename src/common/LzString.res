// Used for compressing / decompressing code for url sharing

@module("lz-string")
external compressToEncodedURIComponent: string => string = "compressToEncodedURIComponent"

@module("lz-string")
external decompressToEncodedURIComponent: string => string = "decompressFromEncodedURIComponent"
