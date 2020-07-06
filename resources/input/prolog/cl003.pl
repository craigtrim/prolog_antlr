    analyzeLooseValues1(SID, VOID, ENID1) :-
        %stdio::writef ("entering analyzeLooseValues1 for % \n", SID),
        % +2% for USO today
        % $14.5 for USO today
        % USO at $12.43 today from $11.2 yesterday
        % USO + 5% today at $12.43
        % USO + 5% today at $14.5 from $12.0 a week ago
        %TODO: make sure that some implicit trends are detected even when there is no trendMarker,
        % because we have value/en1/en2 where en1 has prep "from" and en2 has prep "to"
        %db:getThisToday(_Today),
        db:getValueMention(VOID, SID, FP, LP, _WID, _WIDWord, _ValueValue, _Min, _Max, _Date, Unit, _ValueSpan, _Future),
        %!,
        %stdio::writef ("we found the VO % in analyzeLooseValues1 \n", WIDWord),
        db:getExplicitNumber(SID, ENID1, _Prepos1, Number1, Percentage1, _Unit1, FP1, LP1, _Span1, "", "", _Date1, _FlagP1),
        not(db:getRelated(ENID1, VOID)),
        (not(Number1 = "") or not(Percentage1 = "")),
        %stdio::writef("We are trying to match % % with unit % and % with unit % and preposition %\n", VOID, WIDWord, Unit, Number1, Unit1, Prepos1),
        %stdio::writef ("We are checking the positions of % ( % - %) vs % (% - %) \n", VOID, FP, LP, ENID1, FP1, LP1),
        if FP1 < FP and LP1 > LP
            % the case where the EN covers entirely the VO
        then
            %stdio::writef("********* We related % and % \n", ENID1, VOID),
            if not(Number1 = "") then
                db:setRelated(ENID1, VOID),
                findMoreLooseValues(VOID, ENID1, LP, ENIDList)
            elseif Unit = "percent" then
                db:setRelated(ENID1, VOID),
                findMoreLooseValues(VOID, ENID1, LP, ENIDList)
            else
                db:setRelated(ENID1, VOID),
                findMoreLooseValues(VOID, ENID1, LP, ENIDList)
            end if
        elseif FP1 - 50 < FP and FP1 > FP - 1
            or FP - 50 < FP1
            and FP1
                < FP + 1
                    %, stdio::writef("The case where the EN is before or after the VM \n")
                    % the case there the EN is after the VO and not too far
        then
            % this means we cannot find a VO and an EN which are not related and should
            % we check the units
            if not(Number1 = "") then
                findMoreLooseValues(VOID, ENID1, LP, ENIDList),
                db:setRelated(ENID1, VOID)
                %stdio::writef("We related % between % and % with %\n", ENID1, FP1, LP1, VOID)
                %stdio::writef("We might have to check this case where the EN is a percentage\n"),
            elseif Unit = "percent" then
                db:setRelated(ENID1, VOID),
                findMoreLooseValues(VOID, ENID1, LP, ENIDList)
            else
                db:setRelated(ENID1, VOID),
                findMoreLooseValues(VOID, ENID1, LP, ENIDList)
            end if
        else
            %stdio::writef("This is the case where the EN is before the VM\n"),
            fail()
        end if,
        %stdio::writef ("Entering takeCareofLooseValues from the end of AnalyzeLoosevalues1 \n"),
        takeCareOfLooseValues(VOID, ENID1, ENIDList).
