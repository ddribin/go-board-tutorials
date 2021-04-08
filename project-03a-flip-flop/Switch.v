module Switch(
    input i_Clk,
    input i_Switch,
    output o_LED);

    reg r_LED     = 1'b0;
    reg r_Switch  = 1'b0;

    // Purpose: Toggle LED output when i_Switch is released
    always @(posedge i_Clk)
    begin
        r_Switch <= i_Switch; // Creates a register

        // This conditional expression looks for a falling edge on i_Switch.
        // Here, the current value (i_Swtich) is low, but the previous value
        // (r_Switch) is high. This means that we found a falling edge.
        if (i_Switch == 1'b0 && r_Switch == 1'b1)
        begin
            r_LED <= ~r_LED; // Toggle LED output
        end
    end

    assign o_LED = r_LED;
endmodule
