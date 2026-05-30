-- Задача 1: Поиск всех сотрудников, подчиняющихся Ивану Иванову, включая всех подчинённых с проектами и задачами

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
     WHERE et.EmployeeID = s.EmployeeID) AS TaskNames
FROM Subordinates s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Roles r ON s.RoleID = r.RoleID
ORDER BY s.Name;