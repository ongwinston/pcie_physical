/*
 * Some common register declarations
*/

package register_pkg;

  typedef enum logic [3:0] {
    ACTIVE_DATA_RATE_2_5_GT,
    ACTIVE_DATA_RATE_5_0_GT,
    ACTIVE_DATA_RATE_8_0_GT,
    ACTIVE_DATA_RATE_16_0_GT,
    ACTIVE_DATA_RATE_32_0_GT
  } active_data_rate_e;

/*
 * EncodingSymbolName
 * Description
 * K28.5 COMCommaUsed for Lane and Link initialization and management
 * K27.7 STPStart TLPMarks the start of a Transaction Layer Packet
 * K28.2 SDPStart DLLPMarks the start of a Data Link Layer Packet
 * K29.7 ENDEndK30.7EDBEnD BadK23.7PADPadUsed in Framing and Link Width and Lane ordering negotiations
 * K28.0 SKPSkipUsed for compensating for different bit rates for two communicating Ports
 * K28.1 FTSFast Training
 * Sequence
 * K28.3 IDLIdle
 * Marks the end of a Transaction Layer Packet or a Data Link Layer Packet
 * Marks the end of a nullified TLP
 * Used within an Ordered Set to exit from L0s to L0
 * Used in the Electrical Idle Ordered Set (EIOS)
 * K28.4 Reserved
 * K28.6 Reserved
 * Reserved in 2.5 GT/s
 * K28.7
 * EIE
 * Electrical Idle Exit
 * Used in the Electrical Idle Exit Ordered Sets
 */
  typedef enum logic [7:0] {
    K28_5 = 8'hBC, // COMMA
    K27_7 = 8'hFB, // Start TLP
    K28_2 = 8'h5C, // Start DLLP
    K29_7 = 8'hFD, // END
    K30_7 = 8'hFE, // EnD Bad
    K23_7 = 8'hF7, // PAD
    K28_0 = 8'h1C, // Skip
    K28_1 = 8'h3C, // Tast Training Sequence
    K28_3 = 8'h7C, // Idle
    K28_4 = 8'h9C, // Reserved
    K28_6 = 8'hDC, // Reserved
    K28_7 = 8'hFC // Electrical Idle Exit
  } k_symbols_e;

endpackage
