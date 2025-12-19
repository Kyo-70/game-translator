"""
Módulo de Gerenciamento de Perfis de Regex
Permite criar, editar e aplicar perfis personalizados de extração de texto
"""

import json
import os
import re
from typing import List, Dict, Optional

class RegexProfile:
    """Representa um perfil de regex para extração de texto"""
    
    def __init__(self, name: str, description: str = "", 
                 capture_patterns: List[str] = None,
                 exclude_patterns: List[str] = None,
                 file_type: str = "json"):
        """
        Inicializa um perfil de regex
        
        Args:
            name: Nome do perfil
            description: Descrição do perfil
            capture_patterns: Lista de padrões regex para capturar texto
            exclude_patterns: Lista de padrões regex para excluir texto
            file_type: Tipo de arquivo (json ou xml)
        """
        self.name = name
        self.description = description
        self.capture_patterns = capture_patterns or []
        self.exclude_patterns = exclude_patterns or []
        self.file_type = file_type
    
    def to_dict(self) -> dict:
        """Converte o perfil para dicionário"""
        return {
            'name': self.name,
            'description': self.description,
            'capture_patterns': self.capture_patterns,
            'exclude_patterns': self.exclude_patterns,
            'file_type': self.file_type
        }
    
    @classmethod
    def from_dict(cls, data: dict) -> 'RegexProfile':
        """Cria um perfil a partir de um dicionário"""
        return cls(
            name=data.get('name', ''),
            description=data.get('description', ''),
            capture_patterns=data.get('capture_patterns', []),
            exclude_patterns=data.get('exclude_patterns', []),
            file_type=data.get('file_type', 'json')
        )

class RegexProfileManager:
    """Gerencia perfis de regex"""
    
    def __init__(self, profiles_dir: str = "profiles"):
        """
        Inicializa o gerenciador de perfis
        
        Args:
            profiles_dir: Diretório para armazenar perfis
        """
        self.profiles_dir = profiles_dir
        self.profiles: Dict[str, RegexProfile] = {}
        
        # Cria diretório se não existir
        os.makedirs(profiles_dir, exist_ok=True)
        
        # Carrega perfis padrão
        self._create_default_profiles()
        
        # Carrega perfis salvos
        self.load_all_profiles()
    
    def _create_default_profiles(self):
        """Cria perfis padrão para tipos comuns de arquivos"""
        
        # Perfil para JSON genérico
        json_profile = RegexProfile(
            name="JSON Genérico",
            description="Extrai valores de strings em arquivos JSON",
            capture_patterns=[
                r'"([^"]+)"\s*:\s*"([^"]+)"',  # "key": "value"
                r':\s*"([^"]+)"'  # : "value"
            ],
            exclude_patterns=[
                r'"id"\s*:\s*"[^"]+"',  # Ignora IDs
                r'"key"\s*:\s*"[^"]+"',  # Ignora chaves
                r'"name"\s*:\s*"[a-z_]+"',  # Ignora nomes técnicos
                r'"type"\s*:\s*"[^"]+"'  # Ignora tipos
            ],
            file_type="json"
        )
        
        # Perfil para XML genérico
        xml_profile = RegexProfile(
            name="XML Genérico",
            description="Extrai conteúdo de tags XML",
            capture_patterns=[
                r'>([^<>]+)<',  # >text<
                r'<([a-zA-Z_]+)>([^<>]+)</\1>',  # <tag>text</tag>
            ],
            exclude_patterns=[
                r'<id>.*?</id>',  # Ignora tags ID
                r'<key>.*?</key>',  # Ignora tags key
                r'<!--.*?-->',  # Ignora comentários
            ],
            file_type="xml"
        )
        
        # Perfil para Bannerlord XML
        bannerlord_profile = RegexProfile(
            name="Bannerlord XML",
            description="Perfil específico para arquivos XML do Mount & Blade II: Bannerlord",
            capture_patterns=[
                r'text="([^"]+)"',  # text="value"
                r'<string[^>]*>([^<]+)</string>',  # <string>value</string>
            ],
            exclude_patterns=[
                r'id="[^"]+"',
                r'key="[^"]+"',
                r'<!--.*?-->',
            ],
            file_type="xml"
        )
        
        # Perfil para RimWorld XML
        rimworld_profile = RegexProfile(
            name="RimWorld XML",
            description="Perfil específico para arquivos XML do RimWorld",
            capture_patterns=[
                r'<label>([^<]+)</label>',
                r'<description>([^<]+)</description>',
                r'<[a-zA-Z_]+>([^<>]+)</[a-zA-Z_]+>',
            ],
            exclude_patterns=[
                r'<defName>.*?</defName>',
                r'<!--.*?-->',
            ],
            file_type="xml"
        )
        
        # Salva perfis padrão
        for profile in [json_profile, xml_profile, bannerlord_profile, rimworld_profile]:
            self.save_profile(profile)
    
    def save_profile(self, profile: RegexProfile) -> bool:
        """
        Salva um perfil em arquivo
        
        Args:
            profile: Perfil a ser salvo
            
        Returns:
            True se salvou com sucesso
        """
        try:
            filepath = os.path.join(self.profiles_dir, f"{profile.name}.json")
            
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(profile.to_dict(), f, indent=2, ensure_ascii=False)
            
            self.profiles[profile.name] = profile
            return True
        except Exception as e:
            print(f"Erro ao salvar perfil: {e}")
            return False
    
    def load_profile(self, filepath: str) -> Optional[RegexProfile]:
        """
        Carrega um perfil de arquivo
        
        Args:
            filepath: Caminho do arquivo
            
        Returns:
            Perfil carregado ou None
        """
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            profile = RegexProfile.from_dict(data)
            self.profiles[profile.name] = profile
            return profile
        except Exception as e:
            print(f"Erro ao carregar perfil: {e}")
            return None
    
    def load_all_profiles(self):
        """Carrega todos os perfis do diretório"""
        try:
            for filename in os.listdir(self.profiles_dir):
                if filename.endswith('.json'):
                    filepath = os.path.join(self.profiles_dir, filename)
                    self.load_profile(filepath)
        except Exception as e:
            print(f"Erro ao carregar perfis: {e}")
    
    def get_profile(self, name: str) -> Optional[RegexProfile]:
        """
        Obtém um perfil pelo nome
        
        Args:
            name: Nome do perfil
            
        Returns:
            Perfil ou None
        """
        return self.profiles.get(name)
    
    def get_all_profile_names(self) -> List[str]:
        """Retorna lista com nomes de todos os perfis"""
        return list(self.profiles.keys())
    
    def delete_profile(self, name: str) -> bool:
        """
        Deleta um perfil
        
        Args:
            name: Nome do perfil
            
        Returns:
            True se deletou com sucesso
        """
        try:
            filepath = os.path.join(self.profiles_dir, f"{name}.json")
            
            if os.path.exists(filepath):
                os.remove(filepath)
            
            if name in self.profiles:
                del self.profiles[name]
            
            return True
        except Exception as e:
            print(f"Erro ao deletar perfil: {e}")
            return False
