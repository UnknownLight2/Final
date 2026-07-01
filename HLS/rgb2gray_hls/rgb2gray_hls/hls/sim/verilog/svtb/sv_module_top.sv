//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef SV_MODULE_TOP_SV
`define SV_MODULE_TOP_SV


`timescale 1ns/1ps


`include "uvm_macros.svh"
import uvm_pkg::*;
import file_agent_pkg::*;
import rgb2gray_subsystem_pkg::*;
`include "rgb2gray_subsys_test_sequence_lib.sv"
`include "rgb2gray_test_lib.sv"


module sv_module_top;


    misc_interface              misc_if ( .clock(apatb_rgb2gray_top.AESL_clock), .reset(apatb_rgb2gray_top.AESL_reset) );
    assign misc_if.dut2tb_ap_ready = apatb_rgb2gray_top.AESL_inst_rgb2gray.ap_ready;
    assign misc_if.dut2tb_ap_done_kernel = apatb_rgb2gray_top.AESL_inst_rgb2gray.ap_done;
    initial begin
        uvm_config_db #(virtual misc_interface)::set(null, "uvm_test_top.top_env.*", "misc_if", misc_if);
    end


    axi_if #(64,4,8,3,1)  axi_gmem_if (.clk  (apatb_rgb2gray_top.AESL_clock), .rst(apatb_rgb2gray_top.AESL_reset));
    assign axi_gmem_if.AWVALID = apatb_rgb2gray_top.gmem_AWVALID;
    assign apatb_rgb2gray_top.gmem_AWREADY = axi_gmem_if.AWREADY;
    assign axi_gmem_if.AWADDR = apatb_rgb2gray_top.gmem_AWADDR;
    assign axi_gmem_if.AWID = apatb_rgb2gray_top.gmem_AWID;
    assign axi_gmem_if.AWLEN = apatb_rgb2gray_top.gmem_AWLEN;
    assign axi_gmem_if.AWSIZE = apatb_rgb2gray_top.gmem_AWSIZE;
    assign axi_gmem_if.AWBURST = apatb_rgb2gray_top.gmem_AWBURST;
    assign axi_gmem_if.AWLOCK = apatb_rgb2gray_top.gmem_AWLOCK;
    assign axi_gmem_if.AWCACHE = apatb_rgb2gray_top.gmem_AWCACHE;
    assign axi_gmem_if.AWPROT = apatb_rgb2gray_top.gmem_AWPROT;
    assign axi_gmem_if.AWQOS = apatb_rgb2gray_top.gmem_AWQOS;
    assign axi_gmem_if.AWREGION = apatb_rgb2gray_top.gmem_AWREGION;
    assign axi_gmem_if.AWUSER = apatb_rgb2gray_top.gmem_AWUSER;
    assign axi_gmem_if.WVALID = apatb_rgb2gray_top.gmem_WVALID;
    assign apatb_rgb2gray_top.gmem_WREADY = axi_gmem_if.WREADY;
    assign axi_gmem_if.WDATA = apatb_rgb2gray_top.gmem_WDATA;
    assign axi_gmem_if.WSTRB = apatb_rgb2gray_top.gmem_WSTRB;
    assign axi_gmem_if.WLAST = apatb_rgb2gray_top.gmem_WLAST;
    assign axi_gmem_if.WID = apatb_rgb2gray_top.gmem_WID;
    assign axi_gmem_if.WUSER = apatb_rgb2gray_top.gmem_WUSER;
    assign axi_gmem_if.ARVALID = apatb_rgb2gray_top.gmem_ARVALID;
    assign apatb_rgb2gray_top.gmem_ARREADY = axi_gmem_if.ARREADY;
    assign axi_gmem_if.ARADDR = apatb_rgb2gray_top.gmem_ARADDR;
    assign axi_gmem_if.ARID = apatb_rgb2gray_top.gmem_ARID;
    assign axi_gmem_if.ARLEN = apatb_rgb2gray_top.gmem_ARLEN;
    assign axi_gmem_if.ARSIZE = apatb_rgb2gray_top.gmem_ARSIZE;
    assign axi_gmem_if.ARBURST = apatb_rgb2gray_top.gmem_ARBURST;
    assign axi_gmem_if.ARLOCK = apatb_rgb2gray_top.gmem_ARLOCK;
    assign axi_gmem_if.ARCACHE = apatb_rgb2gray_top.gmem_ARCACHE;
    assign axi_gmem_if.ARPROT = apatb_rgb2gray_top.gmem_ARPROT;
    assign axi_gmem_if.ARQOS = apatb_rgb2gray_top.gmem_ARQOS;
    assign axi_gmem_if.ARREGION = apatb_rgb2gray_top.gmem_ARREGION;
    assign axi_gmem_if.ARUSER = apatb_rgb2gray_top.gmem_ARUSER;
    assign apatb_rgb2gray_top.gmem_RVALID = axi_gmem_if.RVALID;
    assign axi_gmem_if.RREADY = apatb_rgb2gray_top.gmem_RREADY;
    assign apatb_rgb2gray_top.gmem_RDATA = axi_gmem_if.RDATA;
    assign apatb_rgb2gray_top.gmem_RLAST = axi_gmem_if.RLAST;
    assign apatb_rgb2gray_top.gmem_RID = axi_gmem_if.RID;
    assign apatb_rgb2gray_top.gmem_RUSER = axi_gmem_if.RUSER;
    assign apatb_rgb2gray_top.gmem_RRESP = axi_gmem_if.RRESP;
    assign apatb_rgb2gray_top.gmem_BVALID = axi_gmem_if.BVALID;
    assign axi_gmem_if.BREADY = apatb_rgb2gray_top.gmem_BREADY;
    assign apatb_rgb2gray_top.gmem_BRESP = axi_gmem_if.BRESP;
    assign apatb_rgb2gray_top.gmem_BID = axi_gmem_if.BID;
    assign apatb_rgb2gray_top.gmem_BUSER = axi_gmem_if.BUSER;
    initial begin
        uvm_config_db #( virtual axi_if#(64,4,8,3,1) )::set(null, "uvm_test_top.top_env.axi_master_gmem.*", "vif", axi_gmem_if);
    end


    axi_if #(6,4,4,3,1)  axi_control_if (.clk  (apatb_rgb2gray_top.AESL_clock), .rst(apatb_rgb2gray_top.AESL_reset));
    assign apatb_rgb2gray_top.control_AWADDR = axi_control_if.AWADDR;
    assign apatb_rgb2gray_top.control_AWVALID = axi_control_if.AWVALID;
    assign axi_control_if.AWREADY = apatb_rgb2gray_top.control_AWREADY;
    assign apatb_rgb2gray_top.control_WVALID = axi_control_if.WVALID;
    assign axi_control_if.WREADY = apatb_rgb2gray_top.control_WREADY;
    assign apatb_rgb2gray_top.control_WDATA = axi_control_if.WDATA;
    assign apatb_rgb2gray_top.control_WSTRB = axi_control_if.WSTRB;
    assign apatb_rgb2gray_top.control_ARADDR = axi_control_if.ARADDR;
    assign apatb_rgb2gray_top.control_ARVALID = axi_control_if.ARVALID;
    assign axi_control_if.ARREADY = apatb_rgb2gray_top.control_ARREADY;
    assign axi_control_if.RVALID = apatb_rgb2gray_top.control_RVALID;
    assign apatb_rgb2gray_top.control_RREADY = axi_control_if.RREADY;
    assign axi_control_if.RDATA = apatb_rgb2gray_top.control_RDATA;
    assign axi_control_if.RRESP = apatb_rgb2gray_top.control_RRESP;
    assign axi_control_if.BVALID = apatb_rgb2gray_top.control_BVALID;
    assign apatb_rgb2gray_top.control_BREADY = axi_control_if.BREADY;
    assign axi_control_if.BRESP = apatb_rgb2gray_top.control_BRESP;
    assign axi_control_if.BID = 0;
    assign axi_control_if.RID = 0;
    assign axi_control_if.RLAST = 1;
    initial begin
        uvm_config_db #( virtual axi_if#(6,4,4,3,1) )::set(null, "uvm_test_top.top_env.axi_lite_control.*", "vif", axi_control_if);
    end


    initial begin
        run_test();
    end
endmodule
`endif
