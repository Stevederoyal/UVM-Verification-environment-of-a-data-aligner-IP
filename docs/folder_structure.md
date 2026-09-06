# Repository Folder Structure

Based on your file names, here's how to organize the project. Naming follows your
existing prefixes: `cfs_apb_*` (APB agent), `cfs_md_*` (Memory Data agent, split into
master/slave for RX/TX), `cfs_algn_*` (top-level env/model/tests), `uvm_ext_*` (reusable
base-class library), and the RTL files (`design.sv`, `cfs_*.v`).

```
data-aligner-uvm/
│
├── rtl/                                  # DUT source (Image 2 files)
│   ├── design.sv
│   ├── cfs_synch.v
│   ├── cfs_synch_fifo.v
│   ├── cfs_edge_detect.v
│   ├── cfs_ctrl.v
│   ├── cfs_rx_ctrl.v
│   ├── cfs_tx_ctrl.v
│   ├── cfs_regs.v
│   ├── cfs_aligner_core.v
│   └── cfs_aligner.v
│
├── tb/
│   ├── top/                              # Testbench top + interfaces
│   │   ├── testbench.sv
│   │   ├── cfs_algn_if.sv
│   │   ├── cfs_apb_if.sv
│   │   ├── cfs_md_if.sv
│   │   └── messages.f
│   │
│   ├── uvm_ext/                          # Reusable base-class library
│   │   ├── uvm_ext_pkg_status.sv
│   │   ├── uvm_ext_agent.sv
│   │   ├── uvm_ext_agent_config.sv
│   │   ├── uvm_ext_driver.sv
│   │   ├── uvm_ext_monitor.sv
│   │   ├── uvm_ext_sequencer.sv
│   │   ├── uvm_ext_coverage.sv
│   │   └── uvm_ext_reset_handler.sv
│   │
│   ├── agents/
│   │   ├── apb/                          # APB Agent
│   │   │   ├── cfs_apb_pkg.sv
│   │   │   ├── cfs_apb_types.sv
│   │   │   ├── cfs_apb_agent.sv
│   │   │   ├── cfs_apb_agent_config.sv
│   │   │   ├── cfs_apb_sequencer.sv
│   │   │   ├── cfs_apb_driver.sv
│   │   │   ├── cfs_apb_monitor.sv
│   │   │   ├── cfs_apb_coverage.sv
│   │   │   ├── cfs_apb_reset_handler.sv
│   │   │   ├── cfs_apb_item_base.sv
│   │   │   ├── cfs_apb_item_drv.sv
│   │   │   ├── cfs_apb_item_mon.sv
│   │   │   ├── cfs_apb_sequence_base.sv
│   │   │   ├── cfs_apb_sequence_simple.sv
│   │   │   ├── cfs_apb_sequence_rw.sv
│   │   │   └── cfs_apb_sequence_random.sv
│   │   │
│   │   └── md/                           # Memory Data Agent (RX = slave, TX = master, or vice versa — match your convention)
│   │       ├── cfs_md_pkg.sv
│   │       ├── cfs_md_types.sv
│   │       ├── cfs_md_agent.sv
│   │       ├── cfs_md_agent_master.sv
│   │       ├── cfs_md_agent_slave.sv
│   │       ├── cfs_md_agent_config.sv
│   │       ├── cfs_md_agent_config_master.sv
│   │       ├── cfs_md_agent_config_slave.sv
│   │       ├── cfs_md_reset_handler.sv
│   │       ├── cfs_md_sequencer_base.sv
│   │       ├── cfs_md_sequencer_base_master.sv
│   │       ├── cfs_md_sequencer_base_slave.sv
│   │       ├── cfs_md_sequencer_master.sv
│   │       ├── cfs_md_sequencer_slave.sv
│   │       ├── cfs_md_driver_master.sv
│   │       ├── cfs_md_driver_slave.sv
│   │       ├── cfs_md_monitor.sv
│   │       ├── cfs_md_coverage.sv
│   │       ├── cfs_md_item_base.sv
│   │       ├── cfs_md_item_drv.sv
│   │       ├── cfs_md_item_drv_master.sv
│   │       ├── cfs_md_item_drv_slave.sv
│   │       ├── cfs_md_item_mon.sv
│   │       ├── cfs_md_sequence_base.sv
│   │       ├── cfs_md_sequence_base_master.sv
│   │       ├── cfs_md_sequence_base_slave.sv
│   │       ├── cfs_md_sequence_simple_master.sv
│   │       ├── cfs_md_sequence_simple_slave.sv
│   │       ├── cfs_md_sequence_slave_response.sv
│   │       └── cfs_md_sequence_slave_response_forever.sv
│   │
│   ├── env/                              # Top-level environment
│   │   ├── cfs_algn_pkg.sv
│   │   ├── cfs_algn_types.sv
│   │   ├── cfs_algn_env.sv
│   │   ├── cfs_algn_env_config.sv
│   │   ├── cfs_algn_virtual_sequencer.sv
│   │   ├── cfs_algn_scoreboard.sv
│   │   ├── cfs_algn_coverage.sv
│   │   ├── cfs_algn_model.sv
│   │   ├── cfs_algn_predictor.sv
│   │   ├── cfs_apb_reg_adapter.sv
│   │   ├── cfs_algn_reg_access_status_info.sv
│   │   ├── cfs_algn_seq_reg_config.sv
│   │   ├── cfs_algn_clr_cnt_drop.sv
│   │   └── cfs_algn_split_info.sv
│   │
│   ├── reg_model/                        # Register model (built from RAL/reg_block)
│   │   ├── cfs_algn_reg_pkg.sv
│   │   ├── cfs_algn_reg_block.sv
│   │   ├── cfs_algn_reg_ctrl.sv
│   │   ├── cfs_algn_reg_status.sv
│   │   ├── cfs_algn_reg_irqen.sv
│   │   └── cfs_algn_reg_irq.sv
│   │
│   ├── virtual_seq/                      # Virtual sequences (drive multiple agents)
│   │   ├── cfs_algn_virtual_sequence_base.sv
│   │   ├── cfs_algn_virtual_sequence_slow_pace.sv
│   │   ├── cfs_algn_virtual_sequence_rx.sv
│   │   ├── cfs_algn_virtual_sequence_rx_err.sv
│   │   ├── cfs_algn_virtual_sequence_tx.sv
│   │   ├── cfs_algn_virtual_sequence_reg_config.sv
│   │   ├── cfs_algn_virtual_sequence_reg_status.sv
│   │   ├── cfs_algn_virtual_sequence_reg_access_random.sv
│   │   └── cfs_algn_virtual_sequence_reg_access_unmapped.sv
│   │
│   └── tests/                            # UVM test classes
│       ├── cfs_algn_test_pkg.sv
│       ├── cfs_algn_test_defines.sv
│       ├── cfs_algn_test_base.sv
│       ├── cfs_algn_test_reg_access.sv
│       └── cfs_algn_test_random.sv
│
├── docs/
│   └── architecture.png
│
└── README.md
```

## Notes

- **`uvm_ext/`** holds your reusable base classes (agent, driver, monitor, sequencer,
  coverage, reset handler) — these look like a small internal UVM extension library
  shared across both the APB and MD agents, so they get their own folder rather than
  living inside either agent.
- **MD agent master/slave split**: your file names suggest the Memory Data agent
  supports both a master and slave role (used for RX and TX respectively, likely via
  agent configuration rather than two separate agent classes) — kept together in one
  `md/` folder since they share the same package and base classes.
- **`reg_model/`** is separated from `env/` since register model files (block, individual
  registers) are typically auto-generated or maintained separately from hand-written env
  code — but merge it into `env/` if you'd rather keep things flatter.
- Rename `data-aligner-uvm/` at the top to whatever your actual repo name is.

## How to apply this (if restructuring an existing repo)

```bash
mkdir -p rtl tb/top tb/uvm_ext tb/agents/apb tb/agents/md tb/env tb/reg_model tb/virtual_seq tb/tests docs

git mv design.sv rtl/
git mv cfs_apb_pkg.sv cfs_apb_agent.sv tb/agents/apb/
# ...repeat git mv for each file/group above

git commit -m "Reorganize project into rtl/tb folder structure"
```

Using `git mv` instead of a plain move preserves file history in GitHub.
