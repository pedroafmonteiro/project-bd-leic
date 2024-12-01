PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

.read create2.sql

-- Insert into Committee
INSERT INTO Committee (comID, comName, comAcronym) VALUES
    (1, 'United States Olympic Committee', 'USA'),
    (2, 'Russian Olympic Committee', 'RUS'),
    (3, 'Chinese Olympic Committee', 'CHN');

-- Insert into Person
INSERT INTO Person (pID, pName, pGender, pNationality, pBirthdate, comID) VALUES
    (01, 'John Doe', 'M', 'USA', '1990-05-20', 1),
    (02, 'Jane Smith', 'F', 'RUS', '1992-09-15', 2),
    (03, 'Ling Wei', 'F', 'CHN', '1998-03-10', 3), --athletes
    (04, 'Michael Johnson', 'M', 'USA', '1970-09-13', 1),
    (05, 'Olga Kuznetsova', 'F', 'RUS', '1975-11-25', 2),
    (06, 'Chen Wei', 'M', 'CHN', '1980-07-30', 3); --coaches
    
-- Insert into Athlete
INSERT INTO Athlete (aID, aHeight, aWeight, aBMI) VALUES
    (01, 1.85, 75.0, aBMI(aHeight, aWeight)),
    (02, 1.70, 60.0, aBMI(aHeight, aWeight)),
    (03, 1.68, 55.0, aBMI(aHeight, aWeight));

-- Insert into Coach
INSERT INTO Coach (cID, cRole) VALUES
    (04, 'Head'),
    (05, 'Assistant'),
    (06, '2nd Assistant');

-- Insert into Venue
INSERT INTO Venue (vID, vName, vCity, vCapacity) VALUES
    (001, 'Olympic Stadium', 'Paris', 68000),
    (002, 'National Aquatics Center', 'Versailles', 17000),
    (003, 'Luzhniki Stadium', 'Paris', 81000);

-- Insert into AthleticDiscipline
INSERT INTO AthleticDiscipline (adID, adName, adGenderCategory) VALUES
    (0001, '100m Sprint', 'M'),
    (0002, '200m Sprint', 'F'),
    (0003, '4x100m Relay', 'Mixed');

-- Insert into Stage
INSERT INTO Stage (sID, vID, adID, sName, sNumHeat, sDate) VALUES
    (00001, 001, 0001, '100m Sprint Final', NULL, '2024-07-28'),
    (00002, 002, 0002, '200m Sprint Final', NULL, '2024-07-30'),
    (00003, 003, 0003, '4x100m Relay Heats', 4, '2024-08-01');

-- Insert into Medal
INSERT INTO Medal (mID, comID, aID, adID, mType) VALUES
    (000001, 1, 01, 0001, 'Gold'),
    (000002, 2, 02, 0002, 'Gold'),
    (000003, 3, 03, 0003, 'Gold');

-- Insert into Result
INSERT INTO Result (aID, sID, rPosition, rTime, rDistance) VALUES
    (01, 00001, 1, 9.85, NULL),
    (02, 00002, 1, 21.45, NULL),
    (03, 00003, 1, 13.46, NULL);

-- Insert into Record
INSERT INTO Record (rID, adID, aID, rType, rDate, rLocation) VALUES ---MUDAR AQUI
    (000001, 0001, 01, 'Olympic', '2004-07-28', 'Paris'), 
    (000002, 0002, 02, 'Olympic', '2017-07-30', 'Beijing'), --old records
    (000003, 0003, 03, 'World', '2024-08-01', 'Paris'); --new record

-- Insert into OldRecord
INSERT INTO OldRecord (orID, orTime, orDistance) VALUES
    (000001, 8.50, NULL),
    (000002, 13.50, NULL);

-- Insert into NewRecord
INSERT INTO NewRecord (nrID, aID, sID) VALUES
    (000003, 03, 00003);

-- Insert into StageAthlete
INSERT INTO StageAthlete (sID, aID) VALUES
    (00001, 01),
    (00002, 02),
    (00003, 03);

-- Insert into CoachAthlete
INSERT INTO CoachAthlete (aID, cID) VALUES
    (04, 01),
    (05, 02),
    (06, 03);

-- Insert into CoachAthleticDiscipline
INSERT INTO CoachAthleticDiscipline (cID, adID) VALUES
    (04, 0001),
    (05, 0002),
    (06, 0003);

-- Insert into AthleteAthleticDiscipline
INSERT INTO AthleteAthleticDiscipline (aID, adID) VALUES
    (01, 0001),
    (02, 0002),
    (03, 0003);

COMMIT;