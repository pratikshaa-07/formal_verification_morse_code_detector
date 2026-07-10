module morse_tb(input logic clk,input logic rst,input logic dot_inp,input logic dash_inp,input logic char_space_inp, input logic word_space_inp,input logic [7:0] sout);

 default clocking c1 @(posedge clk); endclocking
// default disable iff (!rst);

 //-------------------
 //states
 //-------------------

  parameter [3:0] s_idle       = 4'b0000;
  parameter [3:0] s_dot        = 4'b0001;
  parameter [3:0] s_dash       = 4'b0010;

  parameter [3:0] s_char_1     = 4'b0100;
  parameter [3:0] s_char_2     = 4'b0101;
  parameter [3:0] s_char_3     = 4'b0110;

  parameter [3:0] s_word_1     = 4'b1000;
  parameter [3:0] s_word_2     = 4'b1001;
  parameter [3:0] s_word_3     = 4'b1010;
  parameter [3:0] s_word_4     = 4'b1011;
  parameter [3:0] s_word_5     = 4'b1100;
  parameter [3:0] s_word_6     = 4'b1101;
  parameter [3:0] s_word_7     = 4'b1110;

  //----------------------
  //rec fsm
  //----------------------
  parameter [7:0] zero = 8'h20;
  parameter [7:0] one = 8'h21;
  parameter [7:0] two = 8'h22;
  parameter [7:0] three = 8'h23;
  parameter [7:0] four = 8'h24;
  parameter [7:0] five = 8'h25;
  parameter [7:0] six = 8'h26;
  parameter [7:0] seven = 8'h27;
  parameter [7:0] eight = 8'h28;
  parameter [7:0] nine = 8'h29;

//--------------------
//rec fsm alpha
//--------------------
  parameter [7:0] reset_state = 8'hff;
  parameter [7:0] a = 8'h00;
  parameter [7:0] b = 8'h01;
  parameter [7:0] c = 8'h02;
  parameter [7:0] d = 8'h03;
  parameter [7:0] e = 8'h04;
  parameter [7:0] f = 8'h05;
  parameter [7:0] g = 8'h06;
  parameter [7:0] h = 8'h07;
  parameter [7:0] i = 8'h08;
  parameter [7:0] j = 8'h09;
  parameter [7:0] k = 8'h0a;
  parameter [7:0] l = 8'h0b;
  parameter [7:0] m = 8'h0c;
  parameter [7:0] n = 8'h0d;
  parameter [7:0] o = 8'h0e;
  parameter [7:0] p = 8'h0f;
  parameter [7:0] q = 8'h10;
  parameter [7:0] r = 8'h11;
  parameter [7:0] s = 8'h12;
  parameter [7:0] t = 8'h13;
  parameter [7:0] u = 8'h14;
  parameter [7:0] v = 8'h15;
  parameter [7:0] w = 8'h16;
  parameter [7:0] x = 8'h17;
  parameter [7:0] y = 8'h18;
  parameter [7:0] z = 8'h19;

//auxilary code
logic [2:0]count;

always@(posedge clk or negedge rst)
begin
    if(!rst)
        count<=0;
    else if(char_space_inp)
        count<=0;
    else if(dot_inp || dash_inp)
        count<=count+1;
end
//-------------------assume-----------------//

property dot_p;
disable iff(!rst)
dot_inp |=> !dot_inp;
endproperty

//-----

property dash_p;
disable iff(!rst)
 dash_inp |=> !dash_inp;
endproperty

//-----
property char_p;
disable iff(!rst)
 char_space_inp |=> !char_space_inp[*3];
endproperty

//-----
property word_p;
disable iff(!rst)
 word_space_inp |=> !word_space_inp[*7];
endproperty


//-----
property one_inp_high;
disable iff(!rst)
  $onehot0({dash_inp,char_space_inp,word_space_inp,dot_inp});
endproperty

property count_p1;
disable iff(!rst)
count==5 |->(char_space_inp || word_space_inp);
endproperty

property count_p2;
disable iff(!rst)
count==5 |->!dot_inp;
endproperty

property count_p3;
disable iff(!rst)
count==5 |->!dash_inp;
endproperty


dot_prop:assume property(dot_p);
dash_prop:assume property(dash_p);

word_prop:assume property(word_p);
char_prop:assume property(char_p);

one_in_prop:assume property(one_inp_high);

count1_prop:assume property(count_p1);
count2_prop:assume property(count_p2);
count3_prop:assume property(count_p3);

//---------------------------assert--------------------------//

//-----------basic op test----------------//

property word_test;
disable iff(!rst)
(word_space_inp && morse_top.trans.state ==s_idle) |->##8 morse_top.trans_out== 3'b100 && morse_top.serial_out==8'h20;
endproperty

property char_space_op;
disable iff(!rst)
(char_space_inp && morse_top.trans.state==s_idle) |=>##3 (morse_top.trans_out==3'b011);
endproperty

property dot_op;
disable iff(!rst)
(dot_inp && morse_top.trans.state==s_idle) |=>##1 (morse_top.trans_out==3'b001);
endproperty

property dash_op;
disable iff(!rst)
(dash_inp && morse_top.trans.state==s_idle) |=>##1 (morse_top.trans_out==3'b010);
endproperty

word_sapce_test:assert property(word_test);
char_space_test:assert property(char_space_op);
dot_in_test:assert property(dot_op);
dash_in_test:assert property(dash_op);

//--------numbers test----------------------------//
property zero_num;
disable iff(!rst)
(morse_top.rec.state==zero && morse_top.trans_out==3'b011) |-> sout==8'h30;
endproperty

property nine_num;
disable iff(!rst)
(morse_top.rec.state==nine && morse_top.trans_out==3'b011) |-> sout==8'h39;
endproperty

property eight_num;
disable iff(!rst)
(morse_top.rec.state==eight && morse_top.trans_out==3'b011) |-> sout==8'h38;
endproperty

property seven_num;
disable iff(!rst)
(morse_top.rec.state==seven && morse_top.trans_out==3'b011) |-> sout==8'h37;
endproperty

property six_num;
disable iff(!rst)
(morse_top.rec.state==six && morse_top.trans_out==3'b011) |-> sout==8'h36;
endproperty

property five_num;
disable iff(!rst)
(morse_top.rec.state==five && morse_top.trans_out==3'b011) |-> sout==8'h35;
endproperty

property four_num;
disable iff(!rst)
(morse_top.rec.state==four && morse_top.trans_out==3'b011) |-> sout==8'h34;
endproperty

property three_num;
disable iff(!rst)
(morse_top.rec.state==three && morse_top.trans_out==3'b011) |-> sout==8'h33;
endproperty

property two_num;
disable iff(!rst)
(morse_top.rec.state==two && morse_top.trans_out==3'b011) |-> sout==8'h32;
endproperty

property one_num;
disable iff(!rst)
(morse_top.rec.state==one && morse_top.trans_out==3'b011) |-> sout==8'h31;
endproperty

zero_test: assert property(zero_num);
nine_test: assert property(nine_num);
eight_test:assert property(eight_num);
seven_test:assert property(seven_num);
six_test:  assert property(six_num);
five_test: assert property(five_num);
four_test: assert property(four_num);
three_test:assert property(three_num);
two_test:  assert property(two_num);
one_test:  assert property(one_num);

//------------------alpha test----------------------//
property a_alpha;
disable iff(!rst)
(morse_top.rec.state==a && morse_top.trans_out==3'b011) |-> sout==8'h61;
endproperty

property b_alpha;
disable iff(!rst)
(morse_top.rec.state==b && morse_top.trans_out==3'b011) |-> sout==8'h62;
endproperty

property c_alpha;
disable iff(!rst)
(morse_top.rec.state==c && morse_top.trans_out==3'b011) |-> sout==8'h63;
endproperty

property d_alpha;
disable iff(!rst)
(morse_top.rec.state==d && morse_top.trans_out==3'b011) |-> sout==8'h64;
endproperty

property e_alpha;
disable iff(!rst)
(morse_top.rec.state==e && morse_top.trans_out==3'b011) |-> sout==8'h65;
endproperty

property f_alpha;
disable iff(!rst)
(morse_top.rec.state==f && morse_top.trans_out==3'b011) |-> sout==8'h66;
endproperty

property g_alpha;
disable iff(!rst)
(morse_top.rec.state==g && morse_top.trans_out==3'b011) |-> sout==8'h67;
endproperty

property h_alpha;
disable iff(!rst)
(morse_top.rec.state==h && morse_top.trans_out==3'b011) |-> sout==8'h68;
endproperty

property i_alpha;
disable iff(!rst)
(morse_top.rec.state==i && morse_top.trans_out==3'b011) |-> sout==8'h69;
endproperty

property j_alpha;
disable iff(!rst)
(morse_top.rec.state==j && morse_top.trans_out==3'b011) |-> sout==8'h6A;
endproperty

property k_alpha;
disable iff(!rst)
(morse_top.rec.state==k && morse_top.trans_out==3'b011) |-> sout==8'h6B;
endproperty

property l_alpha;
disable iff(!rst)
(morse_top.rec.state==l && morse_top.trans_out==3'b011) |-> sout==8'h6C;
endproperty

property m_alpha;
disable iff(!rst)
(morse_top.rec.state==m && morse_top.trans_out==3'b011) |-> sout==8'h6D;
endproperty

property n_alpha;
disable iff(!rst)
(morse_top.rec.state==n && morse_top.trans_out==3'b011) |-> sout==8'h6E;
endproperty

property o_alpha;
disable iff(!rst)
(morse_top.rec.state==o && morse_top.trans_out==3'b011) |-> sout==8'h6F;
endproperty

property p_alpha;
disable iff(!rst)
(morse_top.rec.state==p && morse_top.trans_out==3'b011) |-> sout==8'h70;
endproperty

property q_alpha;
disable iff(!rst)
(morse_top.rec.state==q && morse_top.trans_out==3'b011) |-> sout==8'h71;
endproperty

property r_alpha;
disable iff(!rst)
(morse_top.rec.state==r && morse_top.trans_out==3'b011) |-> sout==8'h72;
endproperty

property s_alpha;
disable iff(!rst)
(morse_top.rec.state==s && morse_top.trans_out==3'b011) |-> sout==8'h73;
endproperty

property t_alpha;
disable iff(!rst)
(morse_top.rec.state==t && morse_top.trans_out==3'b011) |-> sout==8'h74;
endproperty

property u_alpha;
disable iff(!rst)
(morse_top.rec.state==u && morse_top.trans_out==3'b011) |-> sout==8'h75;
endproperty

property v_alpha;
disable iff(!rst)
(morse_top.rec.state==v && morse_top.trans_out==3'b011) |-> sout==8'h76;
endproperty

property w_alpha;
disable iff(!rst)
(morse_top.rec.state==w && morse_top.trans_out==3'b011) |-> sout==8'h77;
endproperty

property x_alpha;
disable iff(!rst)
(morse_top.rec.state==x && morse_top.trans_out==3'b011) |-> sout==8'h78;
endproperty

property y_alpha;
disable iff(!rst)
(morse_top.rec.state==y && morse_top.trans_out==3'b011) |-> sout==8'h79;
endproperty

property z_alpha;
disable iff(!rst)
(morse_top.rec.state==z && morse_top.trans_out==3'b011) |-> sout==8'h7A;
endproperty

a_test : assert property(a_alpha);
b_test : assert property(b_alpha);
c_test : assert property(c_alpha);
d_test : assert property(d_alpha);
e_test : assert property(e_alpha);
f_test : assert property(f_alpha);
g_test : assert property(g_alpha);
h_test : assert property(h_alpha);
i_test : assert property(i_alpha);
j_test : assert property(j_alpha);
k_test : assert property(k_alpha);
l_test : assert property(l_alpha);
m_test : assert property(m_alpha);
n_test : assert property(n_alpha);
o_test : assert property(o_alpha);
p_test : assert property(p_alpha);
q_test : assert property(q_alpha);
r_test : assert property(r_alpha);
s_test : assert property(s_alpha);
t_test : assert property(t_alpha);
u_test : assert property(u_alpha);
v_test : assert property(v_alpha);
w_test : assert property(w_alpha);
x_test : assert property(x_alpha);
y_test : assert property(y_alpha);
z_test : assert property(z_alpha);


endmodule
bind morse_top morse_tb dut_inst(.*);
