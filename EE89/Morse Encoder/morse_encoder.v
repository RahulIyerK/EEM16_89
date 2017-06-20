module MorseEncoder(

//CLK Input
	 input clk,

//Push Button Inputs
         input btnC, //char_vald
	 input btnU, //reset

// Slide Switch Inputs
	 input [15:0] sw, //set dinA[15:0] and dinB[15:0]

// LED Outputs
     output [15:0] led
 );

wire[7:0] charcode_data;
wire[3:0] charlen_data;
wire reset;
wire char_vald;
wire led_drv;

parameter S_START = 3'b000;
parameter S_LOAD = 3'b001;
parameter S_NONSPACE = 3'b010;
parameter S_SPACE  = 3'b011;
parameter S_GOOD = 3'b100;
  
reg[2:0] cur_st;
reg[2:0] nxt_st;
  
reg trigger_sc = 1'b0;


   // Outputs from modules       
wire       shft_data, sym_done, led_drv; 
wire [3:0] cntr_data; 

reg 	      char_next, char_load, shft_cnt, sym_strt;

reg[26:0] q;
  
wire clock;

  assign led[0] = led_drv;
  assign led[9] = clock;

  always @ (posedge clk or posedge btnU)
  begin
    if (btnU == 1'b1)
        begin
            q<=0;
        end
    else
        begin
            q<=q+1;
        end
  end
  
  
  assign clock = q[26];
  
  always @ (posedge clock)
    begin
      cur_st <= nxt_st;

    end


assign led[15] = char_next;

   code_reg codestore0(sw[11:4], sw[3:0], char_load, 
                       sym_done, cntr_data, shft_data, btnU, clock);
   led_fsm ledfsm0(sym_strt, shft_data, led[0], sym_done, 
                   btnU, clock);
  
  
  wire space_done;
         
  space_counter space_counter0(trigger_sc, space_done, clock);
  

  //reg first_symbol;  
  reg test = 1'b0;
  assign led[8] = test;
  
  always @ (*)
    begin
    if (btnU)
      begin
        nxt_st = S_START;
        char_next = 1'b0;
      end
    else
      begin
        
        case (cur_st)
          S_START:
            begin

              if (btnC == 1'b0)
                begin
                  //char_next = 1'b1;
                  
                  char_load = 1'b0; //don't load into the shift register, because the data is not valid
            	  trigger_sc = 1'b0;      
                  sym_strt = 1'b0;
                  
                  //first_symbol = 1'b0;

                  nxt_st = S_START; //we're going to remain in this start cycle till the char_vald signal is asserted
                end
              
              else if (btnC == 1'b1)              
                begin
                  //test = 1'b0;
                  
                  char_load = 1'b1; //loads charcode_data and charlen_data into the shift register
                  char_next = 1'b0; //makes sure that the char_next signal is not asserted					                  
                  if (sw[3:0] > 4'b0000)
                    begin
                        trigger_sc = 1'b0;
                        //first_symbol = 1'b1;
                        nxt_st = S_LOAD;
                    end
                  else if (sw[3:0] == 4'b0000)
                    begin
                      trigger_sc = 1'b1;

                      //first_symbol = 1'b0;
                      nxt_st = S_SPACE;
                    end
                end

            end
          S_LOAD:
          begin
          sym_strt = 1'b1;
          nxt_st = S_NONSPACE;
          end
          
          S_NONSPACE:
            begin
              //char_next = 1'b0;
              char_load = 1'b0; //make sure the char_load signal is not asserted
              
              if (sym_done == 1'b1)
                begin
                  if (cntr_data == 4'b0001)
                    begin
                      nxt_st = S_GOOD;
                    end
                  
                  if (cntr_data > 4'b0001)
                    begin
                      nxt_st = S_NONSPACE;
                      sym_strt = 1'b1;
                    end
                end
              else if (sym_done == 1'b0)
                begin
                  nxt_st = S_NONSPACE;
                  sym_strt = 1'b0;
                 
                end
            end
		S_SPACE:
          begin
            trigger_sc = 1'b0;
            
            char_load = 1'b0;


            if (space_done == 1'b1)
            begin
              nxt_st = S_GOOD;

            end
          
            if (space_done == 1'b0)
            begin 
              nxt_st = S_SPACE;
            end
            
        end
          
          S_GOOD:
            begin
              char_next = 1'b1;
              nxt_st = S_START;
            end
          
          default:
            begin
            end
        endcase
      end
    end  
  
  
endmodule // dassign3
