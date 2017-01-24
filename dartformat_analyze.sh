#!/usr/bin/env bash
dartfmt -w lib/ test/
dartanalyzer --strong .
