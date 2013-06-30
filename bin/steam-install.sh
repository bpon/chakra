#!/bin/bash

set -e

wine msiexec /i $1

wine reg add 'HKCU\Software\Valve\Steam' /v DWriteEnable /t REG_DWORD /d 00000000
