---
name: write-junit-tests
description: >
  Protocol for writing JUnit 5 test cases from acceptance criteria. Covers test
  structure, naming conventions, assertion patterns, and TDD red-phase rules.
---

## JUnit 5 Test Writing Protocol

### File Organization
- Mirror source package structure: src/main/java/com/app/domain/ → tests/unit/com/app/domain/
- One test class per source class
- Use @Nested for logical grouping

### Naming Convention
```java
@Test
@DisplayName("returns 404 when customer does not exist")
void getCustomer_givenNonExistentId_throwsNotFoundException() { }
```
Pattern: methodName_givenCondition_expectedBehavior

### Test Structure (AAA)
```java
@Test
void methodName_givenCondition_expectedBehavior() {
    // Arrange
    var input = new CustomerRequest("test@example.com");
    when(repository.findById(any())).thenReturn(Optional.empty());

    // Act
    var exception = assertThrows(NotFoundException.class,
        () -> service.getCustomer("non-existent-id"));

    // Assert
    assertThat(exception.getMessage()).contains("not found");
    verify(repository).findById("non-existent-id");
}
```

### Assertion Library: AssertJ
Prefer AssertJ over JUnit assertions:
```java
assertThat(result).isNotNull();
assertThat(result.getName()).isEqualTo("expected");
assertThat(list).hasSize(3).extracting("name").contains("Alice", "Bob");
assertThat(exception).isInstanceOf(IllegalArgumentException.class);
```

### Mocking: Mockito
```java
@ExtendWith(MockitoExtension.class)
class ServiceTest {
    @Mock private Repository repository;
    @InjectMocks private Service service;
}
```

### TDD Red Phase Rules
- Tests MUST compile
- Tests MUST fail
- Create minimal stubs to achieve compilation:
  ```java
  public interface CustomerService {
      CustomerResponse getCustomer(String id); // stub only
  }
  ```
- Stub implementations throw UnsupportedOperationException
