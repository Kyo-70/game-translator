#!/bin/bash

echo "========================================"
echo " Game Translator - Build Script"
echo "========================================"
echo ""

echo "Instalando PyInstaller..."
pip3 install pyinstaller

echo ""
echo "Gerando executável..."
pyinstaller --name="GameTranslator" --onefile --windowed --add-data "profiles:profiles" src/main.py

echo ""
echo "========================================"
echo "Build concluído!"
echo "Executável criado em: dist/GameTranslator"
echo "========================================"
