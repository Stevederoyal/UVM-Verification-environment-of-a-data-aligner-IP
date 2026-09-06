`ifndef CFS_APB_DRIVER_SV
  `define CFS_APB_DRIVER_SV

class cfs_apb_driver extends uvm_ext_driver#(.VIRTUAL_INTF(cfs_apb_vif), .ITEM_DRV(cfs_apb_item_drv));
  
  //Pointer to agent configuration
  cfs_apb_agent_config agent_config;
    
  `uvm_component_utils(cfs_apb_driver)
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    
    if($cast(agent_config, super.agent_config) == 0) begin
      `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Could not cast %0s to %0s", super.agent_config.get_type_name(), cfs_apb_agent_config::type_id::type_name))
    end
    
  endfunction
  
  //Task which drive one single item on the bus
  protected virtual task drive_transaction(cfs_apb_item_drv item);
    cfs_apb_vif vif = agent_config.get_vif();
    
    `uvm_info("ITEM_START", $sformatf("Driving \"%0s\": %s", item.get_full_name(),item.convert2string()), UVM_LOW)
    
    //Predrive delay
    for (int i = 0; i<item.pre_drive_delay; i++)begin
      @(posedge vif.pclk);
    end
    
    //Drive the pins
    vif.psel <= 1;;
    vif.paddr <= item.addr;
    vif.pwrite <= bit'(item.dir);
    
    if(item.dir == CFS_APB_WRITE) begin
      vif.pwdata <= item.data;
    end
    
    
    //Wait for 1 clk cycle
    @(posedge vif.pclk);
    
    //Enable pin
    vif.penable <= 1;
    
    //Wait for 1 clk cycle
    @(posedge vif.pclk);
    
    //Wait till pready gets high
    while(vif.pready !== 1)begin
      @(posedge vif.pclk);
    end
  	
    //Set pins back to default value
    vif.psel <= 0;
    vif.penable <= 0;
    vif.pwrite <= 0;
    vif.paddr <= 0;
    vif.pwdata <= 0;
    
    //Postdrive delay
    for (int i = 0; i<item.post_drive_delay; i++)begin
      @(posedge vif.pclk);
    end
  endtask
        
  
  
  
  //Function to handle the reset
  virtual function void handle_reset(uvm_phase phase);
    cfs_apb_vif vif = agent_config.get_vif();
    
    super.handle_reset(phase);
    
    //Initialize the signals
    vif.psel <= 0;
    vif.penable <= 0;
    vif.pwrite <= 0;
    vif.paddr <= 0;
    vif.pwdata <= 0;
  endfunction

endclass


`endif