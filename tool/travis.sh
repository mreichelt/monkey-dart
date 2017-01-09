#!/bin/bash

# Fast fail the script on failures.
set -e



# Verify that dartfmt has been run
echo "Checking dartfmt..."
if [[ $(dartfmt -n --set-exit-if-changed lib/ test/) ]]; then
	echo "Failed dartfmt check: run dartfmt -w lib/ test/"
	exit 1
fi



# Run the tests.
echo "Running tests..."
pub run test
