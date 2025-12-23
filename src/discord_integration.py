"""
Integração com Discord Rich Presence
Mostra status "Traduzindo com Game Translator" no Discord
"""

import time
import threading
from typing import Optional, Callable
from enum import Enum

try:
    from pypresence import Presence
    from pypresence.exceptions import DiscordNotFound, DiscordError
    DISCORD_AVAILABLE = True
except ImportError:
    DISCORD_AVAILABLE = False
    Presence = None
    DiscordNotFound = Exception
    DiscordError = Exception


class DiscordStatus(Enum):
    """Estados possíveis para exibir no Discord"""
    IDLE = "idle"
    TRANSLATING = "translating"
    EDITING = "editing"
    SAVING = "saving"


class DiscordRichPresence:
    """
    Gerenciador de Discord Rich Presence para o Game Translator.

    Mostra o status atual do usuário no Discord enquanto usa o aplicativo.
    """

    # Client ID da aplicação Discord (precisa ser registrado no Discord Developer Portal)
    # Para criar um: https://discord.com/developers/applications
    # Substitua pelo seu Application ID
    CLIENT_ID = "1319736847755501568"  # Game Translator Application ID

    def __init__(self, on_status_change: Optional[Callable[[bool, str], None]] = None):
        """
        Inicializa o Discord Rich Presence.

        Args:
            on_status_change: Callback chamado quando o status de conexão muda
                             (connected: bool, message: str)
        """
        self._rpc: Optional[Presence] = None
        self._connected = False
        self._enabled = True
        self._current_status = DiscordStatus.IDLE
        self._current_file: Optional[str] = None
        self._start_time: Optional[int] = None
        self._translation_count = 0
        self._on_status_change = on_status_change
        self._update_thread: Optional[threading.Thread] = None
        self._running = False

    @property
    def is_available(self) -> bool:
        """Verifica se a biblioteca pypresence está disponível"""
        return DISCORD_AVAILABLE

    @property
    def is_connected(self) -> bool:
        """Verifica se está conectado ao Discord"""
        return self._connected

    @property
    def is_enabled(self) -> bool:
        """Verifica se o Rich Presence está habilitado"""
        return self._enabled

    def set_enabled(self, enabled: bool):
        """Habilita ou desabilita o Rich Presence"""
        self._enabled = enabled
        if not enabled and self._connected:
            self.disconnect()
        elif enabled and not self._connected:
            self.connect()

    def connect(self) -> bool:
        """
        Conecta ao Discord.

        Returns:
            True se conectou com sucesso, False caso contrário
        """
        if not DISCORD_AVAILABLE:
            self._notify_status(False, "Biblioteca pypresence não instalada")
            return False

        if not self._enabled:
            return False

        if self._connected:
            return True

        try:
            self._rpc = Presence(self.CLIENT_ID)
            self._rpc.connect()
            self._connected = True
            self._start_time = int(time.time())

            # Atualiza status inicial
            self._update_presence()

            self._notify_status(True, "Conectado ao Discord")
            return True

        except DiscordNotFound:
            self._notify_status(False, "Discord não está aberto")
            return False
        except DiscordError as e:
            self._notify_status(False, f"Erro ao conectar: {str(e)}")
            return False
        except Exception as e:
            self._notify_status(False, f"Erro inesperado: {str(e)}")
            return False

    def disconnect(self):
        """Desconecta do Discord"""
        if self._rpc and self._connected:
            try:
                self._rpc.clear()
                self._rpc.close()
            except Exception:
                pass
            finally:
                self._rpc = None
                self._connected = False
                self._notify_status(False, "Desconectado do Discord")

    def set_status(self, status: DiscordStatus, file_name: Optional[str] = None,
                   translation_count: int = 0):
        """
        Define o status atual para exibir no Discord.

        Args:
            status: Estado atual (IDLE, TRANSLATING, EDITING, SAVING)
            file_name: Nome do arquivo sendo traduzido
            translation_count: Número de traduções feitas
        """
        self._current_status = status
        self._current_file = file_name
        self._translation_count = translation_count

        if self._connected:
            self._update_presence()

    def set_translating(self, file_name: str, translated_count: int = 0, total_count: int = 0):
        """
        Define status como traduzindo um arquivo.

        Args:
            file_name: Nome do arquivo sendo traduzido
            translated_count: Número de entradas traduzidas
            total_count: Total de entradas
        """
        self._current_status = DiscordStatus.TRANSLATING
        self._current_file = file_name
        self._translation_count = translated_count

        if self._connected:
            self._update_presence(
                details=f"Traduzindo: {file_name}",
                state=f"{translated_count}/{total_count} entradas" if total_count > 0 else "Editando traduções"
            )

    def set_idle(self):
        """Define status como ocioso (aguardando arquivo)"""
        self._current_status = DiscordStatus.IDLE
        self._current_file = None

        if self._connected:
            self._update_presence(
                details="Aguardando arquivo",
                state="Pronto para traduzir"
            )

    def set_saving(self, file_name: str):
        """Define status como salvando arquivo"""
        self._current_status = DiscordStatus.SAVING
        self._current_file = file_name

        if self._connected:
            self._update_presence(
                details=f"Salvando: {file_name}",
                state="Aplicando traduções..."
            )

    def _update_presence(self, details: Optional[str] = None, state: Optional[str] = None):
        """Atualiza o Rich Presence no Discord"""
        if not self._connected or not self._rpc:
            return

        try:
            # Define textos padrão baseado no status
            if details is None:
                if self._current_status == DiscordStatus.IDLE:
                    details = "Aguardando arquivo"
                elif self._current_status == DiscordStatus.TRANSLATING:
                    details = f"Traduzindo: {self._current_file or 'arquivo'}"
                elif self._current_status == DiscordStatus.EDITING:
                    details = f"Editando: {self._current_file or 'arquivo'}"
                elif self._current_status == DiscordStatus.SAVING:
                    details = f"Salvando: {self._current_file or 'arquivo'}"

            if state is None:
                if self._current_status == DiscordStatus.IDLE:
                    state = "Pronto para traduzir"
                elif self._translation_count > 0:
                    state = f"{self._translation_count} traduções"
                else:
                    state = "Traduzindo jogos e mods"

            self._rpc.update(
                details=details[:128] if details else None,  # Discord limita a 128 chars
                state=state[:128] if state else None,
                start=self._start_time,
                large_image="game_translator_logo",  # Nome da imagem no Discord Developer Portal
                large_text="Game Translator - Tradutor de Jogos e Mods",
                small_image="translating",
                small_text="Traduzindo...",
                buttons=[
                    {"label": "Game Translator", "url": "https://github.com/Kyo-70/Tradutor_XML-JSON"}
                ]
            )
        except Exception:
            # Ignora erros de atualização (conexão pode ter caído)
            pass

    def _notify_status(self, connected: bool, message: str):
        """Notifica sobre mudança de status"""
        if self._on_status_change:
            try:
                self._on_status_change(connected, message)
            except Exception:
                pass

    def __del__(self):
        """Cleanup ao destruir o objeto"""
        self.disconnect()


# Instância global para fácil acesso
_discord_rpc: Optional[DiscordRichPresence] = None


def get_discord_rpc() -> DiscordRichPresence:
    """Retorna a instância global do Discord Rich Presence"""
    global _discord_rpc
    if _discord_rpc is None:
        _discord_rpc = DiscordRichPresence()
    return _discord_rpc


def init_discord(on_status_change: Optional[Callable[[bool, str], None]] = None) -> DiscordRichPresence:
    """
    Inicializa e conecta ao Discord Rich Presence.

    Args:
        on_status_change: Callback para mudanças de status

    Returns:
        Instância do DiscordRichPresence
    """
    global _discord_rpc
    _discord_rpc = DiscordRichPresence(on_status_change)
    _discord_rpc.connect()
    return _discord_rpc
