//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
//Tool Version Limit: 2025.11
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef RGB2GRAY_ENV__SV                                                                                   
    `define RGB2GRAY_ENV__SV                                                                               
                                                                                                                    
                                                                                                                    
    class rgb2gray_env extends uvm_env;                                                                          
                                                                                                                    
        rgb2gray_virtual_sequencer rgb2gray_virtual_sqr;                                                      
        rgb2gray_config rgb2gray_cfg;                                                                         
                                                                                                                    
        axi_pkg::axi_env#(64,4,8,3,1) axi_master_gmem;
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_control;
                                                                                                                    
        rgb2gray_reference_model   refm;                                                                         
                                                                                                                    
        rgb2gray_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(rgb2gray_env)                                                                 
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (rgb2gray_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (rgb2gray_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "rgb2gray_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void rgb2gray_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        rgb2gray_cfg = rgb2gray_config::type_id::create("rgb2gray_cfg", this);                           
                                                                                                                    

        rgb2gray_cfg.gmem_cfg.set_default();
        rgb2gray_cfg.gmem_cfg.drv_type = axi_pkg::SLAVE;
        rgb2gray_cfg.gmem_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        rgb2gray_cfg.gmem_cfg.write_latency_mode = TRANSACTION_FIRST;
        rgb2gray_cfg.gmem_cfg.read_latency_mode = TRANSACTION_FIRST;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_master_gmem*", "cfg", rgb2gray_cfg.gmem_cfg);
        axi_master_gmem = axi_pkg::axi_env#(64,4,8,3,1)::type_id::create("axi_master_gmem", this);

        rgb2gray_cfg.control_cfg.set_default();
        rgb2gray_cfg.control_cfg.drv_type = axi_pkg::MASTER;
        rgb2gray_cfg.control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_control*", "cfg", rgb2gray_cfg.control_cfg);
        axi_lite_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_control", this);



        refm = rgb2gray_reference_model::type_id::create("refm", this);


        uvm_config_db#(rgb2gray_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = rgb2gray_subsystem_monitor::type_id::create("subsys_mon", this);


        rgb2gray_virtual_sqr = rgb2gray_virtual_sequencer::type_id::create("rgb2gray_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void rgb2gray_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        if(rgb2gray_cfg.gmem_cfg.drv_type==axi_pkg::MASTER ||rgb2gray_cfg.gmem_cfg.drv_type==axi_pkg::SLAVE)
            rgb2gray_virtual_sqr.gmem_sqr = axi_master_gmem.vsqr;
        axi_master_gmem.item_wtr_port.connect(subsys_mon.gmem_wtr_imp);
        axi_master_gmem.item_rtr_port.connect(subsys_mon.gmem_rtr_imp);
        uvm_callbacks#(axi_pkg::axi_state, axi_pkg::axi_state_cbs)::add(axi_master_gmem.state, refm.axi_memaccess_cb_gmem);
        if(rgb2gray_cfg.control_cfg.drv_type==axi_pkg::MASTER ||rgb2gray_cfg.control_cfg.drv_type==axi_pkg::SLAVE)
            rgb2gray_virtual_sqr.control_sqr = axi_lite_control.vsqr;
        axi_lite_control.item_wtr_port.connect(subsys_mon.control_wtr_imp);
        axi_lite_control.item_rtr_port.connect(subsys_mon.control_rtr_imp);
        refm.rgb2gray_cfg = rgb2gray_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task rgb2gray_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "rgb2gray_env is running", UVM_LOW)
    endtask


`endif
