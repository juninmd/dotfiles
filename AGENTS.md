```markdown
# AGENTS.md File Guidelines

These guidelines are designed to ensure the consistent, maintainable, and high-quality development of the AGENTS repository. Adherence to these principles is mandatory for all development activities.

## 1. DRY (Don't Repeat Yourself)

*   All code should be reusable in other parts of the system.
*   Avoid duplicating functionality.
*   Refactor code to eliminate redundant elements.
*   Use consistent naming conventions.
*   Implement common patterns and abstractions.

## 2. KISS (Keep It Simple, Stupid)

*   Prioritize simplicity over complexity.
*   Write code that is easy to understand and maintain.
*   Avoid unnecessary abstractions.
*   Keep functions and classes short and focused.
*   Use clear and concise language.

## 3. SOLID Principles

*   **Single Responsibility Principle:** Each class should have one, and only one, reason to change.
*   **Open/Closed Principle:**  The system should be extensible without modifying its inner workings.  New functionality should be added through new classes without altering existing ones.
*   **Liskov Substitution Principle:**  Subclasses should be substitutable for their base classes without altering the correctness of the program.
*   **Interface Segregation Principle:** Clients shouldn’t be forced to wringe instantiation of an abstraction; clients should be allowed to control the bound abstractions.
*   **Dependency Inversion Principle:**  High-level modules should not depend on low-level modules; they should depend on abstractions.

## 4. YAGNI (You Aren’t Gonna Need It)

*   Don't add functionality that is not currently needed.
*   Avoid premature optimization.
*   Focus on delivering working code first.
*   Refactor only when there's a demonstrable need for a change.
*   Keep the codebase clean and uncluttered.

## 5. Code Style & Formatting

*   Follow established coding style guidelines (refer to [link to style guide]).
*   Use consistent indentation (2 spaces).
*   Use blank lines to separate logical blocks of code.
*   Comment code clearly and concisely.
*   Name variables and functions appropriately.
*   Use descriptive variable names.

## 6. File Size & Structure

*   Maximum file size: 180 lines of code.
*   File structure: Organize code into logical modules and components.
*   Use clear directory structures.
*   Document each file's purpose and dependencies.
*   Maintain a README file explaining the project’s goals and how to use the codebase.

## 7. Test Coverage Requirements

*   Minimum test coverage: 80%
*   Test cases must cover all core functionality and edge cases.
*   Tests should be independent and not rely on each other.
*   Use a robust testing framework.
*   Ensure thorough test coverage for all implemented functionalities.  Focus on unit tests.

## 8. Development Practices

*   Commit frequently with meaningful commit messages.
*   Write small, focused commits.
*   Code review before merging.
*   Follow the principle of "move slow code to the end."
*   Use version control effectively.

## 9.  Specific Considerations (Example - Adapt as needed)

*   **Agent Initialization:**  All agent initialization logic should be encapsulated within a dedicated module and thoroughly tested.
*   **Data Storage:**  Define clear data storage strategies and interfaces.  Avoid direct database interactions where possible.
*   **Communication Protocols:** Document all communication protocols used between agents and other systems.
*   **Error Handling:** Implement robust error handling mechanisms.  Avoid bare `try...except` blocks.

## 10.  Additional Guidelines

*   Use a linter to enforce coding standards.
*   Implement static analysis to detect potential bugs and vulnerabilities.
*   Document all APIs and interfaces.
*   Maintain traceability through code.

These guidelines are intended to provide a framework for developing the AGENTS repository.  Any deviation from these guidelines must be explicitly approved by the project lead.
```