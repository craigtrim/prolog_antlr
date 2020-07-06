loadAllFiles() :-
    db:getCurrentDirectory(Directory),
    db:reconsult(string::concatList([Directory, "\\KB\\settings.txt"])),
    db:printTrace("Loaded settings.txt", 1),
    %stdIO::writef("Current Directory: % \n", Directory),
    db:reconsult(string::concatList([Directory, "\\KB\\server.txt"])),
    db:printTrace("Loaded server.txt", 1),
    db:reconsult(string::concatList([Directory, "\\KB\\local.txt"])),
    db:printTrace("Loaded local.txt", 1),
    db:reconsult(string::concatList([Directory, "\\KB\\patterns.txt"])),
    checkPatternsCoherence(),
    db:printTrace("Loaded patterns.txt", 1),
    if db:getSCMFlag("On") then
        /*
        db:reconsult(string::concatList([Directory, "\\KB\\airbusCompaniesSimpleTest.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\safranSegmentsSimpleTest.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\factoriesSimpleTest.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\airbusBOMSimpleTest.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\airbusRelationshipsSimpleTest.txt"]))
*/
        db:reconsult(string::concatList([Directory, "\\KB\\airbusCompanies.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\safranSegments.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\factories.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\airbusBOM.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\newnewAirbusRelationships.txt"])),
        db:reconsult(string::concatList([Directory, "\\KB\\OrphanSafranSegments.txt"]))
    else
        succeed()
    end if,
    loadNewText(),
    db:printTrace("Loaded new text", 1).
