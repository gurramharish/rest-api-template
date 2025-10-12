package com.hans.rest_api.employee.controller;

import com.hans.rest_api.api.model.EmployeeRequest;
import com.hans.rest_api.api.model.EmployeeResponse;
import com.hans.rest_api.employee.mapper.EmployeeMapper;
import com.hans.rest_api.employee.model.Employee;
import com.hans.rest_api.employee.service.EmployeeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Tag(name = "Employee Management", description = "APIs for managing employees")
@Slf4j
@RestController
@RequestMapping(value = "/api/employees", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;
    private final EmployeeMapper employeeMapper;

    @Operation(
        summary = "Get all employees",
        description = "Retrieves a list of all employees in the system"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved list of employees",
            content = @Content(schema = @Schema(implementation = EmployeeResponse.class))
        )
    })
    @GetMapping
    public ResponseEntity<List<EmployeeResponse>> getAllEmployees() {
        log.info("Received request to get all employees");
        List<EmployeeResponse> employees = employeeService.getAllEmployees().stream()
                .map(employeeMapper::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(employees);
    }

    @Operation(
        summary = "Get employee by ID",
        description = "Retrieves a specific employee by their unique identifier"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved employee",
            content = @Content(schema = @Schema(implementation = EmployeeResponse.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Employee not found",
            content = @Content
        )
    })
    @GetMapping("/{id}")
    public ResponseEntity<EmployeeResponse> getEmployeeById(
            @Parameter(description = "ID of the employee to be retrieved", required = true, example = "1")
            @PathVariable Long id) {
        log.info("Received request to get employee with id: {}", id);
        Employee employee = employeeService.getEmployeeById(id);
        return ResponseEntity.ok(employeeMapper.toResponse(employee));
    }

    @Operation(
        summary = "Create a new employee",
        description = "Creates a new employee with the provided details"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "201",
            description = "Employee created successfully",
            content = @Content(schema = @Schema(implementation = EmployeeResponse.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid input",
            content = @Content
        )
    })
    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<EmployeeResponse> createEmployee(
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                description = "Employee details to create",
                required = true,
                content = @Content(schema = @Schema(implementation = EmployeeRequest.class))
            )
            @Valid @RequestBody EmployeeRequest employeeRequest) {
        log.info("Received request to create employee with email: {}", employeeRequest.getEmail());
        Employee employee = employeeMapper.toEntity(employeeRequest);
        Employee createdEmployee = employeeService.createEmployee(employee);
        return new ResponseEntity<>(employeeMapper.toResponse(createdEmployee), HttpStatus.CREATED);
    }

    @Operation(
        summary = "Update an existing employee",
        description = "Updates the details of an existing employee"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Employee updated successfully",
            content = @Content(schema = @Schema(implementation = EmployeeResponse.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid input",
            content = @Content
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Employee not found",
            content = @Content
        )
    })
    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<EmployeeResponse> updateEmployee(
            @Parameter(description = "ID of the employee to be updated", required = true, example = "1")
            @PathVariable Long id,
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                description = "Updated employee details",
                required = true,
                content = @Content(schema = @Schema(implementation = EmployeeRequest.class))
            )
            @Valid @RequestBody EmployeeRequest employeeRequest) {
        log.info("Received request to update employee with id: {}", id);
        Employee employee = employeeMapper.toEntity(employeeRequest);
        employee.setId(id); // Ensure the ID is set from the path variable
        Employee updatedEmployee = employeeService.updateEmployee(employee);
        return ResponseEntity.ok(employeeMapper.toResponse(updatedEmployee));
    }

    @Operation(
        summary = "Delete an employee",
        description = "Deletes an employee by their unique identifier"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "204",
            description = "Employee deleted successfully",
            content = @Content
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Employee not found",
            content = @Content
        )
    })
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteEmployee(
            @Parameter(description = "ID of the employee to be deleted", required = true, example = "1")
            @PathVariable Long id) {
        log.info("Received request to delete employee with id: {}", id);
        employeeService.deleteEmployee(id);
    }
}
