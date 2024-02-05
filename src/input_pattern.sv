module input_pattern(
    input wire [1151:0]   input_pattern_in,
    input wire [1:0]      input_pattern_mode,
    output wire [1599:0]  input_pattern_out
);

    //----------------------------------------------------------------
    // Multiplers to properly select the input depening on which 
    // primitive is required. 
    ////----------------------------------------------------------------
    reg selA, selB, selC;
    reg[1599:0] state;
    
    assign selA = (input_pattern_mode == 2'b01 || input_pattern_mode == 2'b11 || input_pattern_mode == 2'b10) ? 1'b1 : 1'b0;
    assign selB = (input_pattern_mode == 2'b10 || input_pattern_mode == 2'b11) ? 1'b1 : 1'b0;
    assign selC = (input_pattern_mode == 2'b10) ? 1'b1 : 1'b0;
    
    
    assign state[7:0]     = input_pattern_in[1151:1144];
    assign state[15:8]    = input_pattern_in[1143:1136];   
    assign state[23:16]   = input_pattern_in[1135:1128];
    assign state[31:24]   = input_pattern_in[1127:1120];
    assign state[39:32]   = input_pattern_in[1119:1112];
    assign state[47:40]   = input_pattern_in[1111:1104];
    assign state[55:48]   = input_pattern_in[1103:1096];
    assign state[63:56]   = input_pattern_in[1095:1088];
    assign state[71:64]   = input_pattern_in[1087:1080];
    assign state[79:72]   = input_pattern_in[1079:1072];
    assign state[87:80]   = input_pattern_in[1071:1064];
    assign state[95:88]   = input_pattern_in[1063:1056];
    assign state[103:96]  = input_pattern_in[1055:1048];
    assign state[111:104] = input_pattern_in[1047:1040];
    assign state[119:112] = input_pattern_in[1039:1032];
    assign state[127:120] = input_pattern_in[1031:1024];
    assign state[135:128] = input_pattern_in[1023:1016];
    assign state[143:136] = input_pattern_in[1015:1008];
    assign state[151:144] = input_pattern_in[1007:1000];
    assign state[159:152] = input_pattern_in[999:992];
    assign state[167:160] = input_pattern_in[991:984];
    assign state[175:168] = input_pattern_in[983:976];
    assign state[183:176] = input_pattern_in[975:968];
    assign state[191:184] = input_pattern_in[967:960];
    assign state[199:192] = input_pattern_in[959:952];
    assign state[207:200] = input_pattern_in[951:944];
    assign state[215:208] = input_pattern_in[943:936];
    assign state[223:216] = input_pattern_in[935:928];
    assign state[231:224] = input_pattern_in[927:920];
    assign state[239:232] = input_pattern_in[919:912];
    assign state[247:240] = input_pattern_in[911:904];
    assign state[255:248] = input_pattern_in[903:896];
    assign state[263:256] = input_pattern_in[895:888];
    assign state[271:264] = input_pattern_in[887:880];
    assign state[279:272] = input_pattern_in[879:872];
    assign state[287:280] = input_pattern_in[871:864];
    assign state[295:288] = input_pattern_in[863:856];
    assign state[303:296] = input_pattern_in[855:848];
    assign state[311:304] = input_pattern_in[847:840];
    assign state[319:312] = input_pattern_in[839:832];
    assign state[327:320] = input_pattern_in[831:824];
    assign state[335:328] = input_pattern_in[823:816];
    assign state[343:336] = input_pattern_in[815:808];
    assign state[351:344] = input_pattern_in[807:800];
    assign state[359:352] = input_pattern_in[799:792];
    assign state[367:360] = input_pattern_in[791:784];
    assign state[375:368] = input_pattern_in[783:776];
    assign state[383:376] = input_pattern_in[775:768];
    assign state[391:384] = input_pattern_in[767:760];
    assign state[399:392] = input_pattern_in[759:752];
    assign state[407:400] = input_pattern_in[751:744];
    assign state[415:408] = input_pattern_in[743:736];
    assign state[423:416] = input_pattern_in[735:728];
    assign state[431:424] = input_pattern_in[727:720];
    assign state[439:432] = input_pattern_in[719:712];
    assign state[447:440] = input_pattern_in[711:704];
    assign state[455:448] = input_pattern_in[703:696];
    assign state[463:456] = input_pattern_in[695:688];
    assign state[471:464] = input_pattern_in[687:680];
    assign state[479:472] = input_pattern_in[679:672];
    assign state[487:480] = input_pattern_in[671:664];
    assign state[495:488] = input_pattern_in[663:656];
    assign state[503:496] = input_pattern_in[655:648];
    assign state[511:504] = input_pattern_in[647:640];
    assign state[519:512] = input_pattern_in[639:632];    
    assign state[527:520] = input_pattern_in[631:624];
    assign state[535:528] = input_pattern_in[623:616];
    assign state[543:536] = input_pattern_in[615:608];
    assign state[551:544] = input_pattern_in[607:600];
    assign state[559:552] = input_pattern_in[599:592];
    assign state[567:560] = input_pattern_in[591:584];
    assign state[575:568] = input_pattern_in[583:576];

    
    // Implement multiplexers for different sections of input_pattern_in
    always @*
    begin
        case(selA) // @suppress "Default clause missing from case statement"
            2'b1: begin
                state[583:576] = input_pattern_in[575:568];
                state[591:584] = input_pattern_in[567:560];
                state[599:592] = input_pattern_in[559:552];
                state[607:600] = input_pattern_in[551:544];
                state[615:608] = input_pattern_in[543:536];
                state[623:616] = input_pattern_in[535:528];
                state[631:624] = input_pattern_in[527:520];
                state[639:632] = input_pattern_in[519:512];
                state[647:640] = input_pattern_in[511:504];
                state[655:648] = input_pattern_in[503:496];
                state[663:656] = input_pattern_in[495:488];
                state[671:664] = input_pattern_in[487:480];
                state[679:672] = input_pattern_in[479:472];
                state[687:680] = input_pattern_in[471:464];
                state[695:688] = input_pattern_in[463:456];
                state[703:696] = input_pattern_in[455:448];
                state[711:704] = input_pattern_in[447:440];
                state[719:712] = input_pattern_in[439:432];
                state[727:720] = input_pattern_in[431:424];
                state[735:728] = input_pattern_in[423:416];
                state[743:736] = input_pattern_in[415:408];
                state[751:744] = input_pattern_in[407:400];
                state[759:752] = input_pattern_in[399:392];
                state[767:760] = input_pattern_in[391:384];
                state[775:768] = input_pattern_in[383:376];
                state[783:776] = input_pattern_in[375:368];
                state[791:784] = input_pattern_in[367:360];
                state[799:792] = input_pattern_in[359:352];
                state[807:800] = input_pattern_in[351:344];
                state[815:808] = input_pattern_in[343:336];
                state[823:816] = input_pattern_in[335:328];
                state[831:824] = input_pattern_in[327:320];
            end
            2'b0: state[831:576] = 256'b0;
        endcase
    end

    always @*
    begin
        case(selB) // @suppress "Default clause missing from case statement"
                2'b1: begin
                    state[839:832] = input_pattern_in[319:312];
                    state[847:840] = input_pattern_in[311:304];
                    state[855:848] = input_pattern_in[303:296];
                    state[863:856] = input_pattern_in[295:288];
                    state[871:864] = input_pattern_in[287:280];
                    state[879:872] = input_pattern_in[279:272];
                    state[887:880] = input_pattern_in[271:264];
                    state[895:888] = input_pattern_in[263:256];
                    state[903:896] = input_pattern_in[255:248];
                    state[911:904] = input_pattern_in[247:240];
                    state[919:912] = input_pattern_in[239:232];
                    state[927:920] = input_pattern_in[231:224];
                    state[935:928] = input_pattern_in[223:216];
                    state[943:936] = input_pattern_in[215:208];
                    state[951:944] = input_pattern_in[207:200];
                    state[959:952] = input_pattern_in[199:192];
                    state[967:960] = input_pattern_in[191:184];
                    state[975:968] = input_pattern_in[183:176];
                    state[983:976] = input_pattern_in[175:168];
                    state[991:984] = input_pattern_in[167:160];
                    state[999:992] = input_pattern_in[159:152];
                    state[1007:1000] = input_pattern_in[151:144];
                    state[1015:1008] = input_pattern_in[143:136];
                    state[1023:1016] = input_pattern_in[135:128];
                    state[1031:1024] = input_pattern_in[127:120];
                    state[1039:1032] = input_pattern_in[119:112];
                    state[1047:1040] = input_pattern_in[111:104];
                    state[1055:1048] = input_pattern_in[103:96];
                    state[1063:1056] = input_pattern_in[95:88];
                    state[1071:1064] = input_pattern_in[87:80];
                    state[1079:1072] = input_pattern_in[79:72];
                    state[1087:1080] = input_pattern_in[71:64];
            end 
            2'b0: state[1087:832] = 256'b0;
        endcase
    end

    always @*
    begin
        case(selC) // @suppress "Default clause missing from case statement"
            2'b1: begin
                state[1095:1088] = input_pattern_in[63:56];
                state[1103:1096] = input_pattern_in[55:48];
                state[1111:1104] = input_pattern_in[47:40];
                state[1119:1112] = input_pattern_in[39:32];
                state[1127:1120] = input_pattern_in[31:24];
                state[1135:1128] = input_pattern_in[23:16];
                state[1143:1136] = input_pattern_in[15:8];
                state[1151:1144] = input_pattern_in[7:0];
            end
            2'b0: state[1151:1088] = 64'b0;
        endcase
    end

    assign state[1599:1152] = 448'b0;
    
   
   assign input_pattern_out = state;
    
endmodule