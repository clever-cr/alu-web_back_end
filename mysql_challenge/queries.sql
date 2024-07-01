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

SELECT COUNT(*) 
FROM TeamMembers tm
JOIN Employees e ON tm.EmployeeID = e.EmployeeID
WHERE e.EmployeeName = 'David Lee';