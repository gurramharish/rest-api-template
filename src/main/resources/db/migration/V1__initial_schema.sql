-- Create sequence for employee IDs
CREATE SEQUENCE IF NOT EXISTS employee_id_seq START WITH 1 INCREMENT BY 1;

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id BIGINT PRIMARY KEY DEFAULT nextval('employee_id_seq'),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    department VARCHAR(100),
    position VARCHAR(100),
    hire_date DATE NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_employee_email ON employees (email);

-- Create index on department for filtering
CREATE INDEX IF NOT EXISTS idx_employee_department ON employees (department);

-- Create index on active status for filtering active employees
CREATE INDEX IF NOT EXISTS idx_employee_active ON employees (active);

-- Add a comment to the table
COMMENT ON TABLE employees IS 'Stores employee information';

-- Add comments to columns
COMMENT ON COLUMN employees.id IS 'Primary key';
COMMENT ON COLUMN employees.first_name IS 'Employee first name';
COMMENT ON COLUMN employees.last_name IS 'Employee last name';
COMMENT ON COLUMN employees.email IS 'Employee email address (must be unique)';
COMMENT ON COLUMN employees.department IS 'Department the employee belongs to';
COMMENT ON COLUMN employees.position IS 'Job position/title';
COMMENT ON COLUMN employees.hire_date IS 'Date when employee was hired';
COMMENT ON COLUMN employees.active IS 'Whether the employee is currently active';
COMMENT ON COLUMN employees.version IS 'Optimistic locking version';
COMMENT ON COLUMN employees.created_at IS 'Timestamp when the record was created';
COMMENT ON COLUMN employees.updated_at IS 'Timestamp when the record was last updated';
