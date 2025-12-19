"""
Módulo de Segurança e Otimização
Garante estabilidade, segurança e performance do sistema
"""

import os
import sys
import gc
import re
import threading
import time
import psutil
from typing import Optional, Callable, Any
from functools import wraps
from dataclasses import dataclass

# ============================================================================
# CONFIGURAÇÕES DE LIMITES DE SEGURANÇA
# ============================================================================

@dataclass
class SecurityLimits:
    """Limites de segurança configuráveis"""
    MAX_FILE_SIZE_MB: int = 100          # Tamanho máximo de arquivo em MB
    MAX_MEMORY_USAGE_MB: int = 500       # Uso máximo de RAM em MB
    MAX_CPU_PERCENT: int = 80            # Uso máximo de CPU em %
    MAX_ENTRIES_PER_FILE: int = 100000   # Máximo de entradas por arquivo
    MAX_TEXT_LENGTH: int = 10000         # Tamanho máximo de texto individual
    OPERATION_TIMEOUT_SEC: int = 300     # Timeout de operações em segundos
    CHUNK_SIZE: int = 1000               # Tamanho do chunk para processamento
    GC_THRESHOLD_MB: int = 200           # Threshold para forçar garbage collection
    MAX_CONCURRENT_THREADS: int = 4      # Máximo de threads simultâneas
    AUTO_SAVE_INTERVAL_SEC: int = 300    # Intervalo de auto-save em segundos

LIMITS = SecurityLimits()

# ============================================================================
# VALIDADORES DE SEGURANÇA
# ============================================================================

class SecurityValidator:
    """Validadores de segurança para inputs e arquivos"""
    
    # Padrões perigosos para sanitização
    DANGEROUS_PATTERNS = [
        r'<script[^>]*>.*?</script>',  # Scripts
        r'javascript:',                  # JavaScript URLs
        r'on\w+\s*=',                   # Event handlers
        r'\x00',                         # Null bytes
        r'\.\./',                        # Path traversal
        r'\.\.\\',                       # Path traversal Windows
    ]
    
    # Extensões de arquivo permitidas
    ALLOWED_EXTENSIONS = {'.json', '.xml', '.db', '.csv'}
    
    @staticmethod
    def validate_file_path(filepath: str) -> tuple[bool, str]:
        """
        Valida um caminho de arquivo
        
        Args:
            filepath: Caminho do arquivo
            
        Returns:
            Tupla (válido, mensagem)
        """
        if not filepath:
            return False, "Caminho de arquivo vazio"
        
        # Normaliza o caminho
        filepath = os.path.normpath(filepath)
        
        # Verifica path traversal
        if '..' in filepath:
            return False, "Caminho de arquivo inválido (path traversal detectado)"
        
        # Verifica extensão
        ext = os.path.splitext(filepath)[1].lower()
        if ext not in SecurityValidator.ALLOWED_EXTENSIONS:
            return False, f"Extensão de arquivo não permitida: {ext}"
        
        return True, "OK"
    
    @staticmethod
    def validate_file_size(filepath: str) -> tuple[bool, str]:
        """
        Valida o tamanho de um arquivo
        
        Args:
            filepath: Caminho do arquivo
            
        Returns:
            Tupla (válido, mensagem)
        """
        if not os.path.exists(filepath):
            return False, "Arquivo não encontrado"
        
        size_mb = os.path.getsize(filepath) / (1024 * 1024)
        
        if size_mb > LIMITS.MAX_FILE_SIZE_MB:
            return False, f"Arquivo muito grande: {size_mb:.1f}MB (máximo: {LIMITS.MAX_FILE_SIZE_MB}MB)"
        
        return True, "OK"
    
    @staticmethod
    def sanitize_text(text: str) -> str:
        """
        Sanitiza texto removendo padrões perigosos
        
        Args:
            text: Texto a ser sanitizado
            
        Returns:
            Texto sanitizado
        """
        if not text:
            return text
        
        # Remove padrões perigosos
        for pattern in SecurityValidator.DANGEROUS_PATTERNS:
            text = re.sub(pattern, '', text, flags=re.IGNORECASE | re.DOTALL)
        
        # Limita tamanho
        if len(text) > LIMITS.MAX_TEXT_LENGTH:
            text = text[:LIMITS.MAX_TEXT_LENGTH]
        
        return text
    
    @staticmethod
    def sanitize_sql_param(param: str) -> str:
        """
        Sanitiza parâmetro para SQL (prevenção de injeção)
        
        Args:
            param: Parâmetro a ser sanitizado
            
        Returns:
            Parâmetro sanitizado
        """
        if not param:
            return param
        
        # Remove caracteres perigosos para SQL
        dangerous_chars = ["'", '"', ';', '--', '/*', '*/', 'DROP', 'DELETE', 'INSERT', 'UPDATE']
        
        result = param
        for char in dangerous_chars:
            result = result.replace(char, '')
        
        return result
    
    @staticmethod
    def validate_regex_pattern(pattern: str) -> tuple[bool, str]:
        """
        Valida um padrão regex para evitar ReDoS
        
        Args:
            pattern: Padrão regex
            
        Returns:
            Tupla (válido, mensagem)
        """
        if not pattern:
            return False, "Padrão vazio"
        
        # Padrões potencialmente perigosos (ReDoS)
        dangerous_regex = [
            r'\(\.\*\)\+',           # (.*)+
            r'\(\.\+\)\+',           # (.+)+
            r'\([^)]*\)\{.*,\}',     # Repetições aninhadas
        ]
        
        for dangerous in dangerous_regex:
            if re.search(dangerous, pattern):
                return False, "Padrão regex potencialmente perigoso (ReDoS)"
        
        # Tenta compilar
        try:
            re.compile(pattern)
            return True, "OK"
        except re.error as e:
            return False, f"Padrão regex inválido: {e}"

# ============================================================================
# MONITOR DE RECURSOS
# ============================================================================

class ResourceMonitor:
    """Monitora uso de recursos do sistema"""
    
    _instance = None
    _lock = threading.Lock()
    
    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
                    cls._instance._initialized = False
        return cls._instance
    
    def __init__(self):
        if self._initialized:
            return
        
        self._initialized = True
        self._monitoring = False
        self._monitor_thread = None
        self._callbacks = []
        self._process = psutil.Process()
    
    def get_memory_usage_mb(self) -> float:
        """Retorna uso de memória em MB"""
        try:
            return self._process.memory_info().rss / (1024 * 1024)
        except:
            return 0
    
    def get_cpu_percent(self) -> float:
        """Retorna uso de CPU em %"""
        try:
            return self._process.cpu_percent(interval=0.1)
        except:
            return 0
    
    def check_resources(self) -> tuple[bool, str]:
        """
        Verifica se os recursos estão dentro dos limites
        
        Returns:
            Tupla (ok, mensagem)
        """
        memory_mb = self.get_memory_usage_mb()
        cpu_percent = self.get_cpu_percent()
        
        if memory_mb > LIMITS.MAX_MEMORY_USAGE_MB:
            return False, f"Uso de memória excedido: {memory_mb:.1f}MB"
        
        if cpu_percent > LIMITS.MAX_CPU_PERCENT:
            return False, f"Uso de CPU excedido: {cpu_percent:.1f}%"
        
        return True, "OK"
    
    def force_gc_if_needed(self):
        """Força garbage collection se necessário"""
        memory_mb = self.get_memory_usage_mb()
        
        if memory_mb > LIMITS.GC_THRESHOLD_MB:
            gc.collect()
    
    def start_monitoring(self, callback: Callable[[str], None] = None):
        """Inicia monitoramento contínuo"""
        if self._monitoring:
            return
        
        self._monitoring = True
        if callback:
            self._callbacks.append(callback)
        
        def monitor_loop():
            while self._monitoring:
                ok, msg = self.check_resources()
                
                if not ok:
                    for cb in self._callbacks:
                        try:
                            cb(msg)
                        except:
                            pass
                
                self.force_gc_if_needed()
                time.sleep(5)  # Verifica a cada 5 segundos
        
        self._monitor_thread = threading.Thread(target=monitor_loop, daemon=True)
        self._monitor_thread.start()
    
    def stop_monitoring(self):
        """Para monitoramento"""
        self._monitoring = False

# ============================================================================
# DECORADORES DE SEGURANÇA
# ============================================================================

def safe_operation(timeout: int = None, max_retries: int = 3):
    """
    Decorador para operações seguras com timeout e retry
    
    Args:
        timeout: Timeout em segundos (None = usa padrão)
        max_retries: Número máximo de tentativas
    """
    def decorator(func: Callable) -> Callable:
        @wraps(func)
        def wrapper(*args, **kwargs) -> Any:
            actual_timeout = timeout or LIMITS.OPERATION_TIMEOUT_SEC
            
            result = [None]
            exception = [None]
            completed = threading.Event()
            
            def target():
                try:
                    result[0] = func(*args, **kwargs)
                except Exception as e:
                    exception[0] = e
                finally:
                    completed.set()
            
            for attempt in range(max_retries):
                thread = threading.Thread(target=target)
                thread.daemon = True
                thread.start()
                
                if completed.wait(timeout=actual_timeout):
                    if exception[0]:
                        if attempt < max_retries - 1:
                            time.sleep(0.5)  # Pequena pausa antes de retry
                            continue
                        raise exception[0]
                    return result[0]
                else:
                    # Timeout - tenta novamente
                    if attempt < max_retries - 1:
                        continue
                    raise TimeoutError(f"Operação excedeu timeout de {actual_timeout}s")
            
            return result[0]
        
        return wrapper
    return decorator

def memory_safe(func: Callable) -> Callable:
    """Decorador que verifica memória antes e depois da operação"""
    @wraps(func)
    def wrapper(*args, **kwargs) -> Any:
        monitor = ResourceMonitor()
        
        # Verifica antes
        ok, msg = monitor.check_resources()
        if not ok:
            monitor.force_gc_if_needed()
            ok, msg = monitor.check_resources()
            if not ok:
                raise MemoryError(f"Recursos insuficientes: {msg}")
        
        try:
            result = func(*args, **kwargs)
        finally:
            # Limpa depois
            monitor.force_gc_if_needed()
        
        return result
    
    return wrapper

def validate_input(func: Callable) -> Callable:
    """Decorador que sanitiza inputs de string"""
    @wraps(func)
    def wrapper(*args, **kwargs) -> Any:
        # Sanitiza argumentos string
        new_args = []
        for arg in args:
            if isinstance(arg, str):
                new_args.append(SecurityValidator.sanitize_text(arg))
            else:
                new_args.append(arg)
        
        # Sanitiza kwargs string
        new_kwargs = {}
        for key, value in kwargs.items():
            if isinstance(value, str):
                new_kwargs[key] = SecurityValidator.sanitize_text(value)
            else:
                new_kwargs[key] = value
        
        return func(*new_args, **new_kwargs)
    
    return wrapper

# ============================================================================
# PROCESSADOR SEGURO DE CHUNKS
# ============================================================================

class ChunkProcessor:
    """Processa dados em chunks para evitar sobrecarga"""
    
    def __init__(self, chunk_size: int = None):
        """
        Inicializa o processador
        
        Args:
            chunk_size: Tamanho do chunk (None = usa padrão)
        """
        self.chunk_size = chunk_size or LIMITS.CHUNK_SIZE
        self.monitor = ResourceMonitor()
        self._cancelled = False
    
    def process(self, items: list, processor: Callable, 
                progress_callback: Callable[[int, int], None] = None) -> list:
        """
        Processa itens em chunks
        
        Args:
            items: Lista de itens
            processor: Função de processamento
            progress_callback: Callback de progresso (current, total)
            
        Returns:
            Lista de resultados
        """
        self._cancelled = False
        results = []
        total = len(items)
        
        for i in range(0, total, self.chunk_size):
            if self._cancelled:
                break
            
            # Verifica recursos
            self.monitor.force_gc_if_needed()
            ok, msg = self.monitor.check_resources()
            
            if not ok:
                # Pausa e tenta novamente
                time.sleep(1)
                gc.collect()
                ok, msg = self.monitor.check_resources()
                
                if not ok:
                    raise MemoryError(f"Recursos insuficientes: {msg}")
            
            # Processa chunk
            chunk = items[i:i + self.chunk_size]
            
            for item in chunk:
                if self._cancelled:
                    break
                
                try:
                    result = processor(item)
                    results.append(result)
                except Exception as e:
                    results.append(None)
            
            # Callback de progresso
            if progress_callback:
                progress_callback(min(i + self.chunk_size, total), total)
            
            # Pequena pausa para não sobrecarregar
            time.sleep(0.01)
        
        return results
    
    def cancel(self):
        """Cancela processamento"""
        self._cancelled = True

# ============================================================================
# WATCHDOG PARA OPERAÇÕES LONGAS
# ============================================================================

class OperationWatchdog:
    """Watchdog para detectar operações travadas"""
    
    def __init__(self, timeout: int = None, callback: Callable[[], None] = None):
        """
        Inicializa o watchdog
        
        Args:
            timeout: Timeout em segundos
            callback: Função a chamar em caso de timeout
        """
        self.timeout = timeout or LIMITS.OPERATION_TIMEOUT_SEC
        self.callback = callback
        self._timer = None
        self._active = False
    
    def start(self):
        """Inicia o watchdog"""
        self._active = True
        self._timer = threading.Timer(self.timeout, self._on_timeout)
        self._timer.daemon = True
        self._timer.start()
    
    def reset(self):
        """Reseta o timer do watchdog"""
        if self._timer:
            self._timer.cancel()
        
        if self._active:
            self._timer = threading.Timer(self.timeout, self._on_timeout)
            self._timer.daemon = True
            self._timer.start()
    
    def stop(self):
        """Para o watchdog"""
        self._active = False
        if self._timer:
            self._timer.cancel()
            self._timer = None
    
    def _on_timeout(self):
        """Chamado quando ocorre timeout"""
        if self.callback:
            self.callback()

# ============================================================================
# SISTEMA DE AUTO-SAVE
# ============================================================================

class AutoSaveManager:
    """Gerencia auto-save periódico"""
    
    def __init__(self, save_callback: Callable[[], bool], 
                 interval: int = None):
        """
        Inicializa o gerenciador
        
        Args:
            save_callback: Função de salvamento
            interval: Intervalo em segundos
        """
        self.save_callback = save_callback
        self.interval = interval or LIMITS.AUTO_SAVE_INTERVAL_SEC
        self._timer = None
        self._active = False
        self._has_changes = False
    
    def start(self):
        """Inicia auto-save"""
        self._active = True
        self._schedule_next()
    
    def stop(self):
        """Para auto-save"""
        self._active = False
        if self._timer:
            self._timer.cancel()
            self._timer = None
    
    def mark_changed(self):
        """Marca que há alterações não salvas"""
        self._has_changes = True
    
    def mark_saved(self):
        """Marca que foi salvo"""
        self._has_changes = False
    
    def _schedule_next(self):
        """Agenda próximo auto-save"""
        if not self._active:
            return
        
        self._timer = threading.Timer(self.interval, self._do_save)
        self._timer.daemon = True
        self._timer.start()
    
    def _do_save(self):
        """Executa salvamento"""
        if self._has_changes:
            try:
                if self.save_callback():
                    self._has_changes = False
            except:
                pass
        
        self._schedule_next()

# ============================================================================
# FUNÇÕES UTILITÁRIAS
# ============================================================================

def get_system_info() -> dict:
    """Retorna informações do sistema"""
    try:
        return {
            'cpu_count': psutil.cpu_count(),
            'memory_total_mb': psutil.virtual_memory().total / (1024 * 1024),
            'memory_available_mb': psutil.virtual_memory().available / (1024 * 1024),
            'disk_free_mb': psutil.disk_usage('/').free / (1024 * 1024),
            'python_version': sys.version
        }
    except:
        return {}

def is_safe_to_proceed() -> tuple[bool, str]:
    """
    Verifica se é seguro prosseguir com operações
    
    Returns:
        Tupla (seguro, mensagem)
    """
    monitor = ResourceMonitor()
    
    # Verifica recursos
    ok, msg = monitor.check_resources()
    if not ok:
        return False, msg
    
    # Verifica espaço em disco
    try:
        disk = psutil.disk_usage('/')
        if disk.percent > 95:
            return False, "Espaço em disco crítico"
    except:
        pass
    
    return True, "OK"
