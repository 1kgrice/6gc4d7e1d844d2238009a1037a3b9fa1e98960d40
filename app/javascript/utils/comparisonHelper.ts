const isObject = (obj) => obj && typeof obj === 'object';

function compareObjects(obj1, obj2) {
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);

  if (keys1.length !== keys2.length) {
    return true; // Different number of keys, so objects are different
  }

  for (let key of keys1) {
    const val1 = obj1[key];
    const val2 = obj2[key];
    const areObjects = isObject(val1) && isObject(val2);

    if (
      (areObjects && compareObjects(val1, val2)) ||
      (!areObjects && val1 !== val2)
    ) {
      return true; // Found a difference
    }
  }

  return false; // No differences found
}

export function objectsDiffer(obj1, obj2) {
  return compareObjects(obj1, obj2);
}
