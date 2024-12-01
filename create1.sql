DROP TABLE IF EXISTS Committee;

CREATE TABLE Committee (
    comID INTEGER NOT NULL UNIQUE,
    comName TEXT NOT NULL,
    comAcronym TEXT NOT NULL UNIQUE,
    PRIMARY KEY (comID)
);

DROP TABLE IF EXISTS Person;

CREATE TABLE Person (
    pID INTEGER NOT NULL UNIQUE,
    pName TEXT NOT NULL,
    pGender TEXT NOT NULL CHECK (pGender IN ('M', 'F')),
    pNationality TEXT NOT NULL,
    pBirthdate DATE NOT NULL CHECK (pBirthdate < DATE('2024-12-01')),
    pAge INTEGER GENERATED ALWAYS AS (CAST((JULIANDAY('2024-12-01') - JULIANDAY(pBirthdate)) / 365.25 AS INTEGER)),
    PRIMARY KEY (pID),
    FOREIGN KEY (pID) REFERENCES Committee(comID)
);

DROP TABLE IF EXISTS Stage;

CREATE TABLE Stage (
    sID INTEGER NOT NULL UNIQUE,
    vID INTEGER NOT NULL,
    adID INTEGER NOT NULL,
    sName TEXT NOT NULL,
    sNumHeat INTEGER,
    sDate DATE NOT NULL CHECK (sDate < DATE('2024-12-01')),
    PRIMARY KEY (sID),
    FOREIGN KEY (vID) REFERENCES Venue(vID),
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID)
);

DROP TABLE IF EXISTS Athlete;

CREATE TABLE Athlete (
    aID INTEGER NOT NULL UNIQUE,
    aHeight REAL NOT NULL CHECK (aHeight > 0),
    aWeight REAL NOT NULL CHECK (aWeight > 0),
    aBMI REAL GENERATED ALWAYS AS (aWeight / (aHeight * aHeight)),
    PRIMARY KEY (aID),
    FOREIGN KEY (aID) REFERENCES Person(pID)
);

DROP TABLE IF EXISTS StageAthlete;

CREATE TABLE StageAthlete (
    sID INTEGER NOT NULL,
    aID INTEGER NOT NULL,
    PRIMARY KEY (sID, aID),
    FOREIGN KEY (sID) REFERENCES Stage(sID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID)
);

DROP TABLE IF EXISTS Coach;

CREATE TABLE Coach (
    cID INTEGER NOT NULL UNIQUE,
    cRole TEXT NOT NULL CHECK (cRole IN ('Head', 'Assistant', '2nd Assistant')),
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Person(pID)
);

DROP TABLE IF EXISTS CoachAthlete;

CREATE TABLE CoachAthlete (
    aID INTEGER NOT NULL,
    cID INTEGER NOT NULL,
    PRIMARY KEY (aID, cID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID),
    FOREIGN KEY (cID) REFERENCES Coach(cID)
);

DROP TABLE IF EXISTS AthleticDiscipline;

CREATE TABLE AthleticDiscipline (
    adID INTEGER NOT NULL UNIQUE,
    adName TEXT NOT NULL,
    adGenderCategory TEXT NOT NULL CHECK (adGenderCategory IN ('M', 'F', 'Mixed')),
    PRIMARY KEY (adID)
);

DROP TABLE IF EXISTS CoachAthleticDiscipline;

CREATE TABLE CoachAthleticDiscipline (
    cID INTEGER NOT NULL,
    adID INTEGER NOT NULL,
    PRIMARY KEY (cID, adID),
    FOREIGN KEY (cID) REFERENCES Coach(cID),
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID)
);

DROP TABLE IF EXISTS Medal;

CREATE TABLE Medal (
    mID INTEGER NOT NULL UNIQUE,
    comID INTEGER NOT NULL,
    aID INTEGER NOT NULL,
    adID INTEGER NOT NULL,
    mType TEXT NOT NULL CHECK (mType IN ('Gold', 'Silver', 'Bronze')),
    PRIMARY KEY (mID),
    FOREIGN KEY (comID) REFERENCES Committee(comID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID),
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID)
);

DROP TABLE IF EXISTS Venue;

CREATE TABLE Venue (
    vID INTEGER NOT NULL UNIQUE,
    vName TEXT NOT NULL,
    vCity TEXT NOT NULL,
    vCapacity INTEGER NOT NULL CHECK (vCapacity >= 0),
    PRIMARY KEY (vID)
);

DROP TABLE IF EXISTS Result;

CREATE TABLE Result (
    aID INTEGER NOT NULL,
    sID INTEGER NOT NULL,
    rPosition INTEGER NOT NULL CHECK (rPosition > 0),
    rTime REAL CHECK (rTime >= 0),
    rDistance REAL CHECK (rDistance >= 0),
    PRIMARY KEY (aID, sID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID),
    FOREIGN KEY (sID) REFERENCES Stage(sID),
    CHECK ((rTime IS NOT NULL AND rDistance IS NULL) OR (rTime IS NULL AND rDistance IS NOT NULL))
);

DROP TABLE IF EXISTS Record;

CREATE TABLE Record (
    rID INTEGER NOT NULL UNIQUE,
    adID INTEGER NOT NULL,
    aID INTEGER NOT NULL,
    rType TEXT NOT NULL CHECK (rType IN ('World', 'Olympic')),
    rDate DATE NOT NULL CHECK (rDate < DATE('2024-12-01')),
    rLocation TEXT NOT NULL,
    PRIMARY KEY (rID),
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID)
);

DROP TABLE IF EXISTS OldRecord;

CREATE TABLE OldRecord (
    orID INTEGER UNIQUE,
    orTime REAL CHECK (orTime >= 0),
    orDistance REAL CHECK (orDistance >= 0),
    PRIMARY KEY (orID),
    CHECK ((orTime IS NOT NULL AND orDistance IS NULL) OR (orTime IS NULL AND orDistance IS NOT NULL))
);

DROP TABLE IF EXISTS NewRecord;

CREATE TABLE NewRecord (
    nrID INTEGER NOT NULL UNIQUE ,
    aID INTEGER NOT NULL,
    sID INTEGER NOT NULL,
    PRIMARY KEY (nrID),
    FOREIGN KEY (aID, sID) REFERENCES Result(aID, sID)
);