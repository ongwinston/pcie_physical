/*

*/
package ltssm_pkg;
  typedef enum logic [3:0] {
    DETECT,
    POLLING,
    CONFIGURATION,
    RECOVERY,
    L0,
    L0S,
    L1,
    L2,
    DISABLED,
    LOOPBACK

  } ltssm_e;

  typedef enum logic [3:0] {
    POLLING_ACTIVE,
    POLLING_COMPLIANCE,
    POLLING_CONFIGURATION,
    POLLING_SPEED
  } polling_sm_e;

  typedef enum logic [3:0] {
    DETECT_QUIET,
    DETECT_ACTIVE
  } detect_sm_e;

  typedef enum logic [3:0] {
    CONFIG_LINKWIDTH_START,
    CONFIG_LINKWIDTH_ACCEPT,
    CONFIG_LANENUM_ACCEPT,
    CONFIG_LANENUM_WAIT,
    CONFIG_COMPLETE,
    CONFIG_IDLE
  } config_sm_e;

  typedef enum logic [3:0] {
    RECOVERY_RCVR_LOCK,
    RECOVERY_EQUALIZATION,
    RECOVERY_SPEED,
    RECOVERY_RCVCCFG,
    RECOVERY_IDLE
  } recovery_sm_e;

  typedef enum logic [3:0] {
    L0_ENTRY,
    L0_IDLE,
    L0_FTS
  } l0s_sm_e;

  typedef enum logic [3:0] {
    L1_ENTRY,
    L1_IDLE
  } l1_sm_e;

  typedef enum logic [3:0] {
    L2_IDLE,
    L2_TRANSMITWAKE
  } l2_sm_e;

  typedef enum logic [3:0] {
    LOOPBACK_ENTRY,
    LOOPBACK_ACTIVE,
    LOOPBACK_EXIT
  } loopback_sm_e;

  typedef enum logic [7:0] {
    K28_5 = 8'h1C, // COMMA
    K27_7 = 8'h3C, // Start TLP
    K28_2 = 8'h5C, // Start DLLP
    K29_7 = 8'h7C, // END
    K30_7 = 8'h9C, // EnD Bad
    K23_7 = 8'hBC, // PAD
    K28_0 = 8'hDC, // Skip
    K28_1 = 8'hFC, // Tast Training Sequence
    K28_3 = 8'hF7, // Idle
    K28_4 = 8'hFB, // Reserved
    K28_6 = 8'hFD, // Reserved
    K28_7 = 8'hFE // Electrical Idle Exit
  } k_symbols_e;

endpackage

