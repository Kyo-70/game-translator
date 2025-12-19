"""
Módulo de Tradução Inteligente
Implementa lógica de reaproveitamento automático e padrões numéricos
"""

import re
from typing import Dict, Optional, List
from database import TranslationMemory

class SmartTranslator:
    """Gerencia tradução inteligente com reaproveitamento automático"""
    
    def __init__(self, translation_memory: TranslationMemory):
        """
        Inicializa o tradutor inteligente
        
        Args:
            translation_memory: Instância da memória de tradução
        """
        self.memory = translation_memory
        self.pattern_cache: Dict[str, str] = {}
    
    def translate(self, text: str) -> Optional[str]:
        """
        Traduz um texto usando memória e padrões inteligentes
        
        Args:
            text: Texto a ser traduzido
            
        Returns:
            Tradução ou None se não encontrada
        """
        # 1. Busca exata na memória
        exact_match = self.memory.get_translation(text)
        if exact_match:
            return exact_match
        
        # 2. Busca por padrão numérico
        pattern_match = self._find_numeric_pattern(text)
        if pattern_match:
            return pattern_match
        
        # 3. Busca por padrão de variação
        variation_match = self._find_variation_pattern(text)
        if variation_match:
            return variation_match
        
        return None
    
    def _find_numeric_pattern(self, text: str) -> Optional[str]:
        """
        Busca padrões com números (ex: "Soldier 1" -> "Soldado 1")
        
        Args:
            text: Texto a ser verificado
            
        Returns:
            Tradução com número preservado ou None
        """
        # Padrão: texto seguido de número
        match = re.match(r'^(.+?)\s*(\d+)$', text)
        if not match:
            return None
        
        base_text = match.group(1).strip()
        number = match.group(2)
        
        # Busca tradução do texto base
        base_translation = self.memory.get_translation(base_text)
        if base_translation:
            # Retorna tradução com número preservado
            return f"{base_translation} {number}"
        
        # Busca por exemplos similares (ex: "Soldier 1", "Soldier 2")
        similar_translations = self._find_similar_numeric_patterns(base_text)
        if similar_translations:
            # Usa o padrão encontrado
            translated_base = similar_translations[0]
            return f"{translated_base} {number}"
        
        return None
    
    def _find_similar_numeric_patterns(self, base_text: str) -> List[str]:
        """
        Busca padrões numéricos similares na memória
        
        Args:
            base_text: Texto base (sem número)
            
        Returns:
            Lista de traduções base encontradas
        """
        results = []
        
        # Busca na memória por padrões como "base_text 1", "base_text 2", etc.
        for i in range(1, 10):  # Verifica até 10
            pattern = f"{base_text} {i}"
            translation = self.memory.get_translation(pattern)
            
            if translation:
                # Extrai a parte traduzida sem o número
                match = re.match(r'^(.+?)\s*\d+$', translation)
                if match:
                    translated_base = match.group(1).strip()
                    if translated_base not in results:
                        results.append(translated_base)
        
        return results
    
    def _find_variation_pattern(self, text: str) -> Optional[str]:
        """
        Busca padrões de variação (ex: "Heavy Armor" baseado em "Light Armor")
        
        Args:
            text: Texto a ser verificado
            
        Returns:
            Tradução baseada em padrão ou None
        """
        # Lista de prefixos/sufixos comuns
        variations = [
            ('Light', 'Heavy'), ('Small', 'Large'), ('Minor', 'Major'),
            ('Weak', 'Strong'), ('Basic', 'Advanced'), ('Old', 'New'),
            ('Young', 'Old'), ('Male', 'Female'), ('Upper', 'Lower')
        ]
        
        for var1, var2 in variations:
            # Verifica se o texto contém uma variação
            if var1 in text:
                # Busca a outra variação
                alternative = text.replace(var1, var2)
                alt_translation = self.memory.get_translation(alternative)
                
                if alt_translation and var2 in alt_translation:
                    # Aplica a mesma transformação
                    result = alt_translation.replace(var2, var1)
                    return result
            
            elif var2 in text:
                # Verifica variação inversa
                alternative = text.replace(var2, var1)
                alt_translation = self.memory.get_translation(alternative)
                
                if alt_translation and var1 in alt_translation:
                    result = alt_translation.replace(var1, var2)
                    return result
        
        return None
    
    def batch_translate(self, texts: List[str]) -> Dict[str, str]:
        """
        Traduz múltiplos textos de uma vez
        
        Args:
            texts: Lista de textos
            
        Returns:
            Dicionário {original: tradução}
        """
        results = {}
        
        for text in texts:
            translation = self.translate(text)
            if translation:
                results[text] = translation
        
        return results
    
    def learn_pattern(self, original: str, translated: str):
        """
        Aprende um novo padrão de tradução
        
        Args:
            original: Texto original
            translated: Texto traduzido
        """
        # Adiciona à memória
        self.memory.add_translation(original, translated)
        
        # Detecta e armazena padrão numérico
        match_orig = re.match(r'^(.+?)\s*(\d+)$', original)
        match_trans = re.match(r'^(.+?)\s*(\d+)$', translated)
        
        if match_orig and match_trans:
            base_orig = match_orig.group(1).strip()
            base_trans = match_trans.group(1).strip()
            
            # Armazena o padrão base
            self.pattern_cache[base_orig] = base_trans
    
    def auto_translate_batch(self, texts: List[str]) -> Dict[str, str]:
        """
        Traduz automaticamente um lote de textos usando padrões aprendidos
        
        Args:
            texts: Lista de textos
            
        Returns:
            Dicionário com traduções automáticas
        """
        results = {}
        
        # Agrupa textos por padrão
        patterns = {}
        
        for text in texts:
            # Verifica se já tem tradução
            existing = self.translate(text)
            if existing:
                results[text] = existing
                continue
            
            # Detecta padrão
            match = re.match(r'^(.+?)\s*(\d+)$', text)
            if match:
                base = match.group(1).strip()
                number = match.group(2)
                
                if base not in patterns:
                    patterns[base] = []
                patterns[base].append((text, number))
        
        # Processa padrões
        for base, items in patterns.items():
            # Busca tradução do base
            base_translation = None
            
            # Tenta encontrar tradução de qualquer variação
            for text, num in items:
                test_pattern = f"{base} {num}"
                trans = self.memory.get_translation(test_pattern)
                
                if trans:
                    match = re.match(r'^(.+?)\s*\d+$', trans)
                    if match:
                        base_translation = match.group(1).strip()
                        break
            
            # Aplica tradução a todas as variações
            if base_translation:
                for text, num in items:
                    results[text] = f"{base_translation} {num}"
        
        return results
