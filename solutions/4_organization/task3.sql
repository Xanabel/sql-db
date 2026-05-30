-- Задача 3: Поиск всех менеджеров, имеющих подчиненных

WITH RECURSIVE AllSubordinates AS (
    SELECT ManagerID, EmployeeID AS SubID
    FROM Employees
    WHERE ManagerID IS NOT NULL
    
    UNION ALL
    
    SELECT a.ManagerID, e.EmployeeID
    FROM AllSubordinates a
    JOIN Employees e ON e.ManagerID = a.SubID
),
SubCount AS (
    SELECT ManagerID, COUNT(DISTINCT SubID) AS TotalSubordinates
    FROM AllSubordinates
    GROUP BY ManagerID
),
EmpProjects AS (
    SELECT DISTINCT e.EmployeeID, p.ProjectName
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
),
EmpTasks AS (
    SELECT AssignedTo AS EmployeeID, TaskName
    FROM Tasks
)
SELECT 
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT GROUP_CONCAT(ep.ProjectName ORDER BY ep.ProjectName SEPARATOR ', ')
     FROM EmpProjects ep 
     WHERE ep.EmployeeID = e.EmployeeID) AS ProjectNames,
    (SELECT GROUP_CONCAT(et.TaskName ORDER BY et.TaskName SEPARATOR ', ')
     FROM EmpTasks et 
     WHERE et.EmployeeID = e.EmployeeID) AS TaskNames,
    sc.TotalSubordinates
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r ON e.RoleID = r.RoleID
JOIN SubCount sc ON e.EmployeeID = sc.ManagerID
WHERE r.RoleName = 'Менеджер'
  AND sc.TotalSubordinates > 0
ORDER BY e.EmployeeID;