removalOfHyphensBetweenSynonyms([], []) :-
    succeed().

removalOfHyphensBetweenSynonyms(Input, Output) :-
    if Input = [] then
        Output = []
    elseif Input = [WID] then
        Output = [WID]
    else
        Input = [WID1, WID2 | Tail],
        if db:getWord(SID, WID2, Count2, "-", FP2, LP2, IAS2, IASID2) and ! then
            if Tail = [] then
                Output = [WID1, WID2]
            else
                Tail = [WID3 | Tail3],
                db:getWord(SID, WID1, _Count1, Word1, _FP1, _LP1, _IAS1, _IASID1),
                !,
                db:getWord(SID, WID3, _Count3, Word3, _FP3, _LP3, _IAS3, _IASID3),
                !,
                if db:getSynonym2(_SynID3, _Type3, _Value3, [Word1, Word3], _MustBe3, _CantBe3)
                    % TODO this is dangerous as we could get synonyms which are disturbed by this function
                    %and not(db:getSynonym3(_SynIDX, _TypeX, _ValueX, [Word1, "-", Word3, _Word4], _MustBeX, _CantBe3))
                then
                    removalOfHyphensBetweenSynonyms(Tail3, Output3),
                    Output = [WID1, WID3 | Output3],
                    db:removeWord(SID, WID2, Count2, "-", FP2, LP2, IAS2, IASID2)
                elseif Tail3 = [] then
                    Output = [WID1, WID2, WID3]
                else
                    Tail3 = [WID4 | Tail4],
                    db:getWord(SID, WID4, _Count4, Word4, _FP4, _LP4, _IAS4, _IASID4),
                    if db:getSynonym3(_SynID4, _Type4, _Value4, [Word1, Word3, Word4], _MustBe4, _CantBe4) then
                        removalOfHyphensBetweenSynonyms(Tail4, Output4),
                        Output = [WID1, WID3, WID4 | Output4],
                        db:removeWord(SID, WID2, Count2, "-", FP2, LP2, IAS2, IASID2)
                    else
                        removalOfHyphensBetweenSynonyms(Tail4, Output4),
                        Output = [WID1, WID2, WID3, WID4 | Output4]
                    end if
                end if
            end if
        else
            removalOfHyphensBetweenSynonyms([WID2 | Tail], Output2),
            Output = [WID1 | Output2]
        end if
    end if.

synonymExpanded([], []) :-
    succeed().

synonymExpanded([WID | Tail], [WID | Tail1]) :-
    synonymExpanded(Tail, Tail2),
    db:getWord(SID, WID, WCount, Head, X, Y, Type, TID),
    if util::charMemberOf(string::frontChar(Head), ['$', '¥']) and
        % TODO we need to be more precise when there is a more than one character (such as the AUS$).
        string::length(Head) > 1
        and NewHead1 = string::subString(Head, 1, string::length(Head) - 1) and util::numberP(NewHead1)
        % we remove it because sometimes people aggregate b/m/k at the end of a number
        %, stdIO::writef ("****** We found a % in % \n", string::frontChar(Head), WID)
    then
        %stdIO::writef ("Head = % \n", Head),
        %NewHead1 = string::subString (Head, 1, string::length (Head) -1),
        %stdio::writef ("we now have % preceded by $ between % and % \n", NewHead1, X, Y),
        db:removeWord(SID, WID, WCount, Head, X, Y, Type, TID),
        db:setWord(SID, WID, WCount, string::substring(Head, 0, 1), X, X, Type, TID),
        WID2 = string::concatList([WID, "-1"]),
        db:setWord(SID, WID2, WCount + 1, NewHead1, X + 1, Y, Type, TID),
        !,
        db:updateCountAfterDeleteWords(Tail2, -1),
        % TODO Check: I had Tail before
        Tail1 = [WID2 | Tail2]
    else
        if db:getSynonymPlus(SPType, [NewHead, AddedValue], Head) then
            if SPType = ""
                or db:getWord(SID, _WID4, WCount - 1, Head4, _X4, _Y4, _Type4, _TID4) and SPType = "number" and util::numberP(Head4)
                %,  stdio::writef("We found that % can be replaced by % % \n", Head, NewHead, AddedValue)
                %(numberP(Head1) ; percentageP (Head1, Percentage))
            then
                if Tail = []
                    or db:getWord(SID, _WID3, WCount + 1, ActualWord3, _FP3, _LP3, _IAS3, _IASID3) and not(ActualWord3 = AddedValue)
                    %, not (prepositionP (ActualWord3))) %TODO Understand why this last predicate
                    % to avoid having two prepositions?
                then
                    db:removeWord(SID, WID, WCount, Head, X, Y, Type, TID),
                    db:setWord(SID, WID, WCount, NewHead, X, Y, Type, TID),
                    WID2 = string::concatList([WID, "-1"]),
                    db:setWord(SID, WID2, WCount + 1, AddedValue, X, Y, "", ""),
                    db:setWordInfo(WID2, "", "", "", "", ""),
                    %stdio::writef("!!!!!!!!!!!!!!!!!! we added % \n", AddedValue),
                    db:updateCountAfterDeleteWords(Tail2, -1),
                    Tail1 = [WID2 | Tail2]
                else
                    Tail1 = Tail2
                end if
            else
                Tail1 = Tail2
            end if
        else
            Tail1 = Tail2
        end if,
        !
    end if,
    !.

synonymSimplifiedP0(X, Y) :-
    if X = [] then
        Y = []
    else
        X = [WID | ROX],
        if db:getWord(SID, WID, Count, Wording, FP, LP, IAS, IASID) and db:getSynonym1(_SynID, "cl_useless0", _AW, [Wording], _MustBe, _CantBe)
        then
            db:removeWord(SID, WID, Count, Wording, FP, LP, IAS, IASID),
            db:setWord(SID, WID, Count, "cl_useless", FP, LP, "cl_useless", IASID),
            !,
            synonymSimplifiedP0(ROX, Y1),
            Y = [WID | Y1]
        else
            synonymSimplifiedP0(ROX, Y1),
            Y = [WID | Y1]
        end if
    end if.

synonymSimplified(X, Y, P) :-
    %stdio::writef("Entering synonymSimplified with % \n", toString(list::length(X))),
    if P = 0 then
        synonymSimplifiedP0(X, Y)
    else
        synonymSimplifiedV1(X, Y, P)
    end if.

synonymSimplifiedV1(X, Y, P) :-
    if X = [] then
        Y = []
    else
        synonymSimplifiedFor9(X, Y, P)
    end if.

synonymSimplifiedFor9(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor8 with % \n", X),
    if X = [] then
        Y = []
    elseif synonymIfSimplified9(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified9(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor8(X, Y, P)
    end if.

synonymSimplifiedFor8(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor8 with % \n", X),
    if X = [] then
        Y = []
    elseif synonymIfSimplified8(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified8(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor7(X, Y, P)
    end if.

synonymSimplifiedFor7(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor7 with % \n", X),
    if synonymIfSimplified7(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified7(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor6(X, Y, P)
    end if.

synonymSimplifiedFor6(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor6 with % \n", X),
    if synonymIfSimplified6(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified6(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor5(X, Y, P)
    end if.

synonymSimplifiedFor5(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor5 with % \n", X),
    if synonymIfSimplified5(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified5(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor4(X, Y, P)
    end if.

synonymSimplifiedFor4(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor4 with % \n", X),
    if synonymIfSimplified4(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified4(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor3(X, Y, P)
    end if.

synonymSimplifiedFor3(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor3 with % \n", X),
    if synonymIfSimplified3(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified3(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor2(X, Y, P)
    end if.

synonymSimplifiedFor2(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor2 with % \n", X),
    if synonymIfSimplified2(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified2(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    else
        synonymSimplifiedFor1(X, Y, P)
    end if.

synonymSimplifiedFor1(X, Y, P) :-
    %stdio::writef("We enter synonymSimplifiedFor1 with % \n", X),
    if synonymIfSimplified1(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif synonymSimplified1(X, Y1, P) then
        if Y1 = [] then
            Y = []
        else
            Y1 = [Head1 | ROY1],
            synonymSimplifiedFor9(ROY1, Y2, P),
            Y = [Head1 | Y2]
        end if
    elseif X = [] then
        Y = []
    else
        X = [Head | ROX],
        synonymSimplifiedFor9(ROX, NewY, P),
        Y = [Head | NewY]
    end if.

synonymIfSimplified(X, Y, P) :-
    synonymIfSimplifiedFor8(X, Y0, P),
    synonymIfSimplifiedFor7(Y0, Y10, P),
    synonymIfSimplifiedFor6(Y10, Y1, P),
    synonymIfSimplifiedFor5(Y1, Y2, P),
    synonymIfSimplifiedFor4(Y2, Y3, P),
    synonymIfSimplifiedFor3(Y3, Y4, P),
    synonymIfSimplifiedFor2(Y4, Y5, P),
    synonymIfSimplifiedFor1(Y5, Y, P).

synonymIfSimplifiedFor8(X, Y, P) :-
    if synonymIfSimplified8(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor8(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor7(X, Y, P) :-
    if synonymIfSimplified7(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor7(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor6(X, Y, P) :-
    if synonymIfSimplified6(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor6(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor5(X, Y, P) :-
    if synonymIfSimplified5(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor5(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor4(X, Y, P) :-
    if synonymIfSimplified4(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor4(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor3(X, Y, P) :-
    if synonymIfSimplified3(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor3(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor2(X, Y, P) :-
    if synonymIfSimplified2(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor2(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

synonymIfSimplifiedFor1(X, Y, P) :-
    if synonymIfSimplified1(X, Y, P) then
        succeed()
    elseif X = [Head | Tail] then
        synonymIfSimplifiedFor1(Tail, NewTail, P),
        Y = [Head | NewTail]
    else
        Y = []
    end if.

cleanUselessSynonyms() :-
    % this is because the cl_useless have a type "value" while it should be "cl_useless".
    db:getSynonym1(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym1(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym1(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    %stdio::writef("We cleaned % as a useless synonym\n", Wording),
    fail()
    or
    db:getSynonym2(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym2(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym2(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym3(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym3(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym3(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym4(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym4(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym4(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym5(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym5(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym5(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym6(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym6(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym6(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym7(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym7(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym7(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym8(SynID, "value", "cl_useless", Wording, MustBe, CantBe),
    db:removeSynonym8(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym8(SynID, "cl_useless", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym1(SynID, "value", "cl_useless0", Wording, MustBe, CantBe),
    db:removeSynonym1(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym1(SynID, "cl_useless0", Target, Wording, MustBe, CantBe),
    %stdio::writef("We cleaned % as a useless synonym\n", Wording),
    fail()
    or
    db:getSynonym2(SynID, "value", "cl_useless0", Wording, MustBe, CantBe),
    db:removeSynonym2(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym2(SynID, "cl_useless0", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym3(SynID, "value", "cl_useless0", Wording, MustBe, CantBe),
    db:removeSynonym3(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym3(SynID, "cl_useless0", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym4(SynID, "value", "cl_useless0", Wording, MustBe, CantBe),
    db:removeSynonym4(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym4(SynID, "cl_useless0", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym5(SynID, "value", "cl_useless0", Wording, MustBe, CantBe),
    db:removeSynonym5(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym5(SynID, "cl_useless0", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym6(SynID, "value", "cl_useless0", Wording, MustBe, CantBe),
    db:removeSynonym6(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym6(SynID, "cl_useless0", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym1(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym1(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym1(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    %stdio::writef("We cleaned % as a useless synonym\n", Wording),
    fail()
    or
    db:getSynonym2(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym2(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym2(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym3(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym3(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym3(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym4(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym4(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym4(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym5(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym5(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym5(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym6(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym6(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym6(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym7(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym7(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym7(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym8(SynID, "value", "cl_useless5", Wording, MustBe, CantBe),
    db:removeSynonym8(SynID, "value", Target, Wording, MustBe, CantBe),
    db:setSynonym8(SynID, "cl_useless5", Target, Wording, MustBe, CantBe),
    fail()
    or
    succeed().

matchSynonymType(SynType, Marker, WID, Number) :-
    % this function looks into the Spacy EType of the first word and refuses an incompatible synonym type
    %stdio::writef("We enter matchSynonymType with Marker = % \n", Marker),
    db:getWord(_SID, WID, Count, Word, _FP, _LP, _IAS, _IASID),
    %stdio::writef("We have word = % \n", Word),
    db:getWordInfo(WID, Original, POS, EType, _SPacy1, _Spacy2),
    %stdio::writef("We are inside matchSynonymType with EType = %, POS = % \n", EType, POS),
    if EType = "PERSON" then
        if SynType = "author" or SynType = "companyGroup" then
            succeed()
            /* % Why do we accept a companyGroup when it is labeled a person?
elseif SynType = "companyGroup" then
            succeed()
*/
        else
            fail()
        end if
        /* % This filter sounds a little too steep. We had "Tesla's vehicle deliveries" where [vehicle deliveries] is a synonym for the baseKPI "deliveries"
% both vehicle and deliveries are an ORG
    elseif ETYPE = "ORG" and SynType = "baseKPI" and not(util::stringMemberOf(Word, ["ep", "revenu", "r&d"])) then
        fail()
*/
    elseif not(SynType = "companyGroup") % if it is not a company group, we are good
        % this is checking the
    then
        succeed()
    elseif Number < 3 and util::stringMemberOf(SynType, ["eCLMarker", "trendMarker"]) and POS = "PROPN" then
        fail()
    elseif Number = 1 %and stdio::writef("we have number = 1 \n")
        % we have a single word synonym
        and not(POS = "PROPN") and not(Count = 1) and Original1 = string::toLowerCase(Original)
        %and stdio::writef("Original1 = % \n", Original1)
        and if string::lastChar(Original1) = ' ' then
            Original2 = string::substring(Original1, 0, string::length(Original1) - 1)
        else
            Original2 = Original1
        end if
        and not(Original2 = Word) %if Original2 is not the stemmed version, we fail
        % we give priority to the company (ford) if the original is the marker of the company
        %and stdio::writef("Trying to figure out if the Original % is the ticker symbol of another company than % \n", Original, Marker)
        and db:getCompanyGroup(_IGID, Marker1, _UpperCompanyID, "Company", [Original2], _Industries, _Dnode) and not(Marker = Marker1)
        % and we fail if the marker is the one of another company
    then
        fail()
    else
        succeed()
    end if.

matchSynonymPriority(SynType, P) :-
    %stdio::writef("We are entering matchSynonymPriority with SynType % and P % \n", SynType, P),
    % this has to be updated as synonyms have types, and we define more precisely which type belongs to which priority level/pass
    if P < 1 and
        % formely util::stringMemberOf(SynType, ["P0", "cl_useless0"]) then
        SynType = "cl_useless0"
    then
        succeed()
    elseif P = 2
        and util::stringMemberOf(SynType,
            [
                "",
                "unit",
                "companyGroup",
                "cl_useless",
                "baseKPI",
                "location",
                "industryGroup",
                "baseEvent",
                "author",
                "trendMarker",
                "eCLMarker",
                "value",
                "timeSpan",
                "time",
                "title",
                "suggestionMarker",
                "compoundUnit",
                "composite",
                "cl_useless5",
                "event",
                "intensity",
                "executable"
            ])
    then
        %if SynType = "cl_useless5" then stdio::writef("We got a cl_useless5 with priority % \n", P) else succeed() end if,
        succeed()
    elseif P < 6 and P > 3
        and util::stringMemberOf(SynType, ["eCLMarker", "trendMarker", "cl_useless5", "event", "timeSpan", "unit", "compoundUnit", "intensity"])
    then
        %if SynType = "cl_useless5" then stdio::writef("We got a cl_useless5 with priority % \n", P) else succeed() end if,
        %succeed()
        fail()
    else
        fail()
    end if.

validCompanyDetection(WID, Type) :-
    %TODOFY Need to figure out a way to remove a company from the forbiddenCompanies list if it is accessed through a valid Synonym (say two words or three at the beginning)
    if Type = "companyGroup" then
        db:getWord(SID, WID, Count, AW, _FP, _LP, _IAS, _IASID),
        if db:getSynonymIf1M(_SynonymIfID, _SynIfType, _NewIfHead, [AW], _MustBeIf, _CantBeIf, _ContextIf, _ValueIf)
            or db:getSynonymIf1(_SynonymIfID, _SynIfType, _NewIfHead, [AW], _MustBeIf, _CantBeIf, _ContextIf, _ValueIf)
        then
            succeed()
        elseif db:getCompanyGroup(_IGID, AW, _UpperCYID, "Product", _TickerSymbol, _Industries, _DNode) then
            succeed()
        else
            % we know WID is a synonym for a company and that it is not a synonymIf
            %stdio::writef("We are inside validCompanyDetection with % \n", AW),
            db:getListOfForbiddenCompanies(List),
            !,
            if util::stringMemberOf(AW, List) then
                fail()
            else
                succeed()
            end if,
            db:getWordInfo(WID, _Original, POS, EType, _Spacy1, _Spacy2),
            %stdio::writef("Innogen EType = % \n", EType),
            POS = "PROPN",
            if db:getWord(SID, WID1, Count + 1, _AW1, _FP1, _LP1, _IAS1, _IASID1)
                and db:getWordInfo(WID1, _Original1, POS1, EType1, _Spacy11, _Spacy21) and POS1 = "PROPN" and EType1 = "PERSON"
                and EType = "PERSON" and db:getTypedCollection("companyNotPerson", CompanyList)
                %and stdio::writef("We look at % which could be part of the list % \n", AW, CompanyList)
                and not(util::stringMemberOf(AW, CompanyList))
            then
                %stdio::writef("We have a chance to have a person \n"),
                db:getListOfForbiddenCompanies(ForbiddenCompanies),
                !,
                if util::stringMemberOf(AW, ForbiddenCompanies) then
                    succeed()
                else
                    %stdio::writef("We are adding % to the list of forbidden companies in % \n", AW, SID),
                    db:removeListOfForbiddenCompanies(ForbiddenCompanies),
                    db:setListOfForbiddenCompanies([AW | ForbiddenCompanies])
                end if,
                %stdio::writef("Person Name wrong synonym for % \n", AW),
                fail()
            else
                succeed()
            end if,
            %stdio::writef("We have count = % \n", Count),
            if db:getWord(SID, WID2, Count - 1, AW2, _FP2, _LP2, _IAS2, _IASID2)
                and db:getWordInfo(WID2, _Original2, POS2, EType2, _SPacy12, _Spacy22) and POS2 = "PROPN"
            then
                if EType = "PERSON" and EType2 = "PERSON" and db:getTypedCollection("companyNotPerson", CompanyList)
                    and not(util::stringMemberOf(AW, CompanyList))
                then
                    db:getListOfForbiddenCompanies(ForbiddenCompanies),
                    !,
                    if util::stringMemberOf(AW, ForbiddenCompanies) then
                        succeed()
                    else
                        db:removeListOfForbiddenCompanies(ForbiddenCompanies),
                        db:setListOfForbiddenCompanies([AW | ForbiddenCompanies])
                        %,stdio::writef("We are adding2 % in the list of forbidden companies in % \n", AW, SID)
                    end if,
                    %stdio::writef("Wrong synonym for % in %\n", AW, SID),
                    fail()
                elseif EType = "ORG" and EType2 = "ORG"
                    and db:getCompanyGroup(_IGID2, AW2, _UpperCy2, "Company", _TickerSymbol2, _Industries2, _DNode2)
                    and db:getTypedCollection("companyNotPerson", CompanyList) and not(util::stringMemberOf(AW, CompanyList))
                then
                    db:getListOfForbiddenCompanies(ForbiddenCompanies),
                    !,
                    if util::stringMemberOf(AW, ForbiddenCompanies) then
                        succeed()
                    else
                        db:removeListOfForbiddenCompanies(ForbiddenCompanies),
                        db:setListOfForbiddenCompanies([AW | ForbiddenCompanies])
                    end if,
                    fail()
                elseif util::stringMemberOf(AW2, ["bui", "sell", "hold"]) then
                    succeed()
                else
                    succeed()
                end if
            else
                succeed()
            end if
        end if
    else
        succeed()
    end if.

reinstateValidCompany(NewHead, Type) :-
    if Type = "companyGroup" then
        db:getListOfForbiddenCompanies(ForbiddenCompanies),
        if util::stringMemberOf(NewHead, ForbiddenCompanies) then
            db:removeListOfForbiddenCompanies(ForbiddenCompanies),
            util::removeElementFromStringList(NewHead, ForbiddenCompanies, NewForbiddenCompanies),
            db:setListOfForbiddenCompanies(NewForbiddenCompanies),
            !
        else
            succeed()
        end if
    else
        succeed()
    end if.

ambiguousSynonym(WID, Head) :-
    %stdio::writef("Testing ambiguous synonym on % \n", Head),
    db:getSelectionMarker(_SM1, Head, _Unambiguous, _Type1, _Detected, _PostT, _MaxD, _Priority),
    %stdio::writef("We found a selection Marker matching % \n", Head),
    checkAndReplaceAmbigousSynonym(WID)
    %and stdio::writef("We replaced % \n", Head)
    .

checkAndReplaceAmbigousSynonym(WID) :-
    db:getWord(SID, WID, _WC, Head, _X, _Y, _Type, _TID),
    db:getSentence(_AID, _PID, SID, _CID, _PosInP, _Sentence),
    %stdio::writef("We are entering checkAndReplaceAmbigousSynonym for % \n", Head),
    db:getListOfSelectionMarkers(Head, [], SMList),
    %stdio::writef("The list of selection markers is % \n", SMList),
    if SMList = [] then
        fail()
    else
        checkAndReplaceAmbiguousSynonym1(WID, SID, SMList)
    end if.

checkAndReplaceAmbiguousSynonym1(WID, SID, [SMID1 | RSMList]) :-
    db:getSelectionMarker(SMID1, Head, Unambiguous, TypeSM, Detected, PostT, MaxD, _Priority),
    %stdio::writef("We are looking for % at most % words away\n", Detected, MaxD),
    if db:presentInSentence(WID, SID, Detected, PostT, MaxD) then
        %stdio::writef("We are now trying to replace % because % is present \n", Head, Detected),
        db:getWord(SID, WID, WC, Head, X, Y, Type, TID),
        if Head = Unambiguous then
            succeed()
        else
            db:removeWord(SID, WID, WC, Head, X, Y, Type, TID),
            db:setWord(SID, WID, WC, Unambiguous, X, Y, TypeSM, TID)
        end if
    elseif RSMList = [] then
        fail()
    else
        checkAndReplaceAmbiguousSynonym1(WID, SID, RSMList)
    end if.

transformTypeForSynonymIf(IfType, FinalType) :-
    % This function is doing a mapping from the type coming from the synonym to the type used in the contexts. Not very pretty, but works
    if IfType = "companyGroup" then
        FinalType = "Company"
    elseif IfType = "company" then
        FinalType = "Company"
    elseif IfType = "product" then
        FinalType = "Product"
    elseif IfType = "industryGroup" then
        FinalType = "Industry"
    elseif IfType = "industry" then
        FinalType = "Industry"
    elseif IfType = "segment" then
        FinalType = "Segment"
    elseif IfType = "location" then
        FinalType = "Country"
    elseif IfType = "author" then
        FinalType = "Author"
    else
        FinalType = IfType
    end if.

synonymSimplified1([WID | Tail], [WID | Tail], P) :-
    % TODO: testing the concept that we must try all synonyms with a non [] MustBe before those where MustBe is []
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID, WCount, Head, X, Y, Type, TID),
    % note that the "" was Type before  TODO this is a good question: can a synonym change the type of a word? Or is the choice final?
    %stdio::writef("Trying % \n", Head),
    if P > 0 and ambiguousSynonym(WID, Head) then
        fail()
    else
        succeed()
    end if,
    %stdio::writef("We pass here with Head = %\n", Head),
    if % and !
        % and (not(Head = NewHead) and (SynType = ""))
        %stdio::writef("We got a Synonym1 of Type % where NewHead = % \n", SynType, NewHead) and
        %stdio::writef("We got a synonym of type % \n", SynType) and
        db:getSynonym1M(_SynonymID, SynType1, NewHead, [Head], MustBe, _CantBe)
        %and not(MustBe = [])
        %and stdio::writef("We got a synonym for % that must be a % \n", Head, MustBe)
        and matchSynonymPriority(SynType1, P) and matchSynonymType(SynType1, NewHead, WID, 1)
        and db:getWordInfo(WID, _Original, POS, _EType, _Spacy1, _Spacy2)
        %and stdio::writef("At this point POS is % \n", POS)
        and util::matchPOSMustBe([POS], MustBe) and validCompanyDetection(WID, SynType1)
    then
        %stdio::writef("We have % replacing % \n", NewHead, Head),
        if Head = NewHead and SynType1 = "" then
            succeed()
        else
            db:removeWord(SID, WID, WCount, Head, X, Y, Type, TID),
            db:setWord(SID, WID, WCount, NewHead, X, Y, SynType1, TID),
            !,
            db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
            ctx:getActualType(NewHead, SynType1, CType),
            ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X, AID, "", _CMIDOut),
            !
        end if
    elseif db:getSynonym1(_SynonymID, SynType1, NewHead, [Head], [], _CantBe)
        %and stdio::writef("We got there with NewHead = % and Head = % and SynType = %\n", NewHead, Head, SynType1)
        and matchSynonymPriority(SynType1, P) % and stdio::writef("The priority Matches \n")
        and matchSynonymType(SynType1, NewHead, WID, 1)
        %and stdio::writef("The synonymTypes match \n")
        and validCompanyDetection(WID, SynType1)
        %and stdio::writef("We will apply the synonym \n")
        %and (not(Head = NewHead) and (SynType = ""))
    then
        if Head = NewHead and SynType1 = "" then
            succeed()
        else
            %stdio::writef("We are with Priority % and replace % with % and Syntype % \n", P, Head, NewHead, SynType1),
            db:removeWord(SID, WID, WCount, Head, X, Y, Type, TID),
            db:setWord(SID, WID, WCount, NewHead, X, Y, SynType1, TID),
            !,
            % This has been temporarily inhibited as nobody uses the synonymApplied
            %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, Head, X, Y),
            db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
            ctx:getActualType(NewHead, SynType1, CType),
            ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X, AID, "", _CMIDOut),
            !
        end if
    else
        fail()
    end if.
    %stdio::writef("We found % with % replacing % \n", SynType1, NewHead, Head).

synonymSimplified2([WID1, WID2 | Tail], [WID1 | Tail], P) :-
    % this function has been modified on 09/06/2019 to give a priority to the synomyms where MustBe is not []
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    %stdio::writef("Trying % \n", Head1),
    if db:getSynonym2M(SynonymID, SynType2, NewHead, [Head1, Head2], MustBe, _CantBe) and
        %not(MustBe = []) and
        %stdio::writef("We got % % as a synonymM for % with MustBe %\n", Head1, Head2, NewHead, MustBe) and
        matchSynonymPriority(SynType2, P)
        %stdio::writef("We passed matchSynonymPriority for % \n", NewHead) and
        and matchSynonymType(SynType2, NewHead, WID1, 2) and
        %stdio::writef("We passed matchSynonymType for % \n", NewHead) and
        % removed as two words synonyms must be more rarely in error
        %and db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2)
        db:getWordInfo(WID1, Original1, POS1, EType1, Spacy11, Spacy21)
        and ! and db:getWordInfo(WID2, Original2, POS2, _EType2, _Spacy12, Spacy22) and util::matchPOSMustBe([POS1, POS2], MustBe)
        and reinstateValidCompany(NewHead, SynType2)
    then
        %stdio::writef("We found % synonym of % % \n", NewHead, Head1, Head2),
        if Spacy21 = "compound" and util::stringMemberOf(Spacy22, ["nsubj", "ROOT"]) then
            db:removeWordInfo(WID1, Original1, POS1, EType1, Spacy11, Spacy21),
            !,
            db:setWordInfo(WID1, string::concat(Original1, "-", Original2), POS1, EType1, Spacy11, Spacy22)
        else
            db:removeWordInfo(WID1, Original1, POS1, EType1, Spacy11, Spacy21),
            !,
            db:setWordInfo(WID1, string::concat(Original1, "-", Original2), POS1, EType1, Spacy11, Spacy21)
        end if,
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, NewHead, X1, Y2, SynType2, TID1),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType2, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut),
        % This has been temporarily inhibited as nobody uses the synonymApplied
        db:setSynonymApplied(AID, SID, SynonymID, NewHead, string::concat(Head1, " ", Head2), X1, Y2),
        !
        %stdio::writef("We simplified % % into % with Priority %\n", Head1, Head2, NewHead, P)
    elseif db:getSynonym2(SynonymID, SynType2, NewHead, [Head1, Head2], [], _CantBe)
        %and stdio::writef("We got % % as a synonym for % of type % with empty MustBe \n", Head1, Head2, NewHead, SynType2)
        and matchSynonymPriority(SynType2, P)
        %and stdio::writef("We passed matchSynonymPriority for % \n", NewHead)
        and matchSynonymType(SynType2, NewHead, WID1, 2) %and stdio::writef("We passed matchSynonymType for % \n", NewHead)
        % removed as two words synonyms must be more rarely in error
        %and db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2)
        and reinstateValidCompany(NewHead, SynType2)
    then
        db:getWordInfo(WID1, Original1, POS1, EType1, Spacy11, Spacy21),
        !,
        db:getWordInfo(WID2, Original2, POS2, _EType2, _Spacy12, Spacy22),
        %stdio::writef("We found % synonym of % % \n", NewHead, Head1, Head2),
        if Spacy21 = "compound" and util::stringMemberOf(Spacy22, ["nsubj", "ROOT"]) then
            db:removeWordInfo(WID1, Original1, POS1, EType1, Spacy11, Spacy21),
            db:setWordInfo(WID1, string::concat(Original1, "-", Original2), POS1, EType1, Spacy11, Spacy22)
        else
            db:removeWordInfo(WID1, Original1, POS1, EType1, Spacy11, Spacy21),
            db:setWordInfo(WID1, string::concat(Original1, "-", Original2), POS1, EType1, Spacy11, Spacy21)
        end if,
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, NewHead, X1, Y2, SynType2, TID1),
        %stdio::writef("We reinstated % with synType % \n", NewHead, SynType2),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType2, CType),
        %stdio::writef("We will try to assert the contextValue in sentence % \n", NewHead),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut),
        %stdio::writef("We have successfully completed the transformation of % %  into % \n", Head1, Head2, NewHead),
        % This has been temporarily inhibited as nobody uses the synonymApplied
        db:setSynonymApplied(AID, SID, SynonymID, NewHead, string::concat(Head1, " ", Head2), X1, Y2),
        !
        %stdio::writef("We simplified % % into % with Priority %\n", Head1, Head2, NewHead, P)
    elseif db:getWordInfo(WID1, Original1, POS1, "PERSON", _Spacy11, _Spacy21) and not(POS1 = "PUNCT")
        and db:getWordInfo(WID2, Original2, _POS2, "PERSON", _Spacy12, _Spacy22)
    then
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, string::concat(Original1, "_", Original2), X1, Y2, "potential_author", TID1)
    else
        fail()
    end if,
    !.

synonymSimplified3([WID1, WID2, WID3 | Tail], OutputSentence, P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
    %stdio::writef("entering synonymSimplified3 with %, %  \n", Head1, Head2),
    if (db:getSynonym3M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3], MustBe, _CantBe)
            or db:getSynonym3M(_SynonymID, SynType, NewHead, [Head1, "*", Head3], MustBe, _CantBe))
        and matchSynonymPriority(SynType, P)
        %and stdio::writef("We match the priority % \n", P)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23) and util::matchPOSMustBe([POS1, POS2, POS3], MustBe)
        and reinstateValidCompany(NewHead, SynType)
    then
        succeed()
    elseif %stdio::writef("Trying the non M synonyms with Head1 % and Head2 % \n", Head1, Head2)
        (db:getSynonym3(_SynonymID, SynType, NewHead, [Head1, Head2, Head3], _MustBe, _CantBe)
            or db:getSynonym3(_SynonymID, SynType, NewHead, [Head1, "*", Head3], _MustBe, _CantBe))
        and matchSynonymPriority(SynType, P)
        %and stdio::writef("We match the priority % \n", P)
        and reinstateValidCompany(NewHead, SynType)
    then
        succeed()
    else
        fail()
    end if,
    db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:setWord(SID, WID1, WC1, Newhead, X1, Y3, SynType, TID1),
    if db:getSynonym3M(_SynonymIDX, SynType, NewHead, [Head1, "*", Head3], _MustBeX, _CantBeX)
        or db:getSynonym3(_SynonymIDY, SynType, NewHead, [Head1, "*", Head3], _MustBeY, _CantBeY)
    then
        %stdio::writef("We will see if the word % has a meaning \n", Head2),
        if (synonymIfSimplified1([WID2 | Tail], _ZIf, P) or synonymSimplified1([WID2 | Tail], _Z, P)) and ! then
            %stdio::writef("We found a meaning \n"),
            succeed(),
            OutPutSentence = [WID1, WID2 | Tail]
        else
            db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
            OutputSentence = [WID1 | Tail]
        end if
    else
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        OutputSentence = [WID1 | Tail]
    end if,
    db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
    db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
    ctx:getActualType(NewHead, SynType, CType),
    ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut),
    % This has been temporarily inhibited as nobody uses the synonymApplied
    %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concat(Head1, " ", Head2, " ", Head3), X1, Y3)
    !.

/*
synonymSimplified3([WID1, WID2, WID3 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    %stdio::writef("entering synonymSimplified3 with %, %  \n", Head1, Head2),
    if db:getSynonym3M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3], MustBe, _CantBe) and
        % stdio::writef("We also gotM % with SynType % \n", Head3, SynType) and
        matchSynonymPriority(SynType, P)
        and
        %stdio::writef("We match the priority % \n", P) and
        db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        %and stdio::writef("We confirm % \n", Head3)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23) and util::matchPOSMustBe([POS1, POS2, POS3], MustBe)
        and reinstateValidCompany(NewHead, SynType)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y3, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concat(Head1, " ", Head2, " ", Head3), X1, Y3)
    elseif %stdio::writef("Trying the non M synonyms with Head1 % and Head2 % \n", Head1, Head2)
        db:getSynonym3(_SynonymID, SynType, NewHead, [Head1, Head2, Head3], _MustBe, _CantBe)
        and matchSynonymPriority(SynType, P)
        %stdio::writef("We match the priority % \n", P) and
        and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3) and reinstateValidCompany(NewHead, SynType)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, NewHead, X1, Y3, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concat(Head1, " ", Head2, " ", Head3), X1, Y3)
    else
        fail()
    end if,
    !.
*/
synonymSimplified4([WID1, WID2, WID3, WID4 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    %stdio::writef ("entering synonymSimplified4 with %, % \n", Head1, Head2),
    if db:getSynonym4M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4], MustBe, _CantBe) and
        %stdio::writef ("Trying4 % in % with synonym % \n", NewHead, X1, SynonymID),
        matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24) and util::matchPOSMustBe([POS1, POS2, POS3, POS4], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y4, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4]), X1, Y4)
    elseif db:getSynonym4(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4], MustBe, _CantBe) and
        %stdio::writef ("Trying4 % in % with synonym % \n", NewHead, X1, SynonymID),
        matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y4, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4]), X1, Y4)
    else
        fail()
    end if,
    !.

synonymSimplified5([WID1, WID2, WID3, WID4, WID5 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    if db:getSynonym5M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5], MustBe, _CantBe) and matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4)
        and db:getWord(SID, WID5, WC5, Head5, X5, Y5, _Type, TID5) and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25) and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y5, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, _Type5, TID5),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        /*
        assert(
            db:getSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5]), X1,
                Y5))
*/
    elseif db:getSynonym5(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, _Type, TID5)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y5, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, _Type5, TID5),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if,
    !.

synonymSimplified6([WID1, WID2, WID3, WID4, WID5, WID6 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    if db:getSynonym6M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6], MustBe, _CantBe) and
        %stdio::writef("We have found a Synonym6 with % and % and % \n", Head1, Head2, Head3) and
        matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4)
        and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5) and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y6, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6]), X1, Y6))
*/
    elseif db:getSynonym6(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6], MustBe, _CantBe) and
        %stdio::writef("We have found a Synonym6 with % and % and % \n", Head1, Head2, Head3) and
        matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4)
        and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5) and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y6, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if,
    !.

synonymSimplified7([WID1, WID2, WID3, WID4, WID5, WID6, WID7 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    if db:getSynonym7M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and db:getWordInfo(WID7, _Original7, POS7, _EType7, _Spacy17, _Spacy27)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6, POS7], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6, " ", Head7]), X1, Y7))
*/
    elseif db:getSynonym7(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

synonymSimplified8([WID1, WID2, WID3, WID4, WID5, WID6, WID7, WID8 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    if db:getSynonym8(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8) and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and db:getWordInfo(WID7, _Original7, POS7, _EType7, _Spacy17, _Spacy27)
        and db:getWordInfo(WID8, _Original8, POS8, _EType8, _Spacy18, _Spacy28)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6, " ", Head7, " ", Head8]), X1, Y7))
*/
    elseif db:getSynonym8(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if,
    !.

synonymSimplified9([WID1, WID2, WID3, WID4, WID5, WID6, WID7, WID8, WID9 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
    if db:getSynonym9(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8, Head9], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8) and db:getWord(SID, WID9, WC9, Head9, X9, Y9, Type9, TID9)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and db:getWordInfo(WID7, _Original7, POS7, _EType7, _Spacy17, _Spacy27)
        and db:getWordInfo(WID8, _Original8, POS8, _EType8, _Spacy18, _Spacy28)
        and db:getWordInfo(WID9, _Original9, POS9, _EType9, _Spacy19, _Spacy29)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8, POS9], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8),
        db:removeWord(SID, WID9, WC9, Head9, X9, Y9, Type9, TID9),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6, " ", Head7, " ", Head8]), X1, Y7))
*/
    elseif db:getSynonym9(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8, Head9], MustBe, _CantBe)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8) and db:getWord(SID, WID9, WC9, Head9, X9, Y9, Type9, TID9)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC2, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC3, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC4, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC5, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC6, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC7, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC8, Head8, X8, Y8, Type8, TID8),
        db:removeWord(SID, WID9, WC9, Head9, X9, Y9, Type9, TID9),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if,
    !.

synonymIfSimplified1([WID | Tail], [WID | Tail], P) :-
    % TODO: testing the concept that we must try all synonyms with a non [] MustBe before those where MustBe is []
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID, WCount, Head, X, Y, Type, TID),
    % note that the "" was Type before  TODO this is a good question: can a synonym change the type of a word? Or is the choice final?
    %stdio::writef("Trying % for synonymIfIfSimplified1\n", Head),
    if P > 0 and ambiguousSynonym(WID, Head) then
        fail()
    else
        succeed()
    end if,
    if db:getSynonymIf1M(_SynonymIfID, SynIfType, NewIfHead, [Head], MustBeIf, _CantBeIf, ContextIf, ValueIf)
        %and stdio::writef("We match a synonymIf1 and need the % to be % \n", ContextIfN, ValueIf)
        %stdio::writef("The synType is % and the priority is % \n", SynIfType, P) and
        and matchSynonymPriority(SynIfType, P)
        %stdio::writef("We passed the synonymPriority \n") and
        and db:getWordInfo(WID, _Original1, POS1, _EType1, _Spacy11, _Spacy21) and util::matchPOSMustBe([POS1], MustBeIf) and
        %stdio::writef("We have % matching % \n", POS1, MustBeIf) and
        synonymIfApplicable(SID, X, ContextIf, ValueIf)
        %and stdio::writef("The synonym is applicable \n")
    then
        db:removeWord(SID, WID, WCount, Head, X, Y, Type, TID),
        db:setWord(SID, WID, WCount, NewIfHead, X, Y, SynIfType, TID),
        !,
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewIfHead, SynIfType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewIfHead, 100, X, AID, "", _CMIDOut)
        %stdio::writef("We found % with % replacing % \n", SynIfType, NewIfHead, Head)
    elseif db:getSynonymIf1(_SynonymIfID, SynIfType, NewIfHead, [Head], MustBeIf, _CantBeIf, ContextIf, ValueIf)
        %and stdio::writef("We match a synonymIf1 and need the % to be % \n", ContextIfN, ValueIf)
        %stdio::writef("The synType is % and the priority is % \n", SynIfType, P) and
        and matchSynonymPriority(SynIfType, P) and
        %stdio::writef("We passed the synonymPriority \n") and
        %stdio::writef("We have % matching % \n", POS1, MustBeIf) and
        synonymIfApplicable(SID, X, ContextIf, ValueIf)
        %and stdio::writef("The synonym for % with contextIf % value If % is applicable \n", Head, ContextIf, ValueIf)
    then
        db:removeWord(SID, WID, WCount, Head, X, Y, Type, TID),
        db:setWord(SID, WID, WCount, NewIfHead, X, Y, SynIfType, TID),
        !,
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewIfHead, SynIfType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewIfHead, 100, X, AID, "", _CMIDOut)
        %stdio::writef("We found % with % replacing % \n", SynIfType, NewIfHead, Head)
    else
        fail()
    end if.

synonymIfSimplified2([WID1, WID2 | Tail], [WID1 | Tail], P) :-
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2If, X2If, Y2If, Type2If, TID2If),
    %stdio::writef("Trying % \n", Head1),
    if db:getSynonymIf2M(_SynonymIfID, TypeIf, ValueIf, [Head1, Head2If], MustBeIf, _CantBeIf, IfType, IfValue)
        %and stdio::writef("Trying % % with IfType % and IfValue % \n", Head1, Head2If, IfType, IfValue)
        and matchSynonymPriority(TypeIf, P) and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2If, POS2If, _EType2If, _Spacy12If, _Spacy22If) and util::matchPOSMustBe([POS1, POS2If], MustBeIf)
        and synonymIfApplicable(SID, X1, IfType, IfValue) and reinstateValidCompany(ValueIf, TypeIf)
    then
        %stdio::writef("We apply the synonymIf, transforming % % into % \n", Head1, Head2If, ValueIf),
        db:removeWord(SID, WID2, WC1 + 1, Head2If, X2If, Y2If, Type2If, TID2If),
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, ValueIf, X1, Y2If, TypeIf, TID1),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(ValueIf, TypeIf, CType),
        ctx:assertContextValueInSentence(SID, CType, ValueIf, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymIfID, ValueIf, string::concat(Head1, " ", Head2If), X1, Y2)
    elseif db:getSynonymIf2(_SynonymIfID, TypeIf, ValueIf, [Head1, Head2If], MustBeIf, _CantBeIf, IfType, IfValue)
        %and stdio::writef("Trying % % with IfType % and IfValue % \n", Head1, Head2If, IfType, IfValue)
        and matchSynonymPriority(TypeIf, P) and synonymIfApplicable(SID, X1, IfType, IfValue) and reinstateValidCompany(ValueIf, TypeIf)
    then
        %stdio::writef("We apply the synonymIf, transforming % % into % \n", Head1, Head2If, ValueIf),
        db:removeWord(SID, WID2, WC1 + 1, Head2If, X2If, Y2If, Type2If, TID2If),
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, ValueIf, X1, Y2If, TypeIf, TID1),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(ValueIf, TypeIf, CType),
        ctx:assertContextValueInSentence(SID, CType, ValueIf, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymIfID, ValueIf, string::concat(Head1, " ", Head2If), X1, Y2)
    else
        fail()
    end if,
    !.

synonymIfSimplified3([WID1, WID2, WID3 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    %stdio::writef ("entering synonymSimplified3 with %, %  \n", Head1, Head2),
    if db:getSynonymIf3M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23) and util::matchPOSMustBe([POS1, POS2, POS3], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y3, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concat(Head1, " ", Head2, " ", Head3), X1, Y3)
    elseif db:getSynonymIf3(_SynonymID, SynType, NewHead, [Head1, Head2, Head3], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y3, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if,
    !.

synonymIfSimplified4([WID1, WID2, WID3, WID4 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    %stdio::writef ("entering synonymSimplified4 with %, % \n", Head1, Head2),
    if db:getSynonymIf4M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4], MustBe, _CantBe, _TypeIf, _ValueIf) and
        %stdio::writef ("Trying4 % in % with synonym % \n", NewHead, X1, SynonymID),
        matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24) and util::matchPOSMustBe([POS1, POS2, POS3, POS4], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y4, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        %db:setSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4]), X1, Y4)
    elseif db:getSynonymIf4(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4], MustBe, _CantBe, _TypeIf, _ValueIf) and
        %stdio::writef ("Trying4 % in % with synonym % \n", NewHead, X1, SynonymID),
        matchSynonymPriority(SynType, P)
        and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3) and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y4, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

synonymIfSimplified5([WID1, WID2, WID3, WID4, WID5 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    if db:getSynonymIf5M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, _Type, TID5)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25) and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y5, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, _Type5, TID5),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        % This has been temporarily inhibited as nobody uses the synonymApplied
        /*
        assert(
            db:getSynonymApplied(ArticleID, SID, SynonymID, NewHead, string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5]), X1,
                Y5))
*/
    elseif db:getSynonymIf5(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, _Type, TID5)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y5, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, _Type5, TID5),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

synonymIfSimplified6([WID1, WID2, WID3, WID4, WID5, WID6 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    if db:getSynonymIf6M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y6, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6]), X1, Y6))
*/
    elseif db:getSynonymIf6(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, NewHead, X1, Y6, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

synonymIfSimplified7([WID1, WID2, WID3, WID4, WID5, WID6, WID7 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    if db:getSynonymIf7M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and db:getWordInfo(WID7, _Original7, POS7, _EType7, _Spacy17, _Spacy27)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6, POS7], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6, " ", Head7]), X1, Y7))
*/
    elseif db:getSynonymIf7(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7], MustBe, _CantBe, _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y7, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

synonymIfSimplified8([WID1, WID2, WID3, WID4, WID5, WID6, WID7, WID8 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    if db:getSynonymIf8M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8], MustBe, _CantBe, _TypeIf,
            _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8) and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and db:getWordInfo(WID7, _Original7, POS7, _EType7, _Spacy17, _Spacy27)
        and db:getWordInfo(WID8, _Original8, POS8, _EType8, _Spacy18, _Spacy28)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y8, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6, " ", Head7, " ", Head8]), X1, Y8))
*/
    elseif db:getSynonymIf8(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8], MustBe, _CantBe, _TypeIf,
            _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y8, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

synonymIfSimplified9([WID1, WID2, WID3, WID4, WID5, WID6, WID7, WID8, WID9 | Tail], [WID1 | Tail], P) :-
    db:getArticle(_ArticleID, _ContextID, _Date, _Author, _TitleSentence, _Paragraphs),
    db:getWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
    db:getWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
    if db:getSynonymIf9M(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8, Head9], MustBe, _CantBe, _TypeIf,
            _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8) and db:getWord(SID, WID9, WC1 + 8, Head9, X9, Y9, Type9, TID9)
        and db:getWordInfo(WID1, _Original1, POS1, _EType1, _Spacy11, _Spacy21)
        and db:getWordInfo(WID2, _Original2, POS2, _EType2, _Spacy12, _Spacy22)
        and db:getWordInfo(WID3, _Original3, POS3, _EType3, _Spacy13, _Spacy23)
        and db:getWordInfo(WID4, _Original4, POS4, _EType4, _Spacy14, _Spacy24)
        and db:getWordInfo(WID5, _Original5, POS5, _EType5, _Spacy15, _Spacy25)
        and db:getWordInfo(WID6, _Original6, POS6, _EType6, _Spacy16, _Spacy26)
        and db:getWordInfo(WID7, _Original7, POS7, _EType7, _Spacy17, _Spacy27)
        and db:getWordInfo(WID8, _Original8, POS8, _EType8, _Spacy18, _Spacy28)
        and db:getWordInfo(WID9, _Original9, POS9, _EType9, _Spacy19, _Spacy29)
        and util::matchPOSMustBe([POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8, POS9], MustBe)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y8, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8),
        db:removeWord(SID, WID9, WC1 + 8, Head9, X9, Y9, Type9, TID9),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
        /*          % This has been temporarily inhibited as nobody uses the synonymApplied
        assert(
            synonymApplied(ArticleID, SID, SynonymID, NewHead,
                string::concatList([Head1, " ", Head2, " ", Head3, " ", Head4, " ", Head5, " ", Head6, " ", Head7, " ", Head8]), X1, Y8))
*/
    elseif db:getSynonymIf9(_SynonymID, SynType, NewHead, [Head1, Head2, Head3, Head4, Head5, Head6, Head7, Head8, Head9], MustBe, _CantBe,
            _TypeIf, _ValueIf)
        and matchSynonymPriority(SynType, P) and db:getWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3)
        and db:getWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4) and db:getWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5)
        and db:getWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6) and db:getWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7)
        and db:getWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8) and db:getWord(SID, WID9, WC1 + 8, Head9, X9, Y9, Type9, TID9)
    then
        db:removeWord(SID, WID1, WC1, Head1, X1, Y1, Type1, TID1),
        db:setWord(SID, WID1, WC1, Newhead, X1, Y8, SynType, TID1),
        db:removeWord(SID, WID2, WC1 + 1, Head2, X2, Y2, Type2, TID2),
        db:removeWord(SID, WID3, WC1 + 2, Head3, X3, Y3, Type3, TID3),
        db:removeWord(SID, WID4, WC1 + 3, Head4, X4, Y4, Type4, TID4),
        db:removeWord(SID, WID5, WC1 + 4, Head5, X5, Y5, Type5, TID5),
        db:removeWord(SID, WID6, WC1 + 5, Head6, X6, Y6, Type6, TID6),
        db:removeWord(SID, WID7, WC1 + 6, Head7, X7, Y7, Type7, TID7),
        db:removeWord(SID, WID8, WC1 + 7, Head8, X8, Y8, Type8, TID8),
        db:removeWord(SID, WID9, WC1 + 8, Head9, X9, Y9, Type9, TID9),
        db:getSentence(AID, _PID, SID, _CIDS, _PosInP, _Sentence),
        ctx:getActualType(NewHead, SynType, CType),
        ctx:assertContextValueInSentence(SID, CType, NewHead, 100, X1, AID, "", _CMIDOut)
    else
        fail()
    end if.

replaceTypeInSynonym(Marker, OldType, Type) :-
    %stdio::writef("We are going to replace synonyms of % from type % to type % \n", Marker, OldType, Type),
    db:getSynonym1(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    %stdio::writef("changing the type % of % into % \n", OldType, Marker, Type),
    db:removeSynonym1(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:setSynonym1(SynonymID, Type, Marker, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym2(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    %stdio::writef("changing the type % of % into % \n", OldType, Marker, Type),
    db:removeSynonym2(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:setSynonym2(SynonymID, Type, Marker, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym3(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:removeSynonym3(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:setSynonym3(SynonymID, Type, Marker, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym4(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:removeSynonym4(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:setSynonym4(SynonymID, Type, Marker, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym5(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:removeSynonym5(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:setSynonym5(SynonymID, Type, Marker, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym6(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:removeSynonym6(SynonymID, OldType, Marker, Wording, MustBe, CantBe),
    db:setSynonym6(SynonymID, Type, Marker, Wording, MustBe, CantBe),
    fail()
    or
    succeed().

replaceTargetInSynonym(CTMarker, NewValue) :-
    db:getSynonym1(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:removeSynonym1(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:setSynonym1(SynonymID, Type, NewValue, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym2(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:removeSynonym2(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:setSynonym2(SynonymID, Type, NewValue, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym3(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:removeSynonym3(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:setSynonym3(SynonymID, Type, NewValue, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym4(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:removeSynonym4(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:setSynonym4(SynonymID, Type, NewValue, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym5(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:removeSynonym5(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:setSynonym5(SynonymID, Type, NewValue, Wording, MustBe, CantBe),
    fail()
    or
    db:getSynonym6(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:removeSynonym6(SynonymID, Type, CTMarker, Wording, MustBe, CantBe),
    db:setSynonym6(SynonymID, Type, NewValue, Wording, MustBe, CantBe),
    fail()
    or
    succeed().
/*
synonymIfApplicable(SID, X1, IfType, IfValue) :-
    %stdio::writef("We are entering synonymIfApplicable with IfType = % and IfValue = % \n", IfType, IfValue),
    transformTypeForSynonymIf(IfType, FinalIfType),
    %stdio::writef("We have the final IfType % \n", FinalIfType),
    db:getContextValue(SID, "Article", FinalIfType, X1, CValue, _CFP, _CPriority, _CScope),
    %stdio::writef("The context for % is % \n", FinalIfType, CValue),
    if synonymIfMatchingContexts(FinalIfType, IfValue, CValue) then
        succeed()
    else
        fail()
    end if.
*/
%getContextMention(CMID1, AID, PID1, SID1, CType, Value1, FP1, Priority1, Scope1, Dep1, _FatherID1),

synonymIfApplicable(SID, X1, IfType, IfValue) :-
    %stdio::writef("We are entering synonymIfApplicable with IfType = % and IfValue = % \n", IfType, IfValue),
    db:getSentence(AID, _PID, SID, _CID, _PosInP, _Sentence),
    transformTypeForSynonymIf(IfType, FinalIfType),
    %stdio::writef("We have the final IfType % \n", FinalIfType),
    %db:getContextValue(SID, "Article", FinalIfType, X1, CValue, _CFP, _CPriority, _CScope),
    if db:getContextMention(_CMID1, AID, _PID1, _SID1, FinalIfType, CValue, FP1, _Priority1, _Scope1, _Dep1, _FatherID1) and FP1 < X1 + 30
        and FP1
            > X1 - 2000 %and stdio::writef("The context for % is % at % \n", FinalIfType, CValue, FP1)
        and synonymIfMatchingContexts(FinalIfType, IfValue, CValue)
    then
        succeed(),
        !
    else
        fail()
    end if.

synonymIfMatchingContexts(FinalIfType, IfValue, CValue) :-
    if IfValue = CValue then
        succeed()
    elseif FinalIfType = "Industry" then
        if db:getIndustryGroup(_IGID, CValue, UpperIndusID, _CType, _Ticker, _Industries, _DNode) and not(UpperIndusID = "")
            and db:getIndustryGroup(UpperIndusID, CUpperValue, _UpperIndusID1, _CType1, _Ticker1, _Industries1, _DNode1)
        then
            if CUpperValue = IfValue then
                succeed()
            else
                synonymIfMatchingContexts(FinalIfType, IfValue, CupperValue)
            end if
        else
            fail()
        end if
    elseif FinalIfType = "Company" then
        if db:getCompanyGroup(_CGID, CValue, UpperCyID, _CType, _Ticker, _Industries, _DNode) and not(UpperCyID = "")
            and db:getCompanyGroup(UpperCyID, CUpperValue, _UpperCyID1, _CType1, _Ticker1, _Industries1, _DNode1)
        then
            if CUpperValue = IfValue then
                succeed()
            else
                synonymIfMatchingContexts(FinalIfType, IfValue, CupperValue)
            end if
        else
            fail()
        end if
    else
        fail()
    end if.
