`ifndef CFS_MD_AGENT_CONFIG_SV
  `define CFS_MD_AGENT_CONFIG_SV

class cfs_md_agent_config#(int unsigned DATA_WIDTH = 32) extends uvm_ext_agent_config#(.VIRTUAL_INTF(virtual cfs_md_if#(DATA_WIDTH)));
  
  typedef virtual cfs_md_if#(DATA_WIDTH) cfs_md_vif;
    
  //Number of clock cycles after which an MD transfer is considered
  //stuck and an error is triggered
  local int unsigned stuck_threshold;
  
  //Delay used when detecting the start of an MD transaction in the monitor
  local time sample_delay_start_tr;
  
  
  `uvm_component_param_utils(cfs_md_agent_config#(DATA_WIDTH))
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    
    stuck_threshold = 1000;
    sample_delay_start_tr = 1ns;
  endfunction
  
  
  //Setter for MD virtual interface
  virtual function void set_vif(cfs_md_vif value);
    super.set_vif(value);
    set_has_checks(get_has_checks());
  endfunction
      
  //Setter to enable/disable MD protocol checks
  virtual function void set_has_checks(bit value);
    super.set_has_checks(value);
    
    if(vif != null)begin
      vif.has_checks = has_checks;
    end
  endfunction
  
  //Setter to set number of clock cycles after which a MD transfer is considered
  //stuck and an error is triggered
  virtual function void set_stuck_threshold(int unsigned value);
    stuck_threshold = value;
  endfunction
  
  //Getter to return number of clock cycles after which a MD transfer is considered
  //stuck and an error is triggered
  virtual function int unsigned get_stuck_threshold();
    return stuck_threshold;
  endfunction
  
  //Getter for the sample_delay_start_tr
  virtual function time get_sample_delay_start_tr();
    return sample_delay_start_tr;
  endfunction
  
  //Setter for the sample_delay_start_tr
  virtual function void set_sample_delay_start_tr(time value);
    sample_delay_start_tr = value;
  endfunction
   
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(vif.has_checks);
    
      if(vif.has_checks != get_has_checks())begin
        `uvm_error("ALGORITHM ISSUE", $sformatf("Cannot change \"has_checks\" from MD interface directly - use %0s.set_has_checks()", get_full_name()));
      end
    end
  endtask
  
  
  //Task for waiting the reset to start
  virtual task wait_reset_start();
    if(vif.reset_n !== 0) begin
      @(negedge vif.reset_n);
    end
  endtask
  
  //Task for waiting the reset to end
  virtual task wait_reset_end();
    while(vif.reset_n == 0) begin
      @(posedge vif.clk);
    end
  endtask
    
endclass


`endif