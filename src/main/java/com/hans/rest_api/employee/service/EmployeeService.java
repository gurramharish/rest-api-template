package com.hans.rest_api.employee.service;

import com.hans.rest_api.employee.model.Employee;

import java.util.List;

public interface EmployeeService {
    
    List<Employee> getAllEmployees();
    
    Employee getEmployeeById(Long id);
    
    Employee createEmployee(Employee employee);
    
    Employee updateEmployee(Employee employee);
    
    void deleteEmployee(Long id);
}
