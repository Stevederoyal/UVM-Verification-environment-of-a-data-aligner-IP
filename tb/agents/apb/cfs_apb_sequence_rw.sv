`ifndef CFS_ABP_SEQUENCE_RW_SV
  `define CFS_ABP_SEQUENCE_RW_SV

class cfs_apb_sequence_rw extends cfs_apb_sequence_base;
  `uvm_object_utils(cfs_apb_sequence_rw)
 
  rand cfs_apb_addr addr;
  rand cfs_apb_data wr_data;
  
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  virtual task body();
    cfs_apb_item_drv item;
    
    //Performing read
    `uvm_do_with(item, {
      dir == CFS_APB_READ;
      addr == local::addr;
    })
    
    //Performing write
    `uvm_do_with(item, {
      dir == CFS_APB_WRITE;
      addr == local::addr;
      data == local::wr_data;
    })
    
  endtask
  
endclass


`endif

