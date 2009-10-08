@echo off
rem	run.cmd
rem	: run a execution file and convert encoding of the output
rem	    (utf-8 ---> cp949)
%* | iconv -f utf-8 -t cp949