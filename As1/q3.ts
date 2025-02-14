
type Circle = {
    kind: "circle";
    radius: number;
  };
  
  type Rectangle = {
    kind: "rectangle";
    width: number;
    height: number;
  };

  // Create a type Shape that contains the properties of either Circle or Rectangle
  
  type Shape = Circle | Rectangle;

  // Create a function calculateArea that takes a Shape as a parameter and returns its area
  
  function calculateArea(shape: Shape): number {
    if (shape.kind === "circle") {
      return Math.PI * shape.radius * shape.radius;
    } else {
      return shape.width * shape.height;
    }
  }
  
  // Test cases, do not modify
  const circle: Shape = { kind: "circle", radius: 5 };
  const rectangle: Shape = { kind: "rectangle", width: 4, height: 6 };
  console.log(calculateArea(circle)); // Should print approximately 78.54
  console.log(calculateArea(rectangle)); // Should print 24