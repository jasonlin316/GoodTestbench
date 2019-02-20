`timescale 1ns/10ps
`define cycle 10.0
`define terminate_cycle 200000 // Modify your terminate ycle here
`define SDFFILE    "./imgproc_syn.sdf" 

module testfixture;

`define golden "./data/golden.dat"
`define  pattern "./data/pattern.dat"

reg clk = 0;
reg rst;

reg [7:0]     orig_data;
reg           orig_ready;

wire          request;
wire [13:0]   orig_addr;

wire          imgproc_ready;
wire [13:0]   imgproc_addr;
wire [7:0]    imgproc_data;
wire          finish;

integer err_cnt;

reg [7:0] pattern_mem [0:16383];
reg [7:0] golden_mem  [0:16383];
reg [7:0] imgproc_mem [0:16383];

`ifdef SDF
initial $sdf_annotate(`SDFFILE, u_set);
`endif

initial begin
	$fsdbDumpfile("imgproc.fsdb");
	$fsdbDumpvars;
//    $dumpfile("imgproc.vcd");
//   $dumpvars(0,testfixture); 
end

initial begin
	$timeformat(-9, 1, " ns", 9); //Display time in nanoseconds
	$readmemh(`pattern, pattern_mem);
	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
    $readmemh(`golden, golden_mem);
end

always #(`cycle/2) clk = ~clk;


imgproc u_set( .clk(clk), .rst(rst), .orig_data(orig_data), .orig_ready(orig_ready), .request(request), .orig_addr(orig_addr), .imgproc_ready(imgproc_ready), .imgproc_addr(imgproc_addr), .imgproc_data(imgproc_data), .finish(finish) );
integer k;
integer p;

initial begin
	
      	rst = 0;
	err_cnt = 0;
# `cycle;     
	rst = 1;
#(`cycle*2);
	rst = 0;

wait(finish == 1);
@(negedge clk);
		for (k = 0; k<=16383; k = k+1)begin
			if (imgproc_mem[k] === golden_mem[k])
			$display(" Pattern %d is passed !", k);
			else begin
			$display(" Pattern %d failed !. Expected candidate = %d, but the Response candidate = %d !! ", k, golden_mem[k], imgproc_mem[k]);
			err_cnt = err_cnt + 1;
			end
		end
#(`cycle 2); 
     $display("--------------------------- Simulation Stops !!---------------------------");
     if (err_cnt) begin 
     	$display("============================================================================");
     	$display("\n (T_T) ERROR found!! There are #d errors in total.\n"  err_cnt);
		$display("             ▄▄▄▄▄▄▄ "); 
		$display("         ▄▀▀▀       ▀▄"); 
		$display("       ▄▀            ▀▄ 		ERROR found"); 
		$display("      ▄▀          ▄▀▀▄▀▄"); 
		$display("    ▄▀          ▄▀  ██▄▀▄"); 
		$display("   ▄▀  ▄▀▀▀▄    █   ▀▀ █▀▄ 	There are #d errors in total."  err_cnt); 
		$display("   █  █▄▄   █   ▀▄     ▐ █  "); 
		$display("  ▐▌  █▀▀  ▄▀     ▀▄▄▄▄▀  █ "); 
		$display("  ▐▌  █   ▄▀              █"); 
		$display("  ▐▌   ▀▀▀                ▐▌"); 
		$display("  ▐▌               ▄      ▐▌ "); 
		$display("  ▐▌         ▄     █      ▐▌ "); 
		$display("   █         ▀█▄  ▄█      ▐▌ "); 
		$display("   ▐▌          ▀▀▀▀       ▐▌ "); 
		$display("    █                     █ "); 
		$display("    ▐▌▀▄                 ▐▌"); 
		$display("     █  ▀                ▀ "); 
        $display("============================================================================");
	end
     else begin 
        $display("============================================================================");
        $display("\n");
        $display("/ /##########\                                  #########");
        $display("// /############/                           #############");
        $display("  /  (#############       /            ##################");
        $display("       ################################################  ");
        $display("        /###########################################     ");
        $display("          //(#####################################(      ");
        $display("           (##################################(/         ");
	$display("    ...   /####################################(         ");
	$display("    ..    #####(   /###############(    ########(        ");
	$display("         (#####     ###############     (########  //////");
	$display(".        #######(  (################   (#########( //////");
	$display(".       /###############/  (######################///////");
	$display("       .    /############################/ ///(###( /////");
	$display("//    . /////(##########################///////####  ////");
	$display("      .  ////#########(       /#########(//////####(    /");
	$display("       (#((###########(        (#########(((((######/ ///");
	$display("       /###############(      /(####################( ///");
	$display("/////// /#################(  (#######################    ");
	$display("//////   (###########################################(   ");
	$display("WOOOOOW  YOU  PASSED!!!");
        $display("\n");
        $display("============================================================================");
        $finish;
	end
$finish;
end


always@(err_cnt) begin
	if (err_cnt == 10) begin
    $display("============================================================================");
    	$display("      ▄▄           ▄▄  "); 
	$display("       ██         ██ "); 
	$display("        ██       ██ "); 
	$display("          ██   ██ "); 
	$display("           ██ ██  "); 
	$display("        ▄▄██████████▄  		MORE THAN 10 ERRORS!!!"); 
	$display("      █▀             ▀█ "); 
	$display("      █   █████████   █ 	MY GRANDMA writes a better program than you."); 
	$display("      █  ▄█▀    ▀█▄   █"); 
	$display("██    █  █   ▄█▄   █  █     ██"); 
	$display("███   █  █   ███   █  █   ▄███"); 
	$display("█ ██  █  █   ▀█▀   █  █  ▄█ █"); 
	$display("▀█ ██ █  ▀█▄     ▄█▀  █ ▄█ █▀ "); 
	$display(" ▀█ █▄█     ▀███▀     █▄█ █▀"); 
	$display("   ▀██                █▀"); 
	$display("      █  ▄████████▄   █▌"); 
	$display("      █  █        █   █"); 
	$display("      █  █        █   █"); 
	$display("      █  ▀▀▀▀▀▀▀▀▀▀   █ "); 
	$display("      ██             ██"); 
	$display("       ██           ██ ");
	$display("        █ ▄██████▄ █ "); 
	$display("        █ █      █ █ ");  
	$display("        █ █      █ █  ");  
	$display("        ██▀      ▀██   ");   
    $display("============================================================================");
    $finish;
	end
end

initial begin 
	#`terminate_cycle;
	$display("==================================================================================================");
	$display("                  ▄▄▄▄▄▄▄▄▄▄▄"); 
	$display("            ▄▄▀▀▀            ▀▄"); 
	$display("        ▄▄▀▀       ▄▄▄▄▄▄▄      ▀▄"); 
	$display("      ▄▀         ▄▄▄▄▄▄▄▄▄▄▄      █			Time out!"); 
	$display("    ▄▀     ▄▄▄▄▄▄▄            ▄▄▄▄▄█▄▄"); 
	$display("   ▄▀ ▐▌          ▀▀       ▀▀       █		The simulation didn't finish "); 
	$display("  █   ▀       ▄▀▀▀▀▄    ▄    ▄▀▀▀▀▄   ▐▌          after #d cycles!!" `terminate_cycle); 
	$display(" █           ▐   ▄  ▌    ▀▄ ▐   ▄ ▌   █"); 
	$display("▐▌          ▄ ▀▄▄▄▄▀       ▌ ▀▄▄▄▄▀    ▐▌ 	Man you're taking waaaaaay too long..."); 
	$display("█            ▀▄▄▄        ▐     ▄▄▄▀   █"); 
	$display("█    ▄▀       ▄▄      ▄▀ ▐   ▄▄       █"); 
	$display("▐▌  ▀       ▄▀   ▐▀       ▀▌   ▀▄     █"); 
	$display("▐▌   ▐     ▐▌     ▀█       ▌    █     █"); 
	$display(" █              ▄  ▀▀▄▄▄▄▀▀ ▀▄        █"); 
	$display(" ▐▌           ▄▀    ▄▄▄▄▄▄▄▄   ▌      █"); 
	$display("  █          ▐    ▄▀        ▀▄        ▐▌"); 
	$display("  ▐▌         ▐    ▀▀▀▀▀▀▀▀▀▀▀▀  ▀     █"); 
	$display("   ▐▌         ▄███████▄    ▄████████▄"); 
	$display("    ▀▄████████████▀█████▄▄████████▀██"); 
	$display("   ▄██▀▄     ███▀▄██████▀▀██████▀▄███"); 
	$display("   ▀▀       ▀▀█████████▀▀▀▀█████████▀");
	$display("               ▀▀▀▀▀▀▀      ▀▀▀▀▀▀▀");  
	$display("==================================================================================================");
	$finish;
end


endmodule
