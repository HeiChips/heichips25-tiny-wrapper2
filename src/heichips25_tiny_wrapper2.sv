// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`default_nettype none

module heichips25_tiny_wrapper2 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [7:0] uo_out_fsm;
    wire [7:0] uio_out_fsm;
    wire [7:0] uio_oe_fsm;

    (* keep_hierarchy *)
    heichips25_can_lehmann_fsm heichips25_can_lehmann_fsm (
        .ui_in    (ui_in),
        .uo_out   (uo_out_fsm),
        .uio_in   (uio_in),
        .uio_out  (uio_out_fsm),
        .uio_oe   (uio_oe_fsm),
        .ena      (1'b1),
        .clk      (clk),
        .rst_n    (rst_n && !ena)
    );

    wire [7:0] uo_out_sap3;
    wire [7:0] uio_out_sap3;
    wire [7:0] uio_oe_sap3;

    (* keep_hierarchy *)
    heichips25_sap3 heichips25_sap3 (
        .ui_in    (ui_in),
        .uo_out   (uo_out_sap3),
        .uio_in   (uio_in),
        .uio_out  (uio_out_sap3),
        .uio_oe   (uio_oe_sap3),
        .ena      (1'b1),
        .clk      (clk),
        .rst_n    (rst_n && ena)
    );

    assign uo_out = ena ? uo_out_sap3 : uo_out_fsm;
    assign uio_out = ena ? uio_out_sap3 : uio_out_fsm;
    assign uio_oe = ena ? uio_oe_sap3 : uio_oe_fsm;

endmodule
