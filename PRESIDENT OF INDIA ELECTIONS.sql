/* -------------------------
   0) Create / Use Database
------------------------- */
IF DB_ID('VotingDB') IS NULL
    CREATE DATABASE VotingDB;
GO
USE VotingDB;
GO

/* -----------------------------------
   1) Drop tables if they already exist
----------------------------------- */
IF OBJECT_ID('dbo.Vote','U')      IS NOT NULL DROP TABLE dbo.Vote;
IF OBJECT_ID('dbo.Candidate','U') IS NOT NULL DROP TABLE dbo.Candidate;
IF OBJECT_ID('dbo.Voter','U')     IS NOT NULL DROP TABLE dbo.Voter;
IF OBJECT_ID('dbo.Office','U')    IS NOT NULL DROP TABLE dbo.Office;
GO

/* -------------------------
   2) Create Tables
------------------------- */

-- Table for storing offices
CREATE TABLE dbo.Office (
    OfficeID   INT IDENTITY(1,1) PRIMARY KEY,
    OfficeName VARCHAR(50) NOT NULL
);

-- Table for candidates
CREATE TABLE dbo.Candidate (
    CandidateID   INT IDENTITY(1,1) PRIMARY KEY,
    CandidateName VARCHAR(50) NOT NULL,
    OfficeID      INT NOT NULL,
    CONSTRAINT FK_Candidate_Office
        FOREIGN KEY (OfficeID) REFERENCES dbo.Office(OfficeID)
);

-- Table for voters
CREATE TABLE dbo.Voter (
    VoterID   INT IDENTITY(1,1) PRIMARY KEY,
    VoterName VARCHAR(50) NOT NULL
);

-- Table for votes
CREATE TABLE dbo.Vote (
    VoteID      INT IDENTITY(1,1) PRIMARY KEY,
    VoterID     INT NOT NULL,
    CandidateID INT NOT NULL,
    CONSTRAINT FK_Vote_Voter
        FOREIGN KEY (VoterID) REFERENCES dbo.Voter(VoterID),
    CONSTRAINT FK_Vote_Candidate
        FOREIGN KEY (CandidateID) REFERENCES dbo.Candidate(CandidateID)
    -- If you want to prevent duplicate votes for the SAME candidate, uncomment:
    -- ,CONSTRAINT UQ_Vote_Voter_Candidate UNIQUE (VoterID, CandidateID)
);
GO

/* -------------------------
   3) Insert Sample Data
------------------------- */

-- Offices
INSERT INTO dbo.Office (OfficeName) VALUES ('President');
INSERT INTO dbo.Office (OfficeName) VALUES ('Vice President');

-- Candidates
INSERT INTO dbo.Candidate (CandidateName, OfficeID) VALUES ('Rahul',   1);
INSERT INTO dbo.Candidate (CandidateName, OfficeID) VALUES ('Priya',   1);
INSERT INTO dbo.Candidate (CandidateName, OfficeID) VALUES ('Arjun',   2);
INSERT INTO dbo.Candidate (CandidateName, OfficeID) VALUES ('Sneha',   2);

-- Voters
INSERT INTO dbo.Voter (VoterName) VALUES ('Ravi');
INSERT INTO dbo.Voter (VoterName) VALUES ('Anjali');
INSERT INTO dbo.Voter (VoterName) VALUES ('Kiran');
INSERT INTO dbo.Voter (VoterName) VALUES ('Suresh');
INSERT INTO dbo.Voter (VoterName) VALUES ('Lakshmi');

-- Votes (includes duplicates exactly as in your example)
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (1, 1); -- Ravi -> Rahul
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (2, 2); -- Anjali -> Priya
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (3, 1); -- Kiran -> Rahul
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (4, 3); -- Suresh -> Arjun
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (5, 4); -- Lakshmi -> Sneha
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (1, 1); -- Ravi -> Rahul again
INSERT INTO dbo.Vote (VoterID, CandidateID) VALUES (2, 2); -- Anjali -> Priya again
GO

/* -------------------------
   4) Queries
------------------------- */

-- Show all candidates with their office
SELECT c.CandidateID, c.CandidateName, o.OfficeName
FROM dbo.Candidate c
JOIN dbo.Office    o ON c.OfficeID = o.OfficeID;

-- Count votes for each candidate
SELECT c.CandidateName, COUNT(v.VoteID) AS TotalVotes
FROM dbo.Candidate c
LEFT JOIN dbo.Vote v ON c.CandidateID = v.CandidateID
GROUP BY c.CandidateName
ORDER BY TotalVotes DESC, c.CandidateName;

-- Find the overall winner (max votes across all offices)
SELECT TOP (1) c.CandidateName, COUNT(v.VoteID) AS TotalVotes
FROM dbo.Candidate c
LEFT JOIN dbo.Vote v ON c.CandidateID = v.CandidateID
GROUP BY c.CandidateName
ORDER BY TotalVotes DESC, c.CandidateName;

-- Check if any candidate has majority (>50% of all votes)
-- Safe against divide-by-zero using NULLIF
SELECT
    c.CandidateName,
    COUNT(v.VoteID) * 100.0 / NULLIF((SELECT COUNT(*) FROM dbo.Vote), 0) AS VotePercentage
FROM dbo.Candidate c
LEFT JOIN dbo.Vote v ON c.CandidateID = v.CandidateID
GROUP BY c.CandidateName
HAVING COUNT(v.VoteID) > (SELECT COUNT(*) * 1.0 / 2 FROM dbo.Vote);

-- Show voters with the candidate and office they voted for
SELECT vt.VoteID, vtr.VoterName, c.CandidateName, o.OfficeName
FROM dbo.Vote vt
JOIN dbo.Voter    vtr ON vt.VoterID     = vtr.VoterID
JOIN dbo.Candidate c   ON vt.CandidateID = c.CandidateID
JOIN dbo.Office    o   ON c.OfficeID     = o.OfficeID
ORDER BY vt.VoteID;
