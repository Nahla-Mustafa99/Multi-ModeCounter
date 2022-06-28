/* DESIGN MODULE*/
module counter_4bits(inter_f1.dut id);
  /*other*/
  logic [3:0] winners,losers;/* count of the number of occurrences of WINNER,LOSER SIGNALS*/
  logic flag=1'b0;/*To prevent the counter from returning to the initial value again even if INIT is still high:if(INIT and !flag)counted_no<=initial-val*/
  logic start=0;/*to ensure that flag=0 untill the INIT become high*/
  logic [3:0] old_initial_val;/* to preserve the old initial value and load it to the counter after each gameover because may be the initial value changes(after a reset) but INIT is still low*/
  /*NOTE : the initial value that is loaded at first cannot be changed again except after a reset is done and INIT=1 */
  always@(id.cb or posedge id.rst ) begin
    id.cb.WINNER <= 1'b0;
    id.cb.LOSER  <= 1'b0;
    id.cb.WHO<=2'b00;
    id.cb.GAMEOVER<=0;
    /* asynchronously RESET all counters and signals */ 
    if(id.rst )  begin
      id.counted_no<=id.initial_val;
      flag=1'b0;
      id.GAMEOVER<=1'b0;
      id.LOSER<=0;
      id.WINNER<=0;
      winners=4'b0000;
      losers=4'b0000;
      id.WHO<=2'b00;
    end
    /*rst=0*/
    else begin
    /*This if_block will be executed initially only,even if INIT is still 1,as flag will be=1*/
    /* if rst=1 then  the initial value is changed and INIT=1 then rst=0 this block will executed synchronously */
      if(id.INIT && (!flag)) begin
         id.counted_no=id.initial_val;
        old_initial_val<=id.initial_val;
        winners<=4'b0000;
        losers<=4'b0000;
        flag<=1'b1;
        start<=1;
      end
      /*if GAMEOVER=1 then synchronously clear all the counters and start over*/
    if(id.GAMEOVER==1)  begin
      id.counted_no=old_initial_val;
      id.cb.WHO<=2'b00;
      id.cb.GAMEOVER<=1'b0;
      flag=1'b0; 
      winners=4'b0000;
      losers=4'b0000;
    end
    
      
      /*Initially, the counter should not do anything, and the initial value is loaded into it,as flag = 0*/
      if(flag)
        case(id.ctrl)
          2'b00:  id.counted_no=id.counted_no+1'b1;
          2'b01:  id.counted_no=id.counted_no+2'b10;
          2'b10:  id.counted_no=id.counted_no-1'b1;
          2'b11:  id.counted_no=id.counted_no-2'b10;
    	  default:id.counted_no=id.counted_no+2'b10;
        endcase
        if(start)
          flag<=1;
      
     
      /* When the count is all ones, set THE WINNER SIGNAL high,Add one to winners(WINNER Count)*/
      if(id.counted_no==4'b1111  )begin
        id.cb.WINNER<=1'b1;
        winners=winners+1'b1;
      end
      /*When the count is all zeros, set THE LOSER SIGNAL high,add one to losers(LOSER_COUNT) */
      if(id.counted_no==4'b0000)begin
        id.cb.LOSER<=1'b1;
        losers=losers+1'b1;
      end

      /*When loser_count reaches 15, set GAMEOVER high,set WHO to 2’b01*/
      if(losers==4'b1111)begin
        id.cb.WHO<=2'b01;
        id.cb.GAMEOVER<=1'b1;
        //flag<=1'b0;
        //id.counted_no<=id.initial_val;
      	//winners<=4'b0000;
      	//losers<=4'b0000;
      end
    
      /*When winner_count reaches 15, set GAMEOVER high,set WHO to 2’b10*/
      if(winners==4'b1111)begin
      	id.cb.WHO<=2'b10;
      	id.cb.GAMEOVER<=1'b1;
      end
    end// else end
  end//ALWAYS END
endmodule




    /* TOP MODULE*/
module top(output logic clk);
  /*Clock implementation clock cycle =10 */
  initial clk=0;
  initial forever#(5) clk=~clk;
  //
  inter_f1 I1(clk);
  counter_4bits(I1.dut);
  testCounter(I1.tb);
  
  /*SIMULATION*/
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #7200 $finish;
  end
endmodule


