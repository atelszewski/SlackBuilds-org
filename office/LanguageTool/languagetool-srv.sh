#!/bin/sh

cd /usr/share/LanguageTool/
java -cp languagetool-server.jar org.languagetool.server.HTTPServer "$@"
