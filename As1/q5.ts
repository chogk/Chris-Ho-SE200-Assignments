function getNestedValue(obj: any, key: string): unknown {
    // Implement the function here
    // Use type guards to check if obj is an object and has the key
    // Use type assertion if necessary
    if (typeof obj !== "object" || obj === null) return undefined;
    return key.split(".").reduce((acc, part) => (acc && typeof acc === "object" ? acc[part] : undefined), obj);
  }
  
  // Test cases, do not modify
  const testObj = { a: { b: { c: 42 } } };
  console.log(getNestedValue(testObj, "a.b.c")); // Should print: 42
  console.log(getNestedValue(testObj, "x.y.z")); // Should print: undefined
  console.log(getNestedValue(null, "a.b.c")); // Should print: undefined