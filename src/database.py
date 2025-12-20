"""
Módulo de Gerenciamento de Banco de Dados
Responsável pela memória de tradução usando SQLite com arquivo local selecionável
"""

import sqlite3
import os
from typing import Optional, List, Tuple, Dict
from datetime import datetime

class TranslationMemory:
    """Gerencia a memória de tradução persistente em arquivo local"""
    
    def __init__(self, db_path: str = None):
        """
        Inicializa a conexão com o banco de dados
        
        Args:
            db_path: Caminho para o arquivo do banco de dados (.db)
                    Se None, não conecta automaticamente
        """
        self.db_path = db_path
        self.conn = None
        self.cursor = None
        
        if db_path:
            self.connect(db_path)
    
    def connect(self, db_path: str) -> bool:
        """
        Conecta a um arquivo de banco de dados
        
        Args:
            db_path: Caminho para o arquivo .db
            
        Returns:
            True se conectou com sucesso
        """
        try:
            # Fecha conexão anterior se existir
            self.close()
            
            self.db_path = db_path
            self.conn = sqlite3.connect(db_path)
            self.cursor = self.conn.cursor()
            
            # Cria tabelas se não existirem
            self._initialize_tables()
            
            return True
        except Exception as e:
            print(f"Erro ao conectar ao banco de dados: {e}")
            return False
    
    def _initialize_tables(self):
        """Cria as tabelas necessárias no banco de dados"""
        # Tabela principal de traduções
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS translations (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                original_text TEXT NOT NULL UNIQUE,
                translated_text TEXT NOT NULL,
                source_language TEXT DEFAULT 'en',
                target_language TEXT DEFAULT 'pt',
                category TEXT DEFAULT 'general',
                notes TEXT DEFAULT '',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                usage_count INTEGER DEFAULT 1
            )
        ''')
        
        # Tabela de metadados do banco
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS metadata (
                key TEXT PRIMARY KEY,
                value TEXT
            )
        ''')
        
        # Índices para busca rápida
        self.cursor.execute('''
            CREATE INDEX IF NOT EXISTS idx_original_text 
            ON translations(original_text)
        ''')
        
        self.cursor.execute('''
            CREATE INDEX IF NOT EXISTS idx_category 
            ON translations(category)
        ''')
        
        # Insere metadados padrão
        self.cursor.execute('''
            INSERT OR IGNORE INTO metadata (key, value) 
            VALUES ('version', '1.0'), ('created_at', ?)
        ''', (datetime.now().isoformat(),))
        
        self.conn.commit()
    
    def is_connected(self) -> bool:
        """Verifica se está conectado a um banco de dados"""
        return self.conn is not None and self.db_path is not None
    
    def get_db_path(self) -> Optional[str]:
        """Retorna o caminho do banco de dados atual"""
        return self.db_path
    
    def add_translation(self, original: str, translated: str, 
                       source_lang: str = 'en', target_lang: str = 'pt',
                       category: str = 'general', notes: str = '') -> bool:
        """
        Adiciona ou atualiza uma tradução na memória
        
        Args:
            original: Texto original
            translated: Texto traduzido
            source_lang: Idioma de origem
            target_lang: Idioma de destino
            category: Categoria da tradução
            notes: Notas adicionais
            
        Returns:
            True se a operação foi bem-sucedida
        """
        if not self.is_connected():
            return False
        
        try:
            self.cursor.execute('''
                INSERT INTO translations 
                (original_text, translated_text, source_language, target_language, category, notes)
                VALUES (?, ?, ?, ?, ?, ?)
                ON CONFLICT(original_text) DO UPDATE SET
                    translated_text = excluded.translated_text,
                    updated_at = CURRENT_TIMESTAMP,
                    usage_count = usage_count + 1,
                    category = excluded.category,
                    notes = excluded.notes
            ''', (original, translated, source_lang, target_lang, category, notes))
            
            self.conn.commit()
            return True
        except Exception as e:
            print(f"Erro ao adicionar tradução: {e}")
            return False
    
    def get_translation(self, original: str) -> Optional[str]:
        """
        Busca uma tradução na memória
        
        Args:
            original: Texto original
            
        Returns:
            Texto traduzido ou None se não encontrado
        """
        if not self.is_connected():
            return None
        
        try:
            self.cursor.execute('''
                SELECT translated_text FROM translations 
                WHERE original_text = ?
            ''', (original,))
            
            result = self.cursor.fetchone()
            
            if result:
                # Incrementa contador de uso
                self.cursor.execute('''
                    UPDATE translations 
                    SET usage_count = usage_count + 1 
                    WHERE original_text = ?
                ''', (original,))
                self.conn.commit()
                
                return result[0]
            
            return None
        except Exception as e:
            print(f"Erro ao buscar tradução: {e}")
            return None
    
    def get_all_translations(self, category: str = None, 
                            search_term: str = None,
                            limit: int = None,
                            offset: int = 0) -> List[Dict]:
        """
        Retorna todas as traduções com filtros opcionais
        
        Args:
            category: Filtrar por categoria
            search_term: Termo de busca
            limit: Limite de resultados
            offset: Offset para paginação
            
        Returns:
            Lista de dicionários com dados das traduções
        """
        if not self.is_connected():
            return []
        
        try:
            query = '''
                SELECT id, original_text, translated_text, source_language, 
                       target_language, category, notes, created_at, 
                       updated_at, usage_count
                FROM translations 
                WHERE 1=1
            '''
            params = []
            
            if category:
                query += ' AND category = ?'
                params.append(category)
            
            if search_term:
                query += ' AND (original_text LIKE ? OR translated_text LIKE ?)'
                params.extend([f'%{search_term}%', f'%{search_term}%'])
            
            query += ' ORDER BY usage_count DESC, updated_at DESC'
            
            if limit:
                query += ' LIMIT ? OFFSET ?'
                params.extend([limit, offset])
            
            self.cursor.execute(query, params)
            rows = self.cursor.fetchall()
            
            return [
                {
                    'id': row[0],
                    'original_text': row[1],
                    'translated_text': row[2],
                    'source_language': row[3],
                    'target_language': row[4],
                    'category': row[5],
                    'notes': row[6],
                    'created_at': row[7],
                    'updated_at': row[8],
                    'usage_count': row[9]
                }
                for row in rows
            ]
        except Exception as e:
            print(f"Erro ao buscar traduções: {e}")
            return []
    
    def get_translation_by_id(self, translation_id: int) -> Optional[Dict]:
        """
        Busca uma tradução pelo ID
        
        Args:
            translation_id: ID da tradução
            
        Returns:
            Dicionário com dados da tradução ou None
        """
        if not self.is_connected():
            return None
        
        try:
            self.cursor.execute('''
                SELECT id, original_text, translated_text, source_language, 
                       target_language, category, notes, created_at, 
                       updated_at, usage_count
                FROM translations 
                WHERE id = ?
            ''', (translation_id,))
            
            row = self.cursor.fetchone()
            
            if row:
                return {
                    'id': row[0],
                    'original_text': row[1],
                    'translated_text': row[2],
                    'source_language': row[3],
                    'target_language': row[4],
                    'category': row[5],
                    'notes': row[6],
                    'created_at': row[7],
                    'updated_at': row[8],
                    'usage_count': row[9]
                }
            
            return None
        except Exception as e:
            print(f"Erro ao buscar tradução por ID: {e}")
            return None
    
    def update_translation(self, translation_id: int, translated_text: str = None,
                          category: str = None, notes: str = None) -> bool:
        """
        Atualiza uma tradução existente
        
        Args:
            translation_id: ID da tradução
            translated_text: Novo texto traduzido
            category: Nova categoria
            notes: Novas notas
            
        Returns:
            True se atualizou com sucesso
        """
        if not self.is_connected():
            return False
        
        try:
            updates = []
            params = []
            
            if translated_text is not None:
                updates.append('translated_text = ?')
                params.append(translated_text)
            
            if category is not None:
                updates.append('category = ?')
                params.append(category)
            
            if notes is not None:
                updates.append('notes = ?')
                params.append(notes)
            
            if not updates:
                return False
            
            updates.append('updated_at = CURRENT_TIMESTAMP')
            params.append(translation_id)
            
            query = f'''
                UPDATE translations 
                SET {', '.join(updates)}
                WHERE id = ?
            '''
            
            self.cursor.execute(query, params)
            self.conn.commit()
            
            return self.cursor.rowcount > 0
        except Exception as e:
            print(f"Erro ao atualizar tradução: {e}")
            return False
    
    def delete_translation(self, translation_id: int) -> bool:
        """
        Deleta uma tradução
        
        Args:
            translation_id: ID da tradução
            
        Returns:
            True se deletou com sucesso
        """
        if not self.is_connected():
            return False
        
        try:
            self.cursor.execute('DELETE FROM translations WHERE id = ?', (translation_id,))
            self.conn.commit()
            return self.cursor.rowcount > 0
        except Exception as e:
            print(f"Erro ao deletar tradução: {e}")
            return False
    
    def delete_translations_by_ids(self, ids: List[int]) -> int:
        """
        Deleta múltiplas traduções com base em uma lista de IDs.
        
        Args:
            ids: Lista de IDs das traduções a serem deletadas.
            
        Returns:
            O número de linhas deletadas.
        """
        if not self.is_connected() or not ids:
            return 0
        
        try:
            # Cria uma string de placeholders (?, ?, ...) para a cláusula IN
            placeholders = ', '.join('?' for _ in ids)
            query = f'DELETE FROM translations WHERE id IN ({placeholders})'
            
            self.cursor.execute(query, ids)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as e:
            print(f"Erro ao deletar múltiplas traduções: {e}")
            return 0
    
    def get_categories(self, ) -> List[str]:       """
        Retorna lista de categorias únicas
        
        Returns:
            Lista de categorias
        """
        if not self.is_connected():
            return []
        
        try:
            self.cursor.execute('SELECT DISTINCT category FROM translations ORDER BY category')
            return [row[0] for row in self.cursor.fetchall()]
        except Exception as e:
            print(f"Erro ao buscar categorias: {e}")
            return []
    
    def export_to_file(self, filepath: str) -> bool:
        """
        Exporta a memória de tradução para um arquivo CSV
        
        Args:
            filepath: Caminho do arquivo de destino
            
        Returns:
            True se a exportação foi bem-sucedida
        """
        if not self.is_connected():
            return False
        
        try:
            import csv
            
            translations = self.get_all_translations()
            
            with open(filepath, 'w', encoding='utf-8', newline='') as f:
                writer = csv.writer(f)
                writer.writerow(['ID', 'Original', 'Tradução', 'Categoria', 'Notas', 'Usos'])
                
                for t in translations:
                    writer.writerow([
                        t['id'],
                        t['original_text'],
                        t['translated_text'],
                        t['category'],
                        t['notes'],
                        t['usage_count']
                    ])
            
            return True
        except Exception as e:
            print(f"Erro ao exportar memória: {e}")
            return False
    
    def import_from_file(self, filepath: str) -> Tuple[int, int]:
        """
        Importa traduções de um arquivo CSV
        
        Args:
            filepath: Caminho do arquivo de origem
            
        Returns:
            Tupla (importados, erros)
        """
        if not self.is_connected():
            return (0, 0)
        
        try:
            import csv
            
            imported = 0
            errors = 0
            
            with open(filepath, 'r', encoding='utf-8') as f:
                reader = csv.reader(f)
                header = next(reader)  # Pula cabeçalho
                
                for row in reader:
                    try:
                        if len(row) >= 2:
                            original = row[1] if len(row) > 1 else row[0]
                            translated = row[2] if len(row) > 2 else row[1]
                            category = row[3] if len(row) > 3 else 'imported'
                            notes = row[4] if len(row) > 4 else ''
                            
                            if self.add_translation(original, translated, 
                                                   category=category, notes=notes):
                                imported += 1
                            else:
                                errors += 1
                    except:
                        errors += 1
            
            return (imported, errors)
        except Exception as e:
            print(f"Erro ao importar memória: {e}")
            return (0, 0)
    
    def clear_all(self) -> bool:
        """
        Limpa toda a memória de tradução
        
        Returns:
            True se a operação foi bem-sucedida
        """
        if not self.is_connected():
            return False
        
        try:
            self.cursor.execute('DELETE FROM translations')
            self.conn.commit()
            return True
        except Exception as e:
            print(f"Erro ao limpar memória: {e}")
            return False
    
    def get_stats(self) -> dict:
        """
        Retorna estatísticas da memória de tradução
        
        Returns:
            Dicionário com estatísticas
        """
        if not self.is_connected():
            return {
                'total_translations': 0,
                'total_usage': 0,
                'categories': 0,
                'db_path': None
            }
        
        try:
            self.cursor.execute('SELECT COUNT(*) FROM translations')
            total = self.cursor.fetchone()[0]
            
            self.cursor.execute('SELECT SUM(usage_count) FROM translations')
            total_usage = self.cursor.fetchone()[0] or 0
            
            self.cursor.execute('SELECT COUNT(DISTINCT category) FROM translations')
            categories = self.cursor.fetchone()[0]
            
            return {
                'total_translations': total,
                'total_usage': total_usage,
                'categories': categories,
                'db_path': self.db_path
            }
        except Exception as e:
            print(f"Erro ao obter estatísticas: {e}")
            return {
                'total_translations': 0,
                'total_usage': 0,
                'categories': 0,
                'db_path': self.db_path
            }
    
    def search(self, term: str) -> List[Dict]:
        """
        Busca traduções por termo
        
        Args:
            term: Termo de busca
            
        Returns:
            Lista de traduções encontradas
        """
        return self.get_all_translations(search_term=term)
    
    def close(self):
        """Fecha a conexão com o banco de dados"""
        if self.conn:
            self.conn.close()
            self.conn = None
            self.cursor = None
    
    def __del__(self):
        """Destrutor - garante que a conexão seja fechada"""
        self.close()


def create_new_database(filepath: str) -> bool:
    """
    Cria um novo arquivo de banco de dados
    
    Args:
        filepath: Caminho para o novo arquivo .db
        
    Returns:
        True se criou com sucesso
    """
    try:
        # Garante que o diretório existe
        os.makedirs(os.path.dirname(filepath) if os.path.dirname(filepath) else '.', exist_ok=True)
        
        # Cria e inicializa o banco
        memory = TranslationMemory(filepath)
        memory.close()
        
        return True
    except Exception as e:
        print(f"Erro ao criar banco de dados: {e}")
        return False
