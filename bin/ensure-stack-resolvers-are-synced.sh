#!/bin/sh

# This ensures that each exercise's stack resolver has the same version.

differing_stack=""
first_stack_yaml=$(ls -1 exercises/practice/*/stack.yaml | head -1)
expected_stack=$(yq eval .resolver "$first_stack_yaml")
echo "All exercises should have resolver $expected_stack"
for etype in concept practice; do
  for exercise in $(git rev-parse --show-toplevel)/exercises/${etype}/*/ ; do
    exercise_stack=$(yq eval .resolver "$exercise/stack.yaml")
    if ! [ "$exercise_stack" = "$expected_stack" ]; then
      differing_stack="$differing_stack ${etype}/$(basename "$exercise")"
    fi
  done
done
if [ -n "$differing_stack" ]; then
    echo "The following exercises have a different stack.yaml resolver:$differing_stack"
    echo "They should instead be $expected_stack"
    exit 1
fi
