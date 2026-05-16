---
name: run-test-suite
description: >
  Protocol for executing the test suite and parsing results into structured
  reports. Use when running tests and producing test result documentation.
---

## Test Execution Protocol

### Commands
```bash
# Unit tests
./gradlew test 2>&1 | tee /tmp/test-output.txt
echo "EXIT_CODE=$?" >> /tmp/test-output.txt

# Integration tests
./gradlew integrationTest 2>&1 | tee /tmp/integration-output.txt

# Coverage
./gradlew jacocoTestReport

# All together
./gradlew check 2>&1 | tee /tmp/check-output.txt
```
Override build commands using the Technology Stack section of the project's CLAUDE.md.

### Result Parsing
Read test reports from:
- Gradle: build/reports/tests/test/index.html
- JaCoCo: build/reports/jacoco/test/html/index.html
- Surefire (Maven): target/surefire-reports/

### Report Format
Always produce a structured markdown table with:
| Test Class | Test Method | Status | Duration | Error |
|-----------|-------------|--------|----------|-------|

### Coverage Thresholds (defaults — override in CLAUDE.md)
- Line coverage: 80% minimum
- Branch coverage: 70% minimum
