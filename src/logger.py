"""
Módulo de Sistema de Logs
Registra todas as operações do sistema
"""

import logging
import os
from datetime import datetime
from typing import Optional

class AppLogger:
    """Gerencia logs do aplicativo"""
    
    def __init__(self, log_dir: str = "logs", log_level: int = logging.INFO):
        """
        Inicializa o logger
        
        Args:
            log_dir: Diretório para armazenar logs
            log_level: Nível de log (DEBUG, INFO, WARNING, ERROR, CRITICAL)
        """
        self.log_dir = log_dir
        
        # Cria diretório de logs
        os.makedirs(log_dir, exist_ok=True)
        
        # Nome do arquivo de log com data
        log_filename = f"game_translator_{datetime.now().strftime('%Y%m%d')}.log"
        log_filepath = os.path.join(log_dir, log_filename)
        
        # Configura logger
        self.logger = logging.getLogger('GameTranslator')
        self.logger.setLevel(log_level)
        
        # Remove handlers existentes
        self.logger.handlers.clear()
        
        # Handler para arquivo
        file_handler = logging.FileHandler(log_filepath, encoding='utf-8')
        file_handler.setLevel(log_level)
        
        # Handler para console
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.WARNING)  # Apenas warnings e erros no console
        
        # Formato do log
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        
        file_handler.setFormatter(formatter)
        console_handler.setFormatter(formatter)
        
        # Adiciona handlers
        self.logger.addHandler(file_handler)
        self.logger.addHandler(console_handler)
    
    def debug(self, message: str):
        """Registra mensagem de debug"""
        self.logger.debug(message)
    
    def info(self, message: str):
        """Registra mensagem informativa"""
        self.logger.info(message)
    
    def warning(self, message: str):
        """Registra aviso"""
        self.logger.warning(message)
    
    def error(self, message: str, exc_info: bool = False):
        """Registra erro"""
        self.logger.error(message, exc_info=exc_info)
    
    def critical(self, message: str, exc_info: bool = False):
        """Registra erro crítico"""
        self.logger.critical(message, exc_info=exc_info)
    
    def log_file_operation(self, operation: str, filepath: str, success: bool):
        """
        Registra operação de arquivo
        
        Args:
            operation: Tipo de operação (load, save, backup, etc.)
            filepath: Caminho do arquivo
            success: Se a operação foi bem-sucedida
        """
        status = "SUCCESS" if success else "FAILED"
        self.info(f"File {operation}: {filepath} - {status}")
    
    def log_translation(self, original: str, translated: str, method: str = "manual"):
        """
        Registra tradução realizada
        
        Args:
            original: Texto original
            translated: Texto traduzido
            method: Método usado (manual, api, memory, pattern)
        """
        self.debug(f"Translation [{method}]: '{original}' -> '{translated}'")
    
    def log_api_call(self, api_name: str, success: bool, error: Optional[str] = None):
        """
        Registra chamada de API
        
        Args:
            api_name: Nome da API
            success: Se a chamada foi bem-sucedida
            error: Mensagem de erro (se houver)
        """
        if success:
            self.info(f"API call to {api_name}: SUCCESS")
        else:
            self.error(f"API call to {api_name}: FAILED - {error}")
    
    def log_profile_operation(self, operation: str, profile_name: str, success: bool):
        """
        Registra operação com perfil de regex
        
        Args:
            operation: Tipo de operação (create, load, save, delete)
            profile_name: Nome do perfil
            success: Se a operação foi bem-sucedida
        """
        status = "SUCCESS" if success else "FAILED"
        self.info(f"Profile {operation}: {profile_name} - {status}")
    
    def get_recent_logs(self, lines: int = 100) -> str:
        """
        Retorna logs recentes
        
        Args:
            lines: Número de linhas a retornar
            
        Returns:
            Texto com logs recentes
        """
        try:
            log_filename = f"game_translator_{datetime.now().strftime('%Y%m%d')}.log"
            log_filepath = os.path.join(self.log_dir, log_filename)
            
            if os.path.exists(log_filepath):
                with open(log_filepath, 'r', encoding='utf-8') as f:
                    all_lines = f.readlines()
                    return ''.join(all_lines[-lines:])
            
            return "No logs available"
        except Exception as e:
            return f"Error reading logs: {e}"

# Instância global do logger
app_logger = AppLogger()
