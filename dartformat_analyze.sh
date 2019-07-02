#!/usr/bin/env bash
dartfmt --fix -w lib/ test/
dartanalyzer .
