"""
Módulo de Tradução Inteligente
Implementa lógica de reaproveitamento automático e padrões numéricos
Inclui memória sensível a padrões (ativável/desativável)
"""

import re
from typing import Dict, Optional, List, Tuple
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
        
        # Configuração da memória sensível a padrões
        self._sensitive_memory_enabled = True  # Ativado por padrão
    
    # ============================================================================
    # CONFIGURAÇÃO DA MEMÓRIA SENSÍVEL
    # ============================================================================
    
    def is_sensitive_memory_enabled(self) -> bool:
        """
        Verifica se a memória sensível a padrões está ativada.
        
        Returns:
            True se a memória sensível está ativada
        """
        return self._sensitive_memory_enabled
    
    def set_sensitive_memory_enabled(self, enabled: bool):
        """
        Ativa ou desativa a memória sensível a padrões.
        
        Quando ativada, a memória sensível permite traduzir automaticamente
        textos que seguem padrões similares a traduções existentes.
        
        Exemplo:
            - Se "Soldier 01" foi traduzido para "Soldado 01"
            - "Soldier 02", "Soldier 03", etc. serão automaticamente traduzidos
              para "Soldado 02", "Soldado 03", etc.
        
        Args:
            enabled: True para ativar, False para desativar
        """
        self._sensitive_memory_enabled = enabled
    
    def toggle_sensitive_memory(self) -> bool:
        """
        Alterna o estado da memória sensível.
        
        Returns:
            Novo estado (True = ativado, False = desativado)
        """
        self._sensitive_memory_enabled = not self._sensitive_memory_enabled
        return self._sensitive_memory_enabled
    
    # ============================================================================
    # TRADUÇÃO PRINCIPAL
    # ============================================================================
    
    def translate(self, text: str) -> Optional[str]:
        """
        Traduz um texto usando memória e padrões inteligentes
        
        Args:
            text: Texto a ser traduzido
            
        Returns:
            Tradução ou None se não encontrada
        """
        result, _ = self.translate_with_info(text)
        return result
    
    def translate_with_info(self, text: str) -> Tuple[Optional[str], bool]:
        """
        Traduz um texto e informa se foi traduzido por padrão.
        
        Args:
            text: Texto a ser traduzido
            
        Returns:
            Tupla (tradução, foi_por_padrao)
            - tradução: Texto traduzido ou None
            - foi_por_padrao: True se foi traduzido por memória sensível/padrão
        """
        # 1. Busca exata na memória
        exact_match = self.memory.get_translation(text)
        if exact_match:
            return exact_match, False  # Tradução exata, não foi por padrão
        
        # 2. Se memória sensível está ativada, busca por padrões
        if self._sensitive_memory_enabled:
            # 2.1 Busca por padrão numérico sensível (ex: Soldier 01 -> Soldado 01)
            sensitive_match = self._find_sensitive_numeric_pattern(text)
            if sensitive_match:
                return sensitive_match, True  # Traduzido por padrão
            
            # 2.2 Busca por padrão numérico simples
            pattern_match = self._find_numeric_pattern(text)
            if pattern_match:
                return pattern_match, True  # Traduzido por padrão
            
            # 2.3 Busca por padrão de variação
            variation_match = self._find_variation_pattern(text)
            if variation_match:
                return variation_match, True  # Traduzido por padrão
        
        return None, False
    
    # ============================================================================
    # MEMÓRIA SENSÍVEL A PADRÕES
    # ============================================================================
    
    def _find_sensitive_numeric_pattern(self, text: str) -> Optional[str]:
        """
        Busca padrões numéricos sensíveis na memória.
        
        Esta função identifica textos que seguem o padrão "Base XX" onde XX é um número
        (com ou sem zeros à esquerda) e tenta encontrar uma tradução baseada em
        traduções existentes de padrões similares.
        
        Exemplos:
            - "Soldier 01" traduzido como "Soldado 01" -> "Soldier 02" será "Soldado 02"
            - "Item_001" traduzido como "Item_001" -> "Item_002" será "Item_002"
            - "Level 1" traduzido como "Nível 1" -> "Level 2" será "Nível 2"
        
        Args:
            text: Texto a ser verificado
            
        Returns:
            Tradução com número preservado ou None
        """
        # Padrões suportados:
        # 1. "Base XX" (com espaço e número com zeros à esquerda)
        # 2. "Base_XX" (com underscore e número)
        # 3. "BaseXX" (sem separador)
        # 4. "Base XX" (número simples)
        
        patterns = [
            # Padrão com espaço e número (com ou sem zeros): "Soldier 01", "Soldier 1"
            (r'^(.+?)\s+(\d+)$', ' '),
            # Padrão com underscore: "Item_01", "Item_001"
            (r'^(.+?)_(\d+)$', '_'),
            # Padrão com hífen: "Level-01", "Level-1"
            (r'^(.+?)-(\d+)$', '-'),
            # Padrão colado (apenas se terminar em número): "Soldier01"
            (r'^(.+?)(\d+)$', ''),
        ]
        
        for pattern, separator in patterns:
            match = re.match(pattern, text)
            if match:
                base_text = match.group(1).strip()
                number_str = match.group(2)
                
                # Preserva formato do número (zeros à esquerda)
                number_format = len(number_str)
                
                # Busca traduções similares na memória
                translation = self._find_translation_by_pattern(
                    base_text, separator, number_format
                )
                
                if translation:
                    translated_base, trans_separator = translation
                    # Reconstrói com o número original preservando formato
                    return f"{translated_base}{trans_separator}{number_str}"
        
        return None
    
    def _find_translation_by_pattern(
        self, 
        base_text: str, 
        separator: str, 
        number_format: int
    ) -> Optional[Tuple[str, str]]:
        """
        Busca uma tradução existente que siga o mesmo padrão.
        
        Args:
            base_text: Texto base (sem número)
            separator: Separador usado (espaço, underscore, hífen, vazio)
            number_format: Quantidade de dígitos no número original
            
        Returns:
            Tupla (base_traduzida, separador_usado) ou None
        """
        # Gera números de teste no mesmo formato
        test_numbers = []
        
        # Testa números de 0 a 99 no formato apropriado
        for i in range(100):
            if number_format > 1:
                # Formato com zeros à esquerda
                test_numbers.append(str(i).zfill(number_format))
            else:
                test_numbers.append(str(i))
        
        # Também testa alguns números comuns
        test_numbers.extend(['1', '01', '001', '2', '02', '002', '10', '100'])
        test_numbers = list(set(test_numbers))  # Remove duplicatas
        
        for test_num in test_numbers:
            # Constrói o texto de teste
            if separator:
                test_text = f"{base_text}{separator}{test_num}"
            else:
                test_text = f"{base_text}{test_num}"
            
            # Busca tradução
            translation = self.memory.get_translation(test_text)
            
            if translation:
                # Extrai a base traduzida
                extracted = self._extract_translated_base(translation, test_num)
                if extracted:
                    return extracted
        
        return None
    
    def _extract_translated_base(
        self, 
        translation: str, 
        original_number: str
    ) -> Optional[Tuple[str, str]]:
        """
        Extrai a base traduzida e o separador de uma tradução.
        
        Args:
            translation: Texto traduzido completo
            original_number: Número original para referência
            
        Returns:
            Tupla (base_traduzida, separador) ou None
        """
        # Tenta extrair com diferentes separadores
        patterns = [
            (r'^(.+?)\s+(\d+)$', ' '),      # Espaço
            (r'^(.+?)_(\d+)$', '_'),         # Underscore
            (r'^(.+?)-(\d+)$', '-'),         # Hífen
            (r'^(.+?)(\d+)$', ''),           # Sem separador
        ]
        
        for pattern, separator in patterns:
            match = re.match(pattern, translation)
            if match:
                translated_base = match.group(1).strip() if separator else match.group(1)
                trans_number = match.group(2)
                
                # Verifica se o número corresponde
                if trans_number == original_number or int(trans_number) == int(original_number):
                    return (translated_base, separator)
        
        return None
    
    # ============================================================================
    # PADRÕES NUMÉRICOS SIMPLES
    # ============================================================================
    
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
    
    # ============================================================================
    # PADRÕES DE VARIAÇÃO
    # ============================================================================
    
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
    
    # ============================================================================
    # TRADUÇÃO EM LOTE
    # ============================================================================
    
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
        results, _ = self.auto_translate_batch_with_info(texts)
        return results
    
    def auto_translate_batch_with_info(self, texts: List[str]) -> Tuple[Dict[str, str], Dict[str, bool]]:
        """
        Traduz automaticamente um lote de textos e informa quais foram por padrão.
        
        Args:
            texts: Lista de textos
            
        Returns:
            Tupla (traduções, padrões)
            - traduções: Dicionário {original: tradução}
            - padrões: Dicionário {original: foi_por_padrao}
        """
        results = {}
        pattern_info = {}
        
        # Agrupa textos por padrão
        patterns = {}
        
        for text in texts:
            # Verifica se já tem tradução
            existing, was_pattern = self.translate_with_info(text)
            if existing:
                results[text] = existing
                pattern_info[text] = was_pattern
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
                    pattern_info[text] = True  # Traduzido por padrão
        
        return results, pattern_info
    
    # ============================================================================
    # UTILITÁRIOS
    # ============================================================================
    
    def get_pattern_suggestions(self, text: str) -> List[Dict[str, str]]:
        """
        Retorna sugestões de tradução baseadas em padrões encontrados.
        
        Útil para mostrar ao usuário quais padrões foram identificados
        e como seriam traduzidos.
        
        Args:
            text: Texto para analisar
            
        Returns:
            Lista de dicionários com sugestões:
            [{'pattern': 'Soldier XX', 'suggestion': 'Soldado XX', 'confidence': 'high'}]
        """
        suggestions = []
        
        if not self._sensitive_memory_enabled:
            return suggestions
        
        # Analisa padrões numéricos
        patterns = [
            (r'^(.+?)\s+(\d+)$', ' ', 'espaço'),
            (r'^(.+?)_(\d+)$', '_', 'underscore'),
            (r'^(.+?)-(\d+)$', '-', 'hífen'),
        ]
        
        for pattern, separator, sep_name in patterns:
            match = re.match(pattern, text)
            if match:
                base_text = match.group(1).strip()
                number_str = match.group(2)
                
                translation = self._find_translation_by_pattern(
                    base_text, separator, len(number_str)
                )
                
                if translation:
                    translated_base, trans_separator = translation
                    suggestions.append({
                        'pattern': f"{base_text}{separator}XX",
                        'suggestion': f"{translated_base}{trans_separator}XX",
                        'confidence': 'alta',
                        'separator': sep_name
                    })
        
        return suggestions
