module nonblocking_comb(
    input wire a, b, c, d,
    output reg z  
);
    reg tmp1 , tmp2; 

    always @(a, b, c, d) begin 
        tmp1 <= a & b;
        tmp2 <= c & d;
        z <= tmp1 | tmp2;
    end 

endmodule

module tb_nonblocking_comb;
    reg a, b, c, d;
    wire z;

    nonblocking_comb uut (
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .z(z)
    );

    initial begin
        // Test cases
        a = 0; b = 0; c = 0; d = 0; #10;
        a = 1; b = 0; c = 0; d = 0; #10;
        
        $finish;
    end

    initial begin
        $monitor("Time: %t | a: %b, b: %b, c: %b, d: %b | z: %b", $time, a, b, c, d, z);
    end
endmodule

module nonblocking_comb_v2(
    input wire a, b, c, d,
    output reg z  
);
    reg tmp1 , tmp2; 

    always @(a, b, tmp1, tmp2) begin 
        tmp1 = a & b;
        tmp2 = c & d;
        z = tmp1 | tmp2;
    end
endmodule

module tb_nonblocking_comb_v2;
    reg a, b, c, d;
    wire z;

    nonblocking_comb_v2 uut (
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .z(z)
    );

    initial begin
        // Test cases
        a = 0; b = 0; c = 0; d = 0; #10;
        a = 1; b = 0; c = 0; d = 0; #10;
        
        $finish;
    end

    initial begin
        $monitor("Time: %t | a: %b, b: %b, c: %b, d: %b | z: %b", $time, a, b, c, d, z);
    end
endmodule