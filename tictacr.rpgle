**free
ctl-opt Option(*nodebugio) dftactgrp(*no) actgrp(*new);
dcl-f TICTACD workstn;
dcl-s count int(10) inz(0);
dcl-s temp char(3);
dcl-s fieldarr char(2) dim(9) ctdata perrcd(9);
dcl-s entrdVal char(2) dim(9);
dcl-s idx packed(1:0);
dcl-s ptr pointer;
dcl-s feildNm char(2) based(Ptr);
dcl-s Invalid ind inz(*off);
dcl-s Win ind inz(*off);
dcl-s ValExsts ind inz(*off);
dcl-s indPtr pointer;
dcl-s unEdit ind based(indPtr);
dcl-s i packed(2:0);
dcl-pr PlayerTurn end-pr;

Exsr PlayerSelection;
Msg = 'Player ' + FLD001 + '`s' + ' Turn';
dow *in12 = *off;
   clear fld;
   exfmt TICTAC;
   if win = *on and *in05 = *off;
      for i = 25 to 33;
        *in(i) = *on;
      endfor;

   elseif  *in05 = *on;
      Win  = *off;
      *in = *off;
      invalid =  *on;
      clear TICTAC;
      for i = 1 to 9;
         entrdVal(i) = *blanks;
      endfor;
      Exsr PlayerSelection;
      clear count;

   elseif  fld = *blanks and *in12 = *on;
      leave;

   else;
      clear temp;
      Clear Msg;
      Clear FAILMSG;
      IndPtr = *null;
      Ptr = *null;
      invalid = *off;
      ValExsts = *off;
      select;
         When (LT = 'X' or LT = 'O')  and %trim(FLD) = 'LT';
            temp = LT + 'LT';
            indPtr = %addr(*in25);
            ptr = %addr(LT);
            PlayerTurn();

         When (LM = 'X' or LM = 'O') and FLD = 'LM';
            temp = LM + 'LM';
            indPtr = %addr(*in26);
            ptr = %addr(LM);
            PlayerTurn();

         When (LB = 'X' or LB = 'O') and FLD = 'LB';
            temp = LB + 'LB';
            indPtr = %addr(*in27);
            ptr = %addr(LB);
            PlayerTurn();

         When (MT = 'X' or MT = 'O') and FLD = 'MT';
            temp = MT + 'MT';
            indPtr = %addr(*in28);
            ptr = %addr(MT);
            PlayerTurn();

         When (MM = 'X' or MM = 'O') and FLD = 'MM';
            temp = MM + 'MM';
            indPtr = %addr(*in29);
            ptr = %addr(MM);
            PlayerTurn();

         When (MB = 'X' or MB = 'O') and FLD = 'MB';
            temp = MB + 'MB';
            indPtr = %addr(*in30);
            ptr = %addr(MB);
            PlayerTurn();

         When (RT = 'X' or RT = 'O') and FLD = 'RT';
            temp = RT + 'RT';
            ptr = %addr(RT);
            indPtr = %addr(*in31);
            PlayerTurn();

         When (RM = 'X' or RM = 'O') and FLD = 'RM';
            temp = RM + 'RM';
            indPtr = %addr(*in32);
            ptr = %addr(RM);
            PlayerTurn();

         When (RB = 'X' or RB = 'O') and FLD = 'RB';
            temp = RB + 'RB';
            indPtr = %addr(*in33);
            ptr = %addr(RB);
            PlayerTurn();
         Other;
            Msg = 'Invalid Input';
            invalid = *on;
            if %rem(count:2) = 1 and %subst(temp:1:1) = FLD001;
               Msg = 'Player ' + FLD002 + '`s' + ' Turn';
            Elseif %rem(count:2) = 0 and %subst(temp:1:1)= FLD002;
               Msg = 'Player ' + FLD001 + '`s' + ' Turn';
            endif;
      Endsl;
   Endif;
   if count >= 5 and invalid = *off and ValExsts = *off and fld <> *blanks;
      entrdVal(idx) = %subst(temp:1:1);
      UnEdit = *on;
      Exsr Wincheck;
   elseif count > 0 and invalid = *off and ValExsts = *off and fld <> *blanks;
      entrdVal(idx) = %subst(temp:1:1);
      UnEdit = *on;
   Endif;
enddo;


   *inlr = *on;

begsr PlayerSelection;
   dow *in12 = *off;
      Exfmt PLYSLCTN;
      if FLD001 = 'X' and FLD001 <> FLD002;
         FLD002 = 'O';
         leave;
      elseif FLD002 = 'X' and FLD001 <> FLD002;
         FLD001 = 'O';
         leave;
      elseif FLD001 = 'O' and FLD001 <> FLD002;
         FLD002 = 'X';
         leave;
      elseif FLD002 = 'O' and FLD001 <> FLD002;
         FLD001 = 'X';
         leave;
      Elseif FLD001 = FLD002;
         eRRmsg = 'Player_1 and Player_2 Cannot choose same Value';
      endif;
   enddo;
endsr;

begsr Wincheck;
   select;
      When (LT = 'X' and MT = 'X' and RT = 'X') or
           (LM = 'X' and MM = 'X' and RM = 'X') or
           (LB = 'X' and MB = 'X' and RB = 'X') or
           (LT = 'X' and LM = 'X' and LB = 'X') or
           (MT = 'X' and MM = 'X' and MB = 'X') or
           (RT = 'X' and RM = 'X' and RB = 'X') or
           (LT = 'X' and MM = 'X' and RB = 'X') or
           (LB = 'X' and MM = 'X' and RT = 'X');
           win = *on;
           Msg = 'Player_1 Won the Game';

      When (LT = 'O' and MT = 'O' and RT = 'O') or
           (LM = 'O' and MM = 'O' and RM = 'O') or
           (LB = 'O' and MB = 'O' and RB = 'O') or
           (LT = 'O' and LM = 'O' and LB = 'O') or
           (MT = 'O' and MM = 'O' and MB = 'O') or
           (RT = 'O' and RM = 'O' and RB = 'O') or
           (LT = 'O' and MM = 'O' and RB = 'O') or
           (LB = 'O' and MM = 'O' and RT = 'O');
           Msg = 'Player_2 Won the Game';
           win = *on;
      when Count = 9;
            Msg = 'Match Draw';
   endsl;
endsr;

dcl-proc PlayerTurn;
   Count += 1;
   idx  = %lookup(%subst(temp:2:2):fieldarr);

   if %rem(count:2) = 1 and %subst(temp:1:1)<>FLD001;
      Msg = 'Player ' + FLD001 + '`s' + ' Turn';
      failmsg = 'Player_1 Value is X, Plase Input Correct Value';
         count -= 1;
         invalid = *on;

   Elseif %rem(count:2) = 0 and %subst(temp:1:1)<>FLD002;
      Msg = 'Player ' + FLD002 + '`s' + ' Turn';
      failmsg = 'Player_1 Value is O, Plase Input Correct Value';
      count -=1;
      invalid = *on;

   Elseif %rem(count:2) = 1 and %subst(temp:1:1) = FLD001;
      Msg = 'Player ' + FLD002 + '`s' + ' Turn';

   Elseif %rem(count:2) = 0 and %subst(temp:1:1) = FLD002;
      Msg = 'Player ' + FLD001 + '`s' + ' Turn';
   endif;

   if entrdVal(idx) <> *blanks;
      ValExsts = *on;
      feildNm = entrdVal(idx);
      Count -= 1;
      if %rem(count:2) = 1;
         Msg = 'Player ' + FLD002 + '`s' + ' Turn';
      Elseif %rem(count:2)=0;
         Msg = 'Player ' + FLD001 + '`s' + ' Turn';
      endif;
      FAILMSG = 'Field Already Filled';
   Endif;

end-proc;

**CTDATA fieldarr
LTLMLBMTMMMBRTRMRB
