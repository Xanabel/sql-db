-- Задача 2: Поиск всех сотрудников, подчиняющихся Ивану Иванову, количество задач и прямых подчиненных

WITH RECURSIVE Subordinates AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1

    UNION ALL

    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
EmpProjects AS (
    SELECT DISTINCT e.EmployeeID, p.ProjectName
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
),
EmpTasks AS (
    SELECT AssignedTo AS EmployeeID, TaskName
    FROM Tasks
),
TaskCount AS (
    SELECT AssignedTo AS EmployeeID, COUNT(*) AS TotalTasks
    FROM Tasks
    GROUP BY AssignedTo
),
SubCount AS (
    SELECT ManagerID, COUNT(*) AS TotalSubordinates
    FROM Employees
    GROUP BY ManagerID
)
SELECT 
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT GROUP_CONCAT(ep.ProjectName ORDER BY ep.ProjectName SEPARATOR ', ')
     FROM EmpProjects ep 
     WHERE ep.EmployeeID = s.EmployeeID) AS ProjectNames,
    (SELECT GROUP_CONCAT(et.TaskName ORDER BY et.TaskName SEPARATOR ', ')
     FROM EmpTasks et 
     WHERE et.EmployeeID = s.EmployeeID) AS TaskNames,
    COALESCE(tc.TotalTasks, 0) AS TotalTasks,
    COALESCE(sc.TotalSubordinates, 0) AS TotalSubordinates
FROM Subordinates s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Roles r ON s.RoleID = r.RoleID
LEFT JOIN TaskCount tc ON s.EmployeeID = tc.EmployeeID
LEFT JOIN SubCount sc ON s.EmployeeID = sc.ManagerID
ORDER BY s.Name;