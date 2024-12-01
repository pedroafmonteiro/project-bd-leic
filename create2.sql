DROP TABLE IF EXISTS Committee;

-- Table: Committee
-- Description: Represents a committee that normally represents a country in the Olympic Games.
CREATE TABLE Committee (
    comID INTEGER NOT NULL UNIQUE, -- Unique identifier for the committee.
    comName TEXT NOT NULL, -- Name of the committee.
    comAcronym TEXT NOT NULL UNIQUE, -- Acronym of the committee.
    PRIMARY KEY (comID)
);

DROP TABLE IF EXISTS Person;

-- Table: Person
-- Description: Represents a person that can be an athlete or a coach of a committee.
CREATE TABLE Person (
    pID INTEGER NOT NULL UNIQUE, -- Unique identifier for the person.
    pName TEXT NOT NULL, -- Name of the person.
    pGender TEXT NOT NULL CHECK (pGender IN ('M', 'F')), -- Gender of the person.
    pNationality TEXT NOT NULL, -- Nationality of the person.
    pBirthdate DATE NOT NULL CHECK (pBirthdate < DATE('2024-12-01')), -- Birthdate of the person.
    pAge INTEGER GENERATED ALWAYS AS (CAST((JULIANDAY('2024-12-01') - JULIANDAY(pBirthdate)) / 365.25 AS INTEGER)), -- Age of the person.
    PRIMARY KEY (pID),
    FOREIGN KEY (pID) REFERENCES Committee(comID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Stage;

-- Table: Stage
-- Description: Represents a stage of an athletic discipline in a venue.
CREATE TABLE Stage (
    sID INTEGER NOT NULL UNIQUE, -- Unique identifier for the stage.
    vID INTEGER NOT NULL, -- Identifier of the venue where the stage is held.
    adID INTEGER NOT NULL, -- Identifier of the athletic discipline of the stage.
    sName TEXT NOT NULL, -- Name of the stage.
    sNumHeat INTEGER, -- Number of heats in the stage (can be null).
    sDate DATE NOT NULL CHECK (sDate < DATE('2024-12-01')), -- Date of the stage.
    PRIMARY KEY (sID),
    FOREIGN KEY (vID) REFERENCES Venue(vID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Athlete;

-- Table: Athlete
-- Description: Represents an athlete that can participate in the Olympic Games.
CREATE TABLE Athlete (
    aID INTEGER NOT NULL UNIQUE, -- Unique identifier for the athlete.
    aHeight REAL NOT NULL CHECK (aHeight > 0), -- Height of the athlete.
    aWeight REAL NOT NULL CHECK (aWeight > 0), -- Weight of the athlete.
    aBMI REAL GENERATED ALWAYS AS (aWeight / (aHeight * aHeight)), -- Body Mass Index of the athlete.
    PRIMARY KEY (aID),
    FOREIGN KEY (aID) REFERENCES Person(pID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS StageAthlete;

-- Table: StageAthlete
-- Description: Represents the participation of an athlete in a stage.
CREATE TABLE StageAthlete (
    sID INTEGER NOT NULL, -- Identifier of the stage.
    aID INTEGER NOT NULL, -- Identifier of the athlete.
    UNIQUE (sID, aID),
    PRIMARY KEY (sID, aID),
    FOREIGN KEY (sID) REFERENCES Stage(sID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (aID) REFERENCES Athlete(aID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Coach;

-- Table: Coach
-- Description: Represents a coach that can train athletes of a committee.
CREATE TABLE Coach (
    cID INTEGER NOT NULL UNIQUE, -- Unique identifier for the coach.
    cRole TEXT NOT NULL CHECK (cRole IN ('Head', 'Assistant', '2nd Assistant')), -- Role of the coach.
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Person(pID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS CoachAthlete;

-- Table: CoachAthlete
-- Description: Represents the training of an athlete by a coach.
CREATE TABLE CoachAthlete (
    aID INTEGER NOT NULL, -- Identifier of the athlete.
    cID INTEGER NOT NULL, -- Identifier of the coach.
    UNIQUE (aID, cID),
    PRIMARY KEY (aID, cID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cID) REFERENCES Coach(cID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AthleticDiscipline;

-- Table: AthleticDiscipline
-- Description: Represents an athletic discipline that can be practiced in Athletics at the Olympic Games.
CREATE TABLE AthleticDiscipline (
    adID INTEGER NOT NULL UNIQUE, -- Unique identifier for the athletic discipline.
    adName TEXT NOT NULL, -- Name of the athletic discipline.
    adGenderCategory TEXT NOT NULL CHECK (adGenderCategory IN ('M', 'F', 'Mixed')), -- Gender category of the athletic discipline.
    PRIMARY KEY (adID)
);

DROP TABLE IF EXISTS CoachAthleticDiscipline;

-- Table: CoachAthleticDiscipline
-- Description: Represents the training of a coach in an athletic discipline.
CREATE TABLE CoachAthleticDiscipline (
    cID INTEGER NOT NULL, -- Identifier of the coach.
    adID INTEGER NOT NULL, -- Identifier of the athletic discipline.
    UNIQUE (cID, adID),
    PRIMARY KEY (cID, adID),
    FOREIGN KEY (cID) REFERENCES Coach(cID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Medal;

-- Table: Medal
-- Description: Represents a medal won by an athlete in an athletic discipline.
CREATE TABLE Medal (
    mID INTEGER NOT NULL UNIQUE, -- Unique identifier for the medal.
    comID INTEGER NOT NULL, -- Identifier of the committee that won the medal.
    aID INTEGER NOT NULL, -- Identifier of the athlete that won the medal.
    adID INTEGER NOT NULL, -- Identifier of the athletic discipline of the medal.
    mType TEXT NOT NULL CHECK (mType IN ('Gold', 'Silver', 'Bronze')), -- Type of the medal.
    PRIMARY KEY (mID),
    FOREIGN KEY (comID) REFERENCES Committee(comID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (aID) REFERENCES Athlete(aID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Venue;

-- Table: Venue
-- Description: Represents a venue where stages of athletic disciplines can be held.
CREATE TABLE Venue (
    vID INTEGER NOT NULL UNIQUE, -- Unique identifier for the venue.
    vName TEXT NOT NULL, -- Name of the venue.
    vCity TEXT NOT NULL, -- City where the venue is located.
    vCapacity INTEGER NOT NULL CHECK (vCapacity > 0), -- Capacity of the venue.
    PRIMARY KEY (vID)
);

DROP TABLE IF EXISTS Result;

-- Table: Result
-- Description: Represents the result of an athlete in a stage.
CREATE TABLE Result (
    aID INTEGER NOT NULL, -- Identifier of the athlete.
    sID INTEGER NOT NULL, -- Identifier of the stage.
    rPosition INTEGER NOT NULL CHECK (rPosition > 0), -- Position of the athlete in the stage.
    rTime REAL CHECK (rTime >= 0), -- Time of the athlete in the stage.
    rDistance REAL CHECK (rDistance >= 0), -- Distance of the athlete in the stage.
    UNIQUE (aID, sID),
    PRIMARY KEY (aID, sID),
    FOREIGN KEY (aID) REFERENCES Athlete(aID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sID) REFERENCES Stage(sID) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK ((rTime IS NOT NULL AND rDistance IS NULL) OR (rTime IS NULL AND rDistance IS NOT NULL))
);

DROP TABLE IF EXISTS Record;

-- Table: Record
-- Description: Represents a record of an athlete in an athletic discipline.
CREATE TABLE Record (
    rID INTEGER NOT NULL UNIQUE, -- Unique identifier for the record.
    adID INTEGER NOT NULL, -- Identifier of the athletic discipline of the record.
    aID INTEGER NOT NULL, -- Identifier of the athlete of the record.
    rType TEXT NOT NULL CHECK (rType IN ('World', 'Olympic')), -- Type of the record.
    rDate DATE NOT NULL CHECK (rDate < DATE('2024-12-01')), -- Date of the record.
    rLocation TEXT NOT NULL, -- Location of the record.
    PRIMARY KEY (rID),
    FOREIGN KEY (adID) REFERENCES AthleticDiscipline(adID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (aID) REFERENCES Athlete(aID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS OldRecord;

-- Table: OldRecord
-- Description: Represents an old record of an athlete in an athletic discipline.
CREATE TABLE OldRecord (
    orID INTEGER UNIQUE, -- Unique identifier for the old record.
    orTime REAL CHECK (orTime >= 0), -- Time of the old record.
    orDistance REAL CHECK (orDistance >= 0), -- Distance of the old record.
    PRIMARY KEY (orID),
    CHECK ((orTime IS NOT NULL AND orDistance IS NULL) OR (orTime IS NULL AND orDistance IS NOT NULL))
);

DROP TABLE IF EXISTS NewRecord;

-- Table: NewRecord
-- Description: Represents a new record of an athlete in an athletic discipline.
CREATE TABLE NewRecord (
    nrID INTEGER NOT NULL UNIQUE, -- Unique identifier for the new record.
    aID INTEGER NOT NULL, -- Identifier of the athlete of the new record.
    sID INTEGER NOT NULL, -- Identifier of the stage of the new record.
    PRIMARY KEY (nrID),
    FOREIGN KEY (aID, sID) REFERENCES Result(aID, sID) ON DELETE CASCADE ON UPDATE CASCADE
);