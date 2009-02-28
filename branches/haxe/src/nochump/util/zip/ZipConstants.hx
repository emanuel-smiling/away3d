package nochump.util.zip;



internal class ZipConstants  {
	
	/* The local file header */
	// "PK\003\004"
	public static inline var LOCSIG:Int = 0x04034b50;
	// LOC header size
	public static inline var LOCHDR:Int = 30;
	// version needed to extract
	public static inline var LOCVER:Int = 4;
	//internal static const LOCFLG:uint = 6; // general purpose bit flag
	//internal static const LOCHOW:uint = 8; // compression method
	//internal static const LOCTIM:uint = 10; // modification time
	//internal static const LOCCRC:uint = 14; // uncompressed file crc-32 value
	//internal static const LOCSIZ:uint = 18; // compressed size
	//internal static const LOCLEN:uint = 22; // uncompressed size
	// filename length
	public static inline var LOCNAM:Int = 26;
	//internal static const LOCEXT:uint = 28; // extra field length
	/* The Data descriptor */
	// "PK\007\008"
	public static inline var EXTSIG:Int = 0x08074b50;
	// EXT header size
	public static inline var EXTHDR:Int = 16;
	//internal static const EXTCRC:uint = 4; // uncompressed file crc-32 value
	//internal static const EXTSIZ:uint = 8; // compressed size
	//internal static const EXTLEN:uint = 12; // uncompressed size
	/* The central directory file header */
	// "PK\001\002"
	public static inline var CENSIG:Int = 0x02014b50;
	// CEN header size
	public static inline var CENHDR:Int = 46;
	//internal static const CENVEM:uint = 4; // version made by
	// version needed to extract
	public static inline var CENVER:Int = 6;
	//internal static const CENFLG:uint = 8; // encrypt, decrypt flags
	//internal static const CENHOW:uint = 10; // compression method
	//internal static const CENTIM:uint = 12; // modification time
	//internal static const CENCRC:uint = 16; // uncompressed file crc-32 value
	//internal static const CENSIZ:uint = 20; // compressed size
	//internal static const CENLEN:uint = 24; // uncompressed size
	// filename length
	public static inline var CENNAM:Int = 28;
	//internal static const CENEXT:uint = 30; // extra field length
	//internal static const CENCOM:uint = 32; // comment length
	//internal static const CENDSK:uint = 34; // disk number start
	//internal static const CENATT:uint = 36; // internal file attributes
	//internal static const CENATX:uint = 38; // external file attributes
	// LOC header offset
	public static inline var CENOFF:Int = 42;
	/* The entries in the end of central directory */
	// "PK\005\006"
	public static inline var ENDSIG:Int = 0x06054b50;
	// END header size
	public static inline var ENDHDR:Int = 22;
	//internal static const ENDSUB:uint = 8; // number of entries on this disk
	// total number of entries
	public static inline var ENDTOT:Int = 10;
	//internal static const ENDSIZ:uint = 12; // central directory size in bytes
	// offset of first CEN header
	public static inline var ENDOFF:Int = 16;
	//internal static const ENDCOM:uint = 20; // zip file comment length
	/* Compression methods */
	public static inline var STORED:Int = 0;
	public static inline var DEFLATED:Int = 8;
	

	

	// autogenerated
	public function new () {
		
	}

	

}

