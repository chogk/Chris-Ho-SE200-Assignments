// ASSIGNMENT 1

// Question 1:

function processInput(input: number | string): number | string {
    return typeof input === "number" ? input * input : input + input;
  }
  
  // Test cases, do not modify
  console.log(processInput(5)); // Should print: 25
  console.log(processInput("hello")); // Should print: "hellohello"



