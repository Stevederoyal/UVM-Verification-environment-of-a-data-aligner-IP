`ifndef UVM_EXT_AGENT_SV
  `define UVM_EXT_AGENT_SV

class uvm_ext_agent#(type VIRTUAL_INTF = int, type ITEM_MON = uvm_sequence_item, type ITEM_DRV = uvm_sequence_item) extends uvm_component implements uvm_ext_reset_handler;
  
  //Agent configuration handler
  uvm_ext_agent_config#(VIRTUAL_INTF) agent_config;
  
  //Sequencer handler
  uvm_ext_sequencer#(ITEM_DRV) sequencer;
  
  //Driver handler
  uvm_ext_driver#(VIRTUAL_INTF, ITEM_DRV) driver;
  
  //Monitor handler
  uvm_ext_monitor#(VIRTUAL_INTF, ITEM_MON) monitor;
  
  //Coverage handler 
  uvm_ext_coverage#(VIRTUAL_INTF, ITEM_MON) coverage;
  
  `uvm_component_param_utils(uvm_ext_agent#(VIRTUAL_INTF, ITEM_MON, ITEM_DRV))
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(uvm_ext_agent_config#(VIRTUAL_INTF))::get(this, "", "agent_config", agent_config)) begin
      agent_config = uvm_ext_agent_config#(VIRTUAL_INTF)::type_id::create("agent_config", this);
    end
      
    monitor = uvm_ext_monitor#(VIRTUAL_INTF, ITEM_MON)::type_id::create("monitor", this);
    
    //agent_config.set_has_coverage(0);
    
    if(agent_config.get_has_coverage())begin
      coverage = uvm_ext_coverage#(VIRTUAL_INTF, ITEM_MON)::type_id::create("coverage", this);
    end
    
    if(agent_config.get_active_passive() == UVM_ACTIVE) begin
      sequencer = uvm_ext_sequencer#(ITEM_DRV)::type_id::create("sequencer", this);
      driver = uvm_ext_driver#(VIRTUAL_INTF, ITEM_DRV)::type_id::create("driver", this);
    end
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    VIRTUAL_INTF vif;
    
    super.connect_phase(phase);
    
    if(uvm_config_db#(VIRTUAL_INTF)::get(this, "","vif", vif) == 0)begin
      `uvm_fatal("UVM_EXT_NO_VIF", "Could not get from the database the virtual interface")
    end
    else begin 
      agent_config.set_vif(vif);
    end
    
    //Connecting monitor output port to coverage input port
    if(agent_config.get_has_coverage())begin
      coverage.agent_config = agent_config;
      
      monitor.output_port.connect(coverage.port_item);
    end
    
    //Pointer for monitor agent config
    monitor.agent_config = agent_config;
    
    //Connecting sequencer and driver componnet, and pointer to access virtual interface
    if(agent_config.get_active_passive() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);  
      
      //Pointer for driver agent config
      driver.agent_config = agent_config;
    end
  endfunction
  
  //Function to handle the reset
  virtual function void handle_reset(uvm_phase phase);
    uvm_component children[$];
    
    get_children(children);
    
    foreach(children[idx]) begin
      uvm_ext_reset_handler reset_handler;
      
      if($cast(reset_handler, children[idx])) begin
        reset_handler.handle_reset(phase);
      end
    end
  endfunction
  
  
  //Task for waiting the reset to start
  virtual task wait_reset_start();
    agent_config.wait_reset_start();
  endtask
  
  //Task for waiting the reset to end
  virtual task wait_reset_end();
    agent_config.wait_reset_end();
  endtask
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      wait_reset_start();
      handle_reset(phase);
      wait_reset_end();
    end
  endtask
  
  
endclass



`endif