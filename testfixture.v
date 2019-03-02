`timescale 1ns/10ps
`define SDFFILE    "./SET_syn.sdf"    // Modify your sdf file name here
`define cycle 10.0
`define terminate_cycle 200000 // Modify your terminate ycle here


module testfixture;

`define central_pattern "./dat/Central_pattern.dat"
`define radius_pattern "./dat/Radius_pattern.dat"
`define  candidate_result_Length "./dat/candidate_result_Length.dat"


reg clk = 0;
reg rst;
reg en;
reg [7:0] central;
reg [3:0] radius;
wire busy;
wire valid;
wire [7:0] candidate;

integer err_cnt;

reg [7:0] central_pat_mem [0:63];
reg [3:0] radius_pat_mem[0:63];
reg [7:0] expected_mem [0:63];

`ifdef SDF
initial $sdf_annotate(`SDFFILE, u_set);
`endif

initial begin
//	$fsdbDumpfile("SET.fsdb");
//	$fsdbDumpvars;
    $dumpfile("SET.vcd");
    $dumpvars(0,testfixture); 
end

initial begin
	$timeformat(-9, 1, " ns", 9); //Display time in nanoseconds
	$readmemh(`central_pattern, central_pat_mem);
	$readmemh(`radius_pattern, radius_pat_mem);

	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
	$readmemh(`candidate_result_Length, expected_mem);

end



always #(`cycle/2) clk = ~clk;


SET u_set( .clk(clk), .rst(rst), .en(en), .central(central), .radius(radius), .busy(busy), .valid(valid), .candidate(candidate) );

integer k;
integer p;
initial begin
	en = 0;
      	rst = 0;
	err_cnt = 0;
# `cycle;     
	rst = 1;
#(`cycle*3);
	rst = 0;
for (k = 0; k<=63; k = k+1) begin
	@(negedge clk);
	//change inputs at strobe point
        #(`cycle/4)	wait(busy == 0);
			en = 1;
			central = central_pat_mem[k];                
      			radius = radius_pat_mem[k];
			#(`cycle) en = 0;
			wait (valid == 1);
          	//Wait for signal output
          	@(negedge clk);
				if (candidate === expected_mem[k])
					$display(" Pattern %d is passed !", k);
				else begin
					$display(" Pattern %d failed !. Expected candidate = %d, but the Response candidate = %d !! ", k, expected_mem[k], candidate);
					err_cnt = err_cnt + 1;
				end
end
#(`cycle*2); 
     $display("--------------------------- Simulation Stops !!---------------------------");
     if (err_cnt) begin 
     	$display("============================================================================");
		$display("             ▄▄▄▄▄▄▄ "); 
		$display("         ▄▀▀▀       ▀▄"); 
		$display("       ▄▀            ▀▄ 		ERROR FOUND!!"); 
		$display("      ▄▀          ▄▀▀▄▀▄"); 
		$display("    ▄▀          ▄▀  ██▄▀▄"); 
		$display("   ▄▀  ▄▀▀▀▄    █   ▀▀ █▀▄ 	There are"); 
		$display("   █  █▄▄   █   ▀▄     ▐ █  %d errors in total.", err_cnt); 
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
		$display("	^o^		WOOOOOW  YOU  PASSED!!!");
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
	$display("   ▄▀ ▐▌          ▀▀       ▀▀       █		The simulation didn't finish after "); 
	$display("  █   ▀       ▄▀▀▀▀▄    ▄    ▄▀▀▀▀▄   ▐▌	%d cycles!!",`terminate_cycle); 
	$display(" █           ▐   ▄  ▌    ▀▄ ▐   ▄ ▌   █"); 
	$display("▐▌          ▄ ▀▄▄▄▄▀       ▌ ▀▄▄▄▄▀    ▐▌ 	Man you're taking waaaaaay to long..."); 
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
