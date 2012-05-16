#!/usr/bin/env python

import sys, glob

if __name__ == "__main__":
	while True:
		line = sys.stdin.readline().strip()
		if line == "":
			sys.exit(0)
		files = glob.glob(line)
		#if files == []:
		#	raise line
		for file in files:
			print file
