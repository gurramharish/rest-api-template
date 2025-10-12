# Employee Management Service

A Spring Boot REST API for managing employee information with enterprise-grade features.

## Features

- RESTful API for employee CRUD operations
- PostgreSQL database with Flyway migrations
- Input validation
- Structured logging
- Docker support
- Health checks and metrics via Spring Boot Actuator
- (Future) Redis caching
- (Future) API documentation with Swagger/OpenAPI

## Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- Docker and Docker Compose
- PostgreSQL (can be run via Docker)

## Getting Started

### 1. Start the Database

Run the following command to start PostgreSQL and Redis using Docker Compose:

```bash
docker-compose up -d
```

This will start:
- PostgreSQL on port 5432
- Redis on port 6379
- pgAdmin on port 5050 (for database management)

### 2. Build the Application

```bash
mvn clean install
```

### 3. Run the Application

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

- `GET /api/employees` - Get all employees
- `GET /api/employees/{id}` - Get employee by ID
- `POST /api/employees` - Create a new employee
- `PUT /api/employees/{id}` - Update an existing employee
- `DELETE /api/employees/{id}` - Delete an employee

## Actuator Endpoints

- `GET /actuator/health` - Application health
- `GET /actuator/info` - Application info
- `GET /actuator/metrics` - Application metrics
- `GET /actuator/caches` - Cache information

## Database Access

- **Host**: localhost:5432
- **Database**: employee_db
- **Username**: postgres
- **Password**: postgres

You can also use pgAdmin at `http://localhost:5050` to manage the database:
- **Email**: admin@example.com
- **Password**: admin

## Development

### Database Migrations

Database migrations are managed by Flyway. To create a new migration:

1. Create a new SQL file in `src/main/resources/db/migration/` with the naming convention `V<version>__<description>.sql`
2. The next time the application starts, the migration will be applied automatically

### Testing

Run the tests with:

```bash
mvn test
```

## Future Enhancements

- Add Redis caching for improved performance
- Add API documentation with Swagger/OpenAPI
- Implement authentication and authorization
- Add more advanced search and filtering
- Add pagination for list endpoints
- Add file upload for employee photos

## License

This project is licensed under the MIT License.
