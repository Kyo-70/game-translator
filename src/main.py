"""
Game Translator - Sistema de Tradução para Jogos e Mods
Autor: Manus AI
Versão: 1.0.0
Descrição: Ferramenta completa para tradução de arquivos JSON/XML preservando estrutura original
"""

import sys
from PySide6.QtWidgets import QApplication
from gui.main_window import MainWindow

def main():
    """Função principal do aplicativo"""
    app = QApplication(sys.argv)
    app.setStyle('Fusion')  # Estilo moderno
    
    window = MainWindow()
    window.show()
    
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
