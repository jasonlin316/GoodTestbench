module SET ( clk , rst, en, central, radius, busy, valid, candidate );

input clk, rst;
input en; // i/p data is valid
input [7:0] central;
input [3:0] radius;
output busy;
output valid;
output [7:0] candidate;

//-----wire/reg declaration-------------

reg [7:0] candidate,k,h;
reg busy;
reg valid;
reg [7:0] sum;
reg signed[3:0] tmpX,tmpY;
reg signed[4:0] sX,sY;
reg [1:0] done,nextDone;
reg [3:0] tmpR;
reg [8:0] rSquare,dis;
integer c=0;
reg [1:0] enable;
reg [3:0] i,j,nexti,nextj;
reg [7:0] nextk,nextSum,nexth;

//---------------------------------
//      combinational part
//---------------------------------
always@(k)begin
           
    if(k<=224)begin
       
        dis = ((i-sX)**2+(j-sY)**2);
        if(dis < rSquare)nextSum = sum + 1;       
        else nextSum = sum ;
        
        nexti = (i==14)?  0  : i+1 ;
        nextj = (i==14)? j+1 : j   ;
        nextk = k + 1;       
    end 
    else begin
        //$display("nextDone");
        dis = ((0-sX)**2+(0-sY)**2);
        if(dis < rSquare)nextSum = sum + 1;       
        else nextSum = sum ;
        nextDone = 1;
    end
end

//---------------------------------
//      sequential part
//---------------------------------
always@(posedge clk or posedge rst)
begin

    if(rst) begin
    rSquare    <= 0;
    sX         <= 0;
    sY         <= 0;
    i          <= 1;
    j          <= 0;
    k          <= 0;
    valid      <= 0;
    candidate  <= 0;
    sum        <= 0;
    busy       <= 0;
    tmpX       <= 0;
    tmpY       <= 0;
    tmpR       <= 0;
    dis        <= 0;
    h          <= 0;
    nexth      <= 0;
    enable     <= 0;
    nexti      <= 1;
    nextj      <= 0;
    nextk      <= 1;
    nextSum    <= 0;
    nexth      <= 0;    
    done       <= 0;
    nextDone   <= 0;        
    end 
    else begin //not reset
      if(!busy)begin
      enable <= en;
      tmpX <= central[7:4];
      tmpY <= central[3:0];
      tmpR <= radius[3:0];
        if(enable)begin
            sX <= tmpX + 7;
            sY <= tmpY + 7;
            rSquare <= tmpR**2;
            busy <= 1;
        end
        else begin
            sX <= sX;
            sY <= sY;
            rSquare <= rSquare;
            busy <= 0;
        end
      end
      else begin//busy
         
         if(done)begin
         valid     <= 1;
         candidate <= sum;
         nextSum   <= 0;
         dis    <= 0;
         rSquare<=0;
         end
         //sequential
         else begin//not done
         i   <= nexti;
         j   <= nextj;   
         k   <= (k>=225)? k : nextk; 
         sum <= nextSum;
         done<= nextDone;       
         end

         if(valid)begin
         k  <= 0;
         i  <= 0;
         j  <= 0;
         busy  <= 0;
         valid <= 0;
         candidate <= 0;
         sum       <= 0;
         done   <= 0;
         nextDone<= 0;
         end 
      end
    end
end
endmodule


