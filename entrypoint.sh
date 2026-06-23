#!/bin/bash

echo "============================================"
echo "  Hello from javm-docker! 🐳"
echo "============================================"
echo ""
echo "  Container Info:"
echo "  - Hostname : $(hostname)"
echo "  - OS       : $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
echo "  - Date     : $(date)"
echo "  - Uptime   : $(uptime -p 2>/dev/null || echo 'N/A')"
echo ""
echo "  Image built with GitHub Actions CI/CD"
echo "============================================"
