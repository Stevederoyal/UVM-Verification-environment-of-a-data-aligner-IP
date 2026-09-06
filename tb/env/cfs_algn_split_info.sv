`ifndef CFS_ALGN_SPLIT_INFO_SV
  `define CFS_ALGN_SPLIT_INFO_SV

class cfs_algn_split_info extends uvm_object;
  
  //Value of CTRL.OFFSET
  int unsigned ctrl_offset;
  
  //Value of CTRL.SIZE
  int unsigned ctrl_size;
  
  //Value of MD transaction offset
  int unsigned md_offset;
  
  //Value of MD transaction size
  int unsigned md_size;
  
  //Number of bytes needed during the split
  int unsigned num_bytes_needed;
  
  
  `uvm_object_utils(cfs_algn_split_info)
  
  function new(string name = "");
    super.new(name);
  endfunction
  
endclass

`endif