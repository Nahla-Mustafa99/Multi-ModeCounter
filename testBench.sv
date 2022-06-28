


/* TEST BENCH PROGRAM*/
program testCounter(inter_f1.tb it);
  /* TEST */
  initial begin
    /* At t=0 there is initial value but it will not be loaded as INIT=0*/
    it.initial_val=4'b0011;
    it.INIT=0;
    it.ctrl=2'b00;// count+1
    /*t=10*/
    #10 it.INIT=1 ; /*the initial value will be loaded into counter at t=15
    (synchronously)*/
    /*t=30*/
    #20 it.INIT=0;
    
    /*at t=2520*    RESET ALL */
    #2490 	it.rst=1;
    
    /*at t=2550* Rst=0 count by 2*/
    #30 it.rst=0; ;it.INIT=1;  it.initial_val=2; it.ctrl=2'b01; //count+2 starting from 2
    /*at t=2560*/
    #10 it.INIT=0;
    /*at t=3760* RESET*/
    #1200 it.rst=1;
    /*at t=3763*/
    #3 it.rst=0; ; it.ctrl=2'b10; //count-1 starting from 2*as initial value does not be changed*
    /*at t=6040*/
    #2277 it.rst=1;
    /*t=6043 */
    #3 it.rst=0;it.INIT=1; it.ctrl=2'b11; it.initial_val=1; //count-2 from 1
    #10 it.INIT=0;
    #1200;
  end
endprogram

/* INTERFACE */
interface inter_f1(input bit clk);
  logic rst, INIT;
  logic [1:0] ctrl ; 
  logic [3:0] initial_val; /*2_bit control signals*/
  /*outputs in dut*/
  logic [3:0] counted_no;   /*main counter count*/
  logic[1:0] WHO;
  logic GAMEOVER=0;
  logic WINNER ,LOSER;
  clocking cb @(posedge clk);
    output WHO,GAMEOVER,WINNER,LOSER,counted_no;
   // input counted_no;
  endclocking
  modport dut(clocking cb,output counted_no,WHO,GAMEOVER,WINNER,LOSER,input rst,INIT,initial_val,ctrl);
  modport tb(output rst,INIT,initial_val,ctrl,input counted_no,WHO,GAMEOVER,WINNER,LOSER);
    
     // ASSERTAIONS //
    assertion1: assert property(@(negedge clk) (WINNER)|->(counted_no==4'b1111))
      $display("Succeeded: At %0t WINNER signal is %0b, WHEN main counter=%0b:",$time,WINNER,counted_no);
      else
        $error("FAILED:error At %0t WINNER is %0b but count=%0b ",$time,WINNER,counted_no);  
      
    assertion2: assert property(@(negedge clk) (WINNER&&GAMEOVER)|-> (WHO==2'b10))
      $display("Succeeded: At %0t WINNER signal is %0b, GAMEOVER is %b, and WHO=%0d",$time,WINNER,GAMEOVER,WHO);
       else
         $error("FAILED:error AT At %0t",$time);
    
      assertion3: assert property(@(negedge clk) (LOSER)|->(counted_no==4'b0000))
        $display("Succeeded: At %0t LOSER signal is %0b, WHEN main counter=%0b:",$time,LOSER,counted_no);
      else
        $error("FAILED:error At %0t LOSER is %0b but count=%0b ",$time,LOSER,counted_no);  
       
       
    assertion4: assert property(@(negedge clk) (LOSER&&GAMEOVER)|-> (WHO==2'b01))
      $display("Succeeded: At %0t LOSER signal is %0b, GAMEOVER is %b, and WHO=%0d ",$time,LOSER,GAMEOVER,WHO);
      else
        $error("FAILED:error At At %0t",$time);
endinterface
        
