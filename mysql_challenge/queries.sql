-- Find all projects with a deadline before December 1st, 2024.
SELECT * FROM Projects WHERE Deadline < '2024-12-01';

-- List all projects for "Big Retail Inc." ordered by deadline.

SELECT p.* 
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID
WHERE c.ClientName = 'Big Retail Inc.'
ORDER BY p.Deadline;

-- Find the team lead for the "Mobile App for Learning" project.
SELECT e.EmployeeName 
FROM Employees e
JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID
JOIN Projects p ON pt.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App for Learning' AND pt.TeamLead = TRUE;

-- Find projects containing "Management" in the name.
SELECT * FROM Projects WHERE ProjectName LIKE '%Management%';

-- Count the number of projects assigned to David Lee.
SELECT COUNT(*) 
FROM TeamMembers tm
JOIN Employees e ON tm.EmployeeID = e.EmployeeID
WHERE e.EmployeeName = 'David Lee';

-- Find the total number of employees working on each project.
SELECT ProjectID, COUNT(EmployeeID) AS TotalEmployees
FROM TeamMembers
GROUP BY ProjectID;

-- Find all clients with projects having a deadline after October 31st, 2024.
SELECT DISTINCT C.ClientName 
FROM Clients C
JOIN Projects P ON C.ClientID = P.ClientID
WHERE P.Deadline > '2024-10-31';

-- List employees who are not currently team leads on any project:
SELECT E.EmployeeName 
FROM Employees E
WHERE E.EmployeeID NOT IN (
    SELECT EmployeeID 
    FROM ProjectTeam 
    WHERE TeamLead = 'Yes'
);

--Combine a list of projects with deadlines before December 1st and another list with "Management" in the project name:
SELECT * FROM Projects 
WHERE Deadline < '2024-12-01'
UNION
SELECT * FROM Projects 
WHERE ProjectName LIKE '%Management%';

-- Display a message indicating if a project is overdue (deadline passed):
SELECT ProjectName, 
CASE 
    WHEN Deadline < CURRENT_DATE THEN 'Overdue'
    ELSE 'On Time'
END AS Status
FROM Projects;

-- Create a view to simplify retrieving client contact:
CREATE VIEW ClientContacts AS
SELECT ClientName, ContactName, ContactEmail 
FROM Clients;

-- Create a view to show only ongoing projects (not yet completed):
CREATE VIEW OngoingProjects AS
SELECT * FROM Projects
WHERE Deadline >= CURRENT_DATE;

-- Create a view to display project information along with assigned team leads:
CREATE VIEW ProjectTeamLeads AS
SELECT P.ProjectName, E.EmployeeName AS TeamLead
FROM Projects P
JOIN ProjectTeam PT ON P.ProjectID = PT.ProjectID
JOIN Employees E ON PT.EmployeeID = E.EmployeeID
WHERE PT.TeamLead = 'Yes';

-- Create a view to show project names and client contact information for projects with a deadline in November 2024:
CREATE VIEW November2024Projects AS
SELECT P.ProjectName, C.ContactName, C.ContactEmail
FROM Projects P
JOIN Clients C ON P.ClientID = C.ClientID
WHERE P.Deadline BETWEEN '2024-11-01' AND '2024-11-30';

-- Create a view to display the total number of projects assigned to each employee:
CREATE VIEW EmployeeProjectCounts AS
SELECT E.EmployeeName, COUNT(TM.ProjectID) AS ProjectCount
FROM Employees E
JOIN TeamMembers TM ON E.EmployeeID = TM.EmployeeID
GROUP BY E.EmployeeName;

-- Create a function to calculate the number of days remaining until a project deadline:
CREATE FUNCTION DaysUntilDeadline(ProjectID INT) RETURNS INT AS
BEGIN
    DECLARE days_left INT;
    SELECT DATEDIFF(Deadline, CURRENT_DATE) INTO days_left
    FROM Projects WHERE ProjectID = ProjectID;
    RETURN days_left;
END;

-- Create a function to calculate the number of days a project is overdue
CREATE FUNCTION DaysOverdue(ProjectID INT) RETURNS INT AS
BEGIN
    DECLARE days_overdue INT;
    SELECT DATEDIFF(CURRENT_DATE, Deadline) INTO days_overdue
    FROM Projects WHERE ProjectID = ProjectID;
    RETURN CASE WHEN days_overdue > 0 THEN days_overdue ELSE 0 END;
END;

-- Create a stored procedure to add a new client and their first project in one call:
CREATE PROCEDURE AddClientAndProject (
    IN ClientName VARCHAR(255), 
    IN ContactName VARCHAR(255), 
    IN ContactEmail VARCHAR(255), 
    IN ProjectName VARCHAR(255), 
    IN Requirements TEXT, 
    IN Deadline DATE
)
BEGIN
    INSERT INTO Clients (ClientName, ContactName, ContactEmail)
    VALUES (ClientName, ContactName, ContactEmail);
    
    DECLARE newClientID INT;
    SELECT LAST_INSERT_ID() INTO newClientID;
    
    INSERT INTO Projects (ProjectName, Requirements, Deadline, ClientID)
    VALUES (ProjectName, Requirements, Deadline, newClientID);
END;

-- Create a trigger to log any updates made to project records in a separate table for auditing purposes:
CREATE TRIGGER LogProjectUpdates 
AFTER UPDATE ON Projects 
FOR EACH ROW 
BEGIN 
  INSERT INTO ProjectAudit (ProjectID, OldDeadline, NewDeadline, ChangeDate) 
  VALUES (OLD.ProjectID, OLD.Deadline, NEW.Deadline, NOW());
END;


-- CREATE TRIGGER EnsureValidTeamLead
BEFORE INSERT OR UPDATE ON ProjectTeam
FOR EACH ROW
BEGIN
    DECLARE validEmployee INT;
    SELECT COUNT(*) INTO validEmployee FROM Employees WHERE EmployeeID = NEW.EmployeeID;
    IF validEmployee = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Team Lead: Employee does not exist';
    END IF;
END;

-- View to Display Project Details Along with the Total Number of Team Members Assigned
CREATE VIEW ProjectDetailsWithTeamMembers AS
SELECT p.ProjectID, p.ProjectName, p.Requirements, p.Deadline, COUNT(tm.EmployeeID) AS TotalTeamMembers
FROM Projects p
LEFT JOIN TeamMembers tm ON p.ProjectID = tm.ProjectID
GROUP BY p.ProjectID, p.ProjectName, p.Requirements, p.Deadline;

-- View to Show Overdue Projects with the Number of Days Overdue
CREATE VIEW OverdueProjects AS
SELECT p.ProjectID, p.ProjectName, p.Requirements, p.Deadline, DATEDIFF(CURDATE(), p.Deadline) AS DaysOverdue
FROM Projects p
WHERE p.Deadline < CURDATE();

-- Stored Procedure to Update Project Team Members (Remove Existing, Add New Ones)
CREATE PROCEDURE UpdateProjectTeamMembers(
    IN projectID INT,
    IN newTeamMembers TEXT
)
BEGIN
    -- Remove existing team members
    DELETE FROM TeamMembers WHERE ProjectID = projectID;

    -- Add new team members
    -- Assuming newTeamMembers is a comma-separated string of EmployeeIDs
    SET @newTeamMembers := newTeamMembers;
    SET @projectID := projectID;
    SET @sql := CONCAT(
        'INSERT INTO TeamMembers (ProjectID, EmployeeID) SELECT @projectID, EmployeeID FROM (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@newTeamMembers, '','', numbers.n), '','', -1) AS EmployeeID FROM (SELECT @rownum := @rownum + 1 AS n FROM (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) t1, (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) t2, (SELECT @rownum := 0) t3) numbers) newMembers WHERE EmployeeID IN (SELECT EmployeeID FROM Employees)'
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;

--  Trigger to Prevent Deleting a Project that Still Has Assigned Team Members
CREATE TRIGGER PreventDeleteProjectWithTeamMembers
BEFORE DELETE ON Projects
FOR EACH ROW
BEGIN
    DECLARE teamMembersCount INT;
    SELECT COUNT(*) INTO teamMembersCount FROM TeamMembers WHERE ProjectID = OLD.ProjectID;
    IF teamMembersCount > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete project with assigned team members';
    END IF;
END;


