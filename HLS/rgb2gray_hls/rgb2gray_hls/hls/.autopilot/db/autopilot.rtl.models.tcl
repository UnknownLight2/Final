set SynModuleInfo {
  {SRCNAME rgb2gray MODELNAME rgb2gray RTLNAME rgb2gray IS_TOP 1
    SUBMODULES {
      {MODELNAME rgb2gray_mul_8ns_9ns_16_1_1 RTLNAME rgb2gray_mul_8ns_9ns_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME rgb2gray_mac_muladd_8ns_7ns_16s_16_4_1 RTLNAME rgb2gray_mac_muladd_8ns_7ns_16s_16_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME rgb2gray_mac_muladd_8ns_5ns_16s_16_4_1 RTLNAME rgb2gray_mac_muladd_8ns_5ns_16s_16_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME rgb2gray_gmem_m_axi RTLNAME rgb2gray_gmem_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME rgb2gray_control_s_axi RTLNAME rgb2gray_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME rgb2gray_flow_control_loop_pipe RTLNAME rgb2gray_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME rgb2gray_flow_control_loop_pipe_U}
    }
  }
}
