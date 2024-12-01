PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

.read create2.sql

-- The data below is mostly fictional and should not be taken as a source of information.
-- It is a mere demonstration of this database capacity!

-- Insert into Committee
INSERT INTO Committee (comID, comName, comAcronym) VALUES
    (001, 'United States Olympic Committee', 'USA'),
    (002, 'Russian Olympic Committee', 'RUS'),
    (003, 'Chinese Olympic Committee', 'CHN');

-- Insert into Person
INSERT INTO Person (pID, pName, pGender, pNationality, pBirthdate, comID) VALUES
    --athletes
    (001, 'John Doe', 'M', 'USA', '1990-05-20', 1),         --USA
    (002, 'Jane Smith', 'F', 'RUS', '1992-09-15', 2),       --RUS
    (003, 'Ling Wei', 'F', 'CHN', '1998-03-10', 3),         --CHN
    --coaches
    (004, 'Michael Jackson', 'M', 'USA', '1970-09-13', 1),  --USA
    (005, 'Olga Kuznetsova', 'F', 'RUS', '1975-11-25', 2),  --RUS
    (006, 'Chen Wei', 'M', 'CHN', '1980-07-30', 3);         --CHN

-- Insert into Athlete
INSERT INTO Athlete (aID, aHeight, aWeight) VALUES
    (001, 1.85, 75.0),          --John Doe
    (002, 1.70, 60.0),          --Jane Smith
    (003, 1.68, 55.0);          --Ling Wei

-- Insert into Coach
INSERT INTO Coach (cID, cRole) VALUES
    (004, 'Head'),                      --Michael Jackson
    (005, 'Assistant'),                 --Olga Kuznetsova
    (006, '2nd Assistant');             --Chen Wei

-- Insert into Venue
INSERT INTO Venue (vID, vName, vCity, vCapacity) VALUES
    (001, 'Olympic Stadium', 'Paris', 68000),
    (002, 'National Athletics Center', 'Versailles', 17000),
    (003, 'Luzhniki Stadium', 'Paris', 81000);

-- Insert into AthleticDiscipline
INSERT INTO AthleticDiscipline (adID, adName, adGenderCategory) VALUES
    (001, '100m Sprint', 'M'),
    (002, '200m Sprint', 'F'),
    (003, '4x100m Relay', 'Mixed'),
    (004, 'Long Jump', 'M');

-- Insert into Stage
INSERT INTO Stage (sID, vID, adID, sName, sNumHeat, sDate) VALUES
    (001, 001, 001, '100m Sprint Final', NULL, '2024-07-28'),   --venue: Olympic Stadium; athletic discipline: 100m Sprint
    (002, 002, 002, '200m Sprint Final', NULL, '2024-07-30'),   --venue: National Athletics Center; athletic discipline: 200m Sprint
    (003, 003, 003, '4x100m Relay Heats', 4, '2024-08-01'),     --venue: Luzhniki Stadium; athletic discipline: 4x100m Relay
    (004, 002, 004, 'Long Jump Final', NULL, '2024-08-02');     --venue: National Athletics Center; athletic discipline: 4x100m Relay

-- Insert into Medal
INSERT INTO Medal (mID, comID, aID, adID, mType) VALUES
    (001, 001, 001, 001, 'Gold'),       --committee: USA; athlete: John Doe; athletic discipline: 100m Sprint
    (002, 002, 002, 002, 'Gold'),       --committee: RUS; athlete: Jane Smith; athletic discipline: 200m Sprint
    (003, 003, 003, 003, 'Gold'),       --committee: CHN; athlete: Ling Wei; athletic discipline: 4x100m Relay
    (004,001,001,004,'Gold');           --committee: USA; athlete: John Doe; athletic discipline: Long Jump

-- Insert into Result
INSERT INTO Result (aID, sID, rPosition, rTime, rDistance) VALUES
    (001, 001, 1, 9.85, NULL),      --athlete: John Doe; stage: 100m Sprint Final
    (002, 002, 1, 21.45, NULL),     --athlete: Jane Smith; stage: 200m Sprint Final
    (003, 003, 1, 13.46, NULL),     --athlete: Ling Wei; stage: 4x100m Relay Heats
    (001, 004, 1, NULL, 8.50);      --athlete: John Doe; stage: Long Jump Final

-- Insert into Record
INSERT INTO Record (rID, adID, aID, rType, rDate, rLocation) VALUES
    --old records
    (001, 001, 001, 'Olympic', '2004-07-28', 'Paris'),          --athletic discipline: 100m Sprint; athlete: John Doe
    (002, 002, 002, 'Olympic', '2017-07-30', 'Beijing'),        --athletic discipline: 200m Sprint; athlete: Jane Smith
    --new records
    (003, 003, 003, 'World', '2024-08-01', 'Paris'),            --athletic discipline: 4x100m Relay; athlete: Ling Wei
    (004, 004, 001, 'Olympic', '2024-08-02', 'Versailles');     --athletic discipline: Long Jump; athlete: John Doe

-- Insert into OldRecord
INSERT INTO OldRecord (orID, orTime, orDistance) VALUES
    (001, 8.50, NULL),
    (002, 13.50, NULL);

-- Insert into NewRecord
INSERT INTO NewRecord (nrID, aID, sID) VALUES
    (003, 003, 003),                    --athlete: Ling Wei; stage: 4x100m Relay Heats
    (004,004,004);                      --athlete: John Doe; stage: Long Jump Final     --these are references (composite key) to the Result table to be able to take its attributes

-- Insert into StageAthlete
INSERT INTO StageAthlete (sID, aID) VALUES
    (001, 001),                         --athlete: John Doe; stage: 100m Sprint Final
    (002, 002),                         --athlete: Jane Smith; stage: 200m Sprint Final
    (003, 003),                         --athlete: Ling Wei; stage: 4x100m Relay Heats
    (004,001);                          --athlete: John Doe; stage: Long Jump Final

-- Insert into CoachAthlete
INSERT INTO CoachAthlete (aID, cID) VALUES
    (001, 004),                         --athlete: John Doe; coach: Michael Jackson
    (002, 005),                         --athlete: Jane Smith; coach: Olga Kuznetsova
    (003, 006);                         --athlete: Ling Wei; coach: Chen Wei

-- Insert into CoachAthleticDiscipline
INSERT INTO CoachAthleticDiscipline (cID, adID) VALUES
    (004, 001),                                 --coach: Michael Jackson; athletic discipline:
    (005, 002),                                 --coach: Olga Kuznetsova; athletic discipline:
    (006, 003),                                 --coach: Chen Wei; athletic discipline:                                                                                              --Link a coach to the new discipline

-- Insert into AthleteAthleticDiscipline
INSERT INTO AthleteAthleticDiscipline (aID, adID) VALUES
    (001, 001),                                     --athlete: John Doe; athletic discipline: 100m Sprint;
    (002, 002),                                     --athlete: Jane Smith; athletic discipline: 200m Sprint
    (003, 003),                                     --athlete: Ling Wei; athletic discipline: 4x100m Relay
    (001, 004);                                     --athlete: John Do; athletic discipline: Long Jump                                                                                            -- Link athlete to the new discipline

COMMIT;