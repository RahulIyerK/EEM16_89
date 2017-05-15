`timescale 1ns / 1ps

module sw_led(
    // Slide switch inputs
    input [15:0]sw,
    // Led outputs
    output [15:0]led
    );
    
    // Assign each sw to it's respective led
    assign led = sw;
endmodule
