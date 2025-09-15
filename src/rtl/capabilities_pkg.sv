package capabilities_pkg;


  /*
   * id[7:0]
   * nxt_capability_ptr [15:8]
   */
  typedef struct packed {
    logic [7:0] nxt_capability_ptr; // The field contains the offset to the next PCI Capability Structure
    logic [7:0] id; // Indicates the PCIe Capability Structure - RO
  } pci_capability_list_t;


  /*
   * [3:0] capability version
   * [7:4] device port type
   *       - 0000b - PCI Express endpoint
   *       - 0001b - Legacy PCI Express endpoint
   *       - 1001b - RCiEP
   *       - 1010b - Root Complex Event Collector
   *       - 0100b - Root Port of PCI Express Root Complex
   *       - 0101b - Upstream Port of PCI Express Switch
   *       - 0110b - Downstream Port of PCI Express Switch
   *       - 0111b - PCI Express to PCI/PCI-X Bridge
   *       - 1000b - PCI/PCI-X to PCI Express Bridge
   * [8] Slot Implemented
   * [13:9] Interrupt Message Number
   * [14] Undefined
   */
  typedef struct packed {
    logic        undefined;
    logic [4:0]  interrupt_message_num;
    logic        slot_implemented;
    logic [3:0]  device_port_type;
    logic [3:0]  version;
  } pcie_capabilities_reg_t;


  /*
   * [2:0] max_payload_support
   *      - 000b - 128 Bytes max payload size
   *      - 001b - 256 bytes
   *      - 010b - 512 bytes
   *      - 011b - 1024 bytes
   *      - 100b - 2048 bytes
   *      - 101b - 4096 bytes
   *      - 110b - Reserved
   *      - 111b - Reserved
   * [4:3] Phantom Functions Suported
   *      - 00b
   *      - 01b
   *      - 10b
   *      - 11b
   * [5] Extended Tag Field Supported
   * [8:6] Endpoint L0S Acceptable Latency
   *      - 000b - 64ns
   *      - 001b - 128ns
   *      - 010b - 256ns
   *      - 011b - 512ns
   *      - 100b - 1us
   *      - 101b - 2us
   *      - 110b - 4us
   *      - 111b - No Limit
   * [11:9] EndPoint L1 Acceptable Latency
   *      - 000b - Maximum of 1us
   *      - 001b - 2us
   *      - 010b - 4us
   *      - 011b - 8us
   *      - 100b - 16us
   *      - 101b - 32us
   *      - 110b - 64us
   *      - 111b - No Limit
   * [14:12] Undefined
   * [15] Role Based error Reporting
   * [16] ERR_COR subclass capable
   * [25:18] Captured Slot power limit value
   * [27:26] Captured slot power limit scale
   * [28] Function level reset capability
   */
  typedef struct packed {
    logic function_lvl_rst;
    logic [1:0] captured_slot_power_limit_scale;
    logic [7:0] captured_slot_pwr_limit_val;
    logic err_cor_subclass_capable;
    logic role_based_error_reporting;
    logic [2:0] undefined;
    logic [2:0] endpoint_la_acceptable_latency;
    logic [2:0] endpoint_l0s_acceptable_latency;
    logic extended_tag_field_supported;
    logic [1:0] phantom_functions_supported;
    logic [2:0] max_payload_size_supported;
  } device_capability_reg_t;



  /* Link Capabilities 2 Register (Offset 2Ch) */
  /*
   * bit 0 - reserved
   * bit [7:1] - Supported link speeds
   *       - bit 0 - 2.5 GT/s
   *       - bit 1 - 5.0 GT/s
   *       - bit 2 - 8.0 GT/s
   *       - bit 3 - 16.0 GT/s
   *       - bit 4 - 32.0 GT/s
   * bit [8] - Crosslink Supported
   * bits [15:9] Lower SKP OS Generation Supported speeds vector
   * bits [22:16] lower SKP OS Reception Supported Speeds Vector
   * bit [23] - Retimer Presence Detect Supported
   * bit [24] Two Retimers Presence Detect Supported
   * bit [31] DRS Supported
   */
  typedef struct packed {
    logic drs_supported;
    logic [5:0] reserved2;
    logic two_retimers_presence_detected_supported;
    logic retimer_presence_detected_supported;
    logic [1:0] lower_skp_os_reception_supported_speed_vec_rsvd;
    logic lower_skp_os_reception_supported_speed_32_0_gt;
    logic lower_skp_os_reception_supported_speed_16_0_gt;
    logic lower_skp_os_reception_supported_speed_8_0_gt;
    logic lower_skp_os_reception_supported_speed_5_0_gt;
    logic lower_skp_os_reception_supported_speed_2_5_gt;
    logic [1:0] lower_skp_os_gen_supported_speed_vec_rsvd;
    logic lower_skp_os_gen_supported_speed_32_0_gt;
    logic lower_skp_os_gen_supported_speed_16_0_gt;
    logic lower_skp_os_gen_supported_speed_8_0_gt;
    logic lower_skp_os_gen_supported_speed_5_0_gt;
    logic lower_skp_os_gen_supported_speed_2_5_gt;
    logic crosslink_supported;
    logic [1:0] supported_link_speeds_vec_rsvd;
    logic supported_link_speed_32_0_gt;
    logic supported_link_speed_16_0_gt;
    logic supported_link_speed_8_0_gt;
    logic supported_link_speed_5_0_gt;
    logic supported_link_speed_2_5_gt;
    logic reserved;
  } link_capabilities_2_reg_t;

endpackage
