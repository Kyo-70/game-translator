"""
Módulo de API de Tradução
Suporte para tradução automática via DeepL e Google Translate
"""

import requests
from typing import List, Optional, Dict
import time

class TranslationAPI:
    """Classe base para APIs de tradução"""
    
    def translate(self, text: str, source_lang: str = 'en', 
                 target_lang: str = 'pt') -> Optional[str]:
        """
        Traduz um texto
        
        Args:
            text: Texto a ser traduzido
            source_lang: Idioma de origem
            target_lang: Idioma de destino
            
        Returns:
            Texto traduzido ou None
        """
        raise NotImplementedError
    
    def translate_batch(self, texts: List[str], source_lang: str = 'en',
                       target_lang: str = 'pt') -> Dict[str, str]:
        """
        Traduz múltiplos textos
        
        Args:
            texts: Lista de textos
            source_lang: Idioma de origem
            target_lang: Idioma de destino
            
        Returns:
            Dicionário {original: tradução}
        """
        raise NotImplementedError

class DeepLTranslator(TranslationAPI):
    """Tradutor usando API do DeepL"""
    
    def __init__(self, api_key: str):
        """
        Inicializa o tradutor DeepL
        
        Args:
            api_key: Chave da API DeepL
        """
        self.api_key = api_key
        self.base_url = "https://api-free.deepl.com/v2/translate"
        
        # Mapeamento de códigos de idioma
        self.lang_map = {
            'en': 'EN',
            'pt': 'PT-BR',
            'es': 'ES',
            'fr': 'FR',
            'de': 'DE',
            'it': 'IT',
            'ja': 'JA',
            'zh': 'ZH'
        }
    
    def translate(self, text: str, source_lang: str = 'en',
                 target_lang: str = 'pt') -> Optional[str]:
        """Traduz um texto usando DeepL"""
        if not text or not text.strip():
            return text
        
        try:
            # Mapeia códigos de idioma
            target = self.lang_map.get(target_lang, target_lang.upper())
            
            params = {
                'auth_key': self.api_key,
                'text': text,
                'target_lang': target
            }
            
            response = requests.post(self.base_url, data=params, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                if 'translations' in data and len(data['translations']) > 0:
                    return data['translations'][0]['text']
            else:
                print(f"Erro DeepL: {response.status_code} - {response.text}")
            
            return None
            
        except Exception as e:
            print(f"Erro ao traduzir com DeepL: {e}")
            return None
    
    def translate_batch(self, texts: List[str], source_lang: str = 'en',
                       target_lang: str = 'pt', delay: float = 0.1) -> Dict[str, str]:
        """Traduz múltiplos textos com DeepL"""
        results = {}
        
        for text in texts:
            if text and text.strip():
                translation = self.translate(text, source_lang, target_lang)
                if translation:
                    results[text] = translation
                
                # Pequeno delay para respeitar rate limits
                time.sleep(delay)
        
        return results

class GoogleTranslator(TranslationAPI):
    """Tradutor usando API do Google Translate"""
    
    def __init__(self, api_key: str):
        """
        Inicializa o tradutor Google
        
        Args:
            api_key: Chave da API Google Cloud Translation
        """
        self.api_key = api_key
        self.base_url = "https://translation.googleapis.com/language/translate/v2"
    
    def translate(self, text: str, source_lang: str = 'en',
                 target_lang: str = 'pt') -> Optional[str]:
        """Traduz um texto usando Google Translate"""
        if not text or not text.strip():
            return text
        
        try:
            params = {
                'key': self.api_key,
                'q': text,
                'source': source_lang,
                'target': target_lang,
                'format': 'text'
            }
            
            response = requests.post(self.base_url, params=params, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                if 'data' in data and 'translations' in data['data']:
                    translations = data['data']['translations']
                    if len(translations) > 0:
                        return translations[0]['translatedText']
            else:
                print(f"Erro Google: {response.status_code} - {response.text}")
            
            return None
            
        except Exception as e:
            print(f"Erro ao traduzir com Google: {e}")
            return None
    
    def translate_batch(self, texts: List[str], source_lang: str = 'en',
                       target_lang: str = 'pt') -> Dict[str, str]:
        """Traduz múltiplos textos com Google Translate (suporta batch nativo)"""
        if not texts:
            return {}
        
        try:
            # Google suporta múltiplas queries em uma chamada
            params = {
                'key': self.api_key,
                'q': texts,
                'source': source_lang,
                'target': target_lang,
                'format': 'text'
            }
            
            response = requests.post(self.base_url, params=params, timeout=30)
            
            if response.status_code == 200:
                data = response.json()
                if 'data' in data and 'translations' in data['data']:
                    translations = data['data']['translations']
                    
                    results = {}
                    for i, translation in enumerate(translations):
                        if i < len(texts):
                            results[texts[i]] = translation['translatedText']
                    
                    return results
            else:
                print(f"Erro Google Batch: {response.status_code}")
            
            return {}
            
        except Exception as e:
            print(f"Erro ao traduzir batch com Google: {e}")
            return {}

class TranslationAPIManager:
    """Gerencia diferentes APIs de tradução"""
    
    def __init__(self):
        """Inicializa o gerenciador"""
        self.apis: Dict[str, TranslationAPI] = {}
        self.active_api: Optional[str] = None
    
    def add_deepl(self, api_key: str):
        """Adiciona API DeepL"""
        self.apis['deepl'] = DeepLTranslator(api_key)
        if not self.active_api:
            self.active_api = 'deepl'
    
    def add_google(self, api_key: str):
        """Adiciona API Google"""
        self.apis['google'] = GoogleTranslator(api_key)
        if not self.active_api:
            self.active_api = 'google'
    
    def set_active_api(self, api_name: str):
        """Define a API ativa"""
        if api_name in self.apis:
            self.active_api = api_name
            return True
        return False
    
    def translate(self, text: str, source_lang: str = 'en',
                 target_lang: str = 'pt') -> Optional[str]:
        """Traduz usando a API ativa"""
        if self.active_api and self.active_api in self.apis:
            return self.apis[self.active_api].translate(text, source_lang, target_lang)
        return None
    
    def translate_batch(self, texts: List[str], source_lang: str = 'en',
                       target_lang: str = 'pt') -> Dict[str, str]:
        """Traduz múltiplos textos usando a API ativa"""
        if self.active_api and self.active_api in self.apis:
            return self.apis[self.active_api].translate_batch(texts, source_lang, target_lang)
        return {}
    
    def get_available_apis(self) -> List[str]:
        """Retorna lista de APIs disponíveis"""
        return list(self.apis.keys())
