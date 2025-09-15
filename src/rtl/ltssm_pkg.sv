/*
 LTSSM or Link Training and Status State Machine

 Definitions for all of the state and substate blocks of the LTSSM
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


endpackage

