type MathFunction = (a: number, b: number) => number;

function mathOperation(a: number, b: number, operation: MathFunction): number {
  return operation(a, b);
}

// Implement add, subtract, and multiply functions
const add: MathFunction = (a, b) => a + b;
const subtract: MathFunction = (a, b) => a - b;
const multiply: MathFunction = (a, b) => a * b;

// Test cases, do not modify
console.log(mathOperation(5, 3, add)); // Output: 8
console.log(mathOperation(10, 4, subtract)); // Output: 6
console.log(mathOperation(3, 7, multiply)); // Output: 21