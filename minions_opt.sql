DROP DATABASE IF EXISTS minions_opt;
CREATE DATABASE minions_opt
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE minions_opt;

-- =========================
-- Tabelas base
-- =========================

CREATE TABLE locais (
  id_local INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  tipo VARCHAR(50),
  coordenadas VARCHAR(50),
  acessibilidade VARCHAR(50),
  principal_atracao VARCHAR(100),
  seguranca VARCHAR(50),
  proprietario VARCHAR(100),
  imagem VARCHAR(255),
  UNIQUE KEY uk_locais_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE gadgets (
  id_gadget INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  tipo VARCHAR(50),
  nivel_requisitado INT,
  criador VARCHAR(100),
  ano_criacao YEAR,
  preco DECIMAL(10,2),
  disponibilidade BOOLEAN,
  imagem VARCHAR(255),
  UNIQUE KEY uk_gadgets_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE personagens (
  id_personagem INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  altura DECIMAL(5,2),
  peso DECIMAL(5,2),
  idade INT,
  cor_dos_olhos VARCHAR(50),
  habilidades TEXT,
  personalidade TEXT,
  id_gadget_favorito INT NULL,
  pontuacao INT,
  nivel INT,
  UNIQUE KEY uk_personagens_nome (nome),
  CONSTRAINT fk_personagens_gadget
    FOREIGN KEY (id_gadget_favorito) REFERENCES gadgets(id_gadget)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE missoes (
  id_missao INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  id_local INT NULL,
  dificuldade VARCHAR(50),
  recompensa VARCHAR(100),
  objetivo TEXT,
  data_inicio DATE,
  data_termino DATE,
  status VARCHAR(50),
  UNIQUE KEY uk_missoes_nome (nome),
  KEY idx_missoes_local (id_local),
  CONSTRAINT fk_missoes_local
    FOREIGN KEY (id_local) REFERENCES locais(id_local)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE inimigos (
  id_inimigo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  habilidades TEXT,
  fraquezas TEXT,
  objetivo TEXT,
  id_local_atual INT NULL,
  nivel_desafio VARCHAR(50),
  recompensa_por_vencelo VARCHAR(100),
  status VARCHAR(50),
  imagem VARCHAR(255),
  UNIQUE KEY uk_inimigos_nome (nome),
  KEY idx_inimigos_local (id_local_atual),
  CONSTRAINT fk_inimigos_local
    FOREIGN KEY (id_local_atual) REFERENCES locais(id_local)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- Relacionamentos N:N
-- =========================

CREATE TABLE personagens_missoes (
  id_personagem INT NOT NULL,
  id_missao INT NOT NULL,
  papel VARCHAR(50),
  PRIMARY KEY (id_personagem, id_missao),
  CONSTRAINT fk_pm_personagem
    FOREIGN KEY (id_personagem) REFERENCES personagens(id_personagem)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_pm_missao
    FOREIGN KEY (id_missao) REFERENCES missoes(id_missao)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE missoes_inimigos (
  id_missao INT NOT NULL,
  id_inimigo INT NOT NULL,
  papel VARCHAR(50) DEFAULT 'Inimigo',
  PRIMARY KEY (id_missao, id_inimigo),
  CONSTRAINT fk_mi_missao
    FOREIGN KEY (id_missao) REFERENCES missoes(id_missao)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_mi_inimigo
    FOREIGN KEY (id_inimigo) REFERENCES inimigos(id_inimigo)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

USE minions_opt;

-- =========================================================
-- 0) (OPCIONAL) Limpeza para rodar do zero (se precisar)
--    Descomente se quiser resetar as tabelas
-- =========================================================
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE missoes_inimigos;
-- TRUNCATE TABLE personagens_missoes;
-- TRUNCATE TABLE inimigos;
-- TRUNCATE TABLE missoes;
-- TRUNCATE TABLE personagens;
-- TRUNCATE TABLE gadgets;
-- TRUNCATE TABLE locais;
-- SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- 1) LOCAIS
-- =========================================================
INSERT INTO locais (nome, descricao, tipo, coordenadas, acessibilidade, principal_atracao, seguranca, proprietario, imagem) VALUES
('Base secreta do Balthazar', 'Base secreta subterrânea, protegida por armadilhas e segurança reforçada', 'Base Secreto', '40.7128° N, 74.0060° W', 'Restrito', 'Laboratório de Invenções', 'Alta', 'Balthazar Bratt', 'base_balthazar.jpg'),
('Liga Anti-Vilões HQ', 'Sede da Liga Anti-Vilões, altamente protegida e equipada com tecnologia avançada', 'Sede da Organização', '34.0522° N, 118.2437° W', 'Restrito', 'Sala de Inteligência', 'Muito Alta', 'Liga Anti-Vilões', 'hq_liga_antiviloes.jpg'),
('Fábrica de Gelatina', 'Grande fábrica de gelatina, com linhas de produção automatizadas e segurança industrial', 'Indústria', '34.0522° N, 118.2437° W', 'Público', 'Grande Tanque de Gelatina', 'Média', 'Dr. Nefário', 'fabrica_gelatina.jpg'),
('Ilha dos Vilões', 'Ilha remota e fortificada, esconderijo de vários vilões, com sistemas de defesa avançados', 'Ilha', '21.4512° S, 48.0039° W', 'Restrito', 'Fortaleza Central', 'Alta', 'Vários Vilões', 'ilha_viloes.jpg'),
('Museu de Arte', 'Museu de arte com valiosas obras de arte, protegido por sistemas de segurança e guardas', 'Museu', '51.5074° N, 0.1278° W', 'Público', 'Mona Lisa', 'Média', 'Cidade', 'museu_arte.jpg'),
('Local desconhecido', 'Localização desconhecida, possivelmente um esconderijo secreto ou base clandestina', 'Desconhecido', 'Desconhecido', 'Desconhecido', 'Desconhecido', 'Desconhecido', 'Desconhecido', 'local_desconhecido.jpg'),
('Base secreta do Vector', 'Base secreta do vilão Vector, cheia de armadilhas e dispositivos de segurança', 'Base Secreto', '51.5074° N, 0.1278° W', 'Restrito', 'Sala de Controle', 'Alta', 'Vector', 'base_vector.jpg'),
('Museu de História Natural', 'Museu com exposições de história natural e arqueologia, com segurança reforçada', 'Museu', '40.7812° N, 73.9665° W', 'Público', 'Esqueleto de Dinossauro', 'Média', 'Cidade', 'museu_hist_natural.jpg'),
('Fortaleza dos Minions', 'Fortaleza protegida dos Minions, com armadilhas e sistemas de defesa automatizados', 'Fortaleza', '48.8566° N, 2.3522° E', 'Restrito', 'Grande Portão de Entrada', 'Média', 'Minions', 'fortaleza_minions.jpg')
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- =========================================================
-- 2) GADGETS
-- =========================================================
INSERT INTO gadgets (nome, descricao, tipo, nivel_requisitado, criador, ano_criacao, preco, disponibilidade, imagem) VALUES
('Raio Congelante', 'Dispositivo que emite um raio congelante capaz de congelar objetos e inimigos', 'Arma', 8, 'Dr. Nefário', 2010, 5000.00, 1, 'raio_congelante.jpg'),
('Urso de Pelúcia Transformável', 'Urso de pelúcia que se transforma em uma arma de alta potência', 'Dispositivo de transformação', 6, 'Gru', 2015, 3000.00, 1, 'urso_pelucia.jpg'),
('Guitarra Elétrica com Raios', 'Guitarra elétrica equipada com raios de alta voltagem', 'Arma', 7, 'Stuart', 2018, 4000.00, 1, 'guitarra_raios.jpg'),
('Foguete Jet-Pack', 'Dispositivo que permite voar com jatos de propulsão', 'Equipamento de voo', 8, 'Gru', 2013, 6000.00, 1, 'foguete_jetpack.jpg'),
('Martelo de Brinquedo Gigante', 'Martelo inflável gigante utilizado para combate corpo a corpo', 'Arma', 6, 'Jerry', 2016, 2500.00, 1, 'martelo_gigante.jpg'),
('Canhão de Água', 'Canhão portátil que dispara jatos de água de alta pressão', 'Arma', 7, 'Tim', 2014, 3500.00, 1, 'canhao_agua.jpg'),
('Banana Explosiva', 'Banana com carga explosiva que pode ser detonada remotamente', 'Arma', 5, 'Gru', 2012, 2000.00, 1, 'banana_explosiva.jpg'),
('Disfarce de Balão', 'Disfarce em forma de balão que permite camuflagem e disfarce', 'Equipamento de Disfarce', 7, 'Carl', 2017, 3800.00, 1, 'disfarce_balao.jpg'),
('Armadura Anti-Balas', 'Armadura resistente a balas e ataques físicos', 'Equipamento de Proteção', 9, 'Mark', 2019, 8000.00, 1, 'armadura_antibalas.jpg'),
('Lança-Mísseis', 'Lança-mísseis portátil com capacidade de disparar mísseis guiados', 'Arma', 8, 'Tom', 2020, 7000.00, 1, 'lanca_misseis.jpg')
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- =========================================================
-- 3) PERSONAGENS
-- =========================================================
INSERT INTO personagens
(nome, altura, peso, idade, cor_dos_olhos, habilidades, personalidade, id_gadget_favorito, pontuacao, nivel)
VALUES
('Kevin', 105.5, 65.2, 30, 'Castanho', 'Liderança, Habilidade em planejamento', 'Inteligente e determinado',
 (SELECT id_gadget FROM gadgets WHERE nome='Raio Congelante'), 200, 10),
('Bob', 95.0, 55.0, 25, 'Azul', 'Resistência, Força', 'Inocente e brincalhão',
 (SELECT id_gadget FROM gadgets WHERE nome='Urso de Pelúcia Transformável'), 180, 8),
('Stuart', 100.0, 60.0, 27, 'Marrom', 'Agilidade, Engenhosidade', 'Curioso e entusiasmado',
 (SELECT id_gadget FROM gadgets WHERE nome='Guitarra Elétrica com Raios'), 190, 9),
('Dave', 98.0, 58.0, 28, 'Verde', 'Invisibilidade, Comunicação com animais', 'Leal e engraçado',
 (SELECT id_gadget FROM gadgets WHERE nome='Foguete Jet-Pack'), 210, 11),
('Jerry', 102.0, 63.0, 29, 'Amarelo', 'Elasticidade, Super-salto', 'Alegre e otimista',
 (SELECT id_gadget FROM gadgets WHERE nome='Martelo de Brinquedo Gigante'), 195, 9),
('Tim', 110.0, 70.0, 32, 'Vermelho', 'Resistência ao calor, Resistência ao frio', 'Determinado e corajoso',
 (SELECT id_gadget FROM gadgets WHERE nome='Canhão de Água'), 220, 12),
('Phil', 97.0, 57.0, 26, 'Roxo', 'Multiplicação, Resistência à eletricidade', 'Descontraído e preguiçoso',
 (SELECT id_gadget FROM gadgets WHERE nome='Banana Explosiva'), 185, 8),
('Carl', 99.0, 59.0, 27, 'Laranja', 'Conhecimento em tecnologia, Inteligência', 'Tímido e inteligente',
 (SELECT id_gadget FROM gadgets WHERE nome='Disfarce de Balão'), 200, 10),
('Mark', 101.0, 61.0, 28, 'Verde', 'Invisibilidade, Super-força', 'Determinado e corajoso',
 (SELECT id_gadget FROM gadgets WHERE nome='Armadura Anti-Balas'), 205, 11),
('Tom', 103.0, 62.0, 30, 'Amarelo', 'Invisibilidade, Agilidade', 'Brincalhão e astuto',
 (SELECT id_gadget FROM gadgets WHERE nome='Lança-Mísseis'), 210, 12)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- =========================================================
-- 4) MISSOES
-- =========================================================
INSERT INTO missoes
(nome, descricao, id_local, dificuldade, recompensa, objetivo, data_inicio, data_termino, status)
VALUES
('Operação Resgate de Gru', 'Resgatar Gru do vilão Balthazar Bratt',
 (SELECT id_local FROM locais WHERE nome='Base secreta do Balthazar'),
 'Alta', '10.000 bananas', 'Resgatar Gru são e salvo', '2024-04-15', '2024-04-20', 'Concluída'),
('Missão Infiltrar na Liga Anti-Vilões', 'Infiltrar na sede da Liga Anti-Vilões e roubar a arma de congelamento',
 (SELECT id_local FROM locais WHERE nome='Liga Anti-Vilões HQ'),
 'Média', '5.000 bananas', 'Roubar arma de congelamento', '2024-04-18', '2024-04-22', 'Andamento'),
('Operação Salvar a Grande Fábrica de Gelatina', 'Evitar que a fábrica de gelatina seja destruída pelo Dr. Nefário',
 (SELECT id_local FROM locais WHERE nome='Fábrica de Gelatina'),
 'Alta', '15.000 bananas', 'Salvar a fábrica de gelatina', '2024-04-20', '2024-04-25', 'Planejada'),
('Missão Explorar a Ilha dos Vilões', 'Explorar a ilha onde os vilões se escondem e descobrir seus planos',
 (SELECT id_local FROM locais WHERE nome='Ilha dos Vilões'),
 'Baixa', '3.000 bananas', 'Explorar a ilha e reunir informações', '2024-04-22', '2024-04-27', 'Andamento'),
('Operação Recuperar o Raio Congelante', 'Recuperar o Raio Congelante roubado por um vilão desconhecido',
 (SELECT id_local FROM locais WHERE nome='Local desconhecido'),
 'Média', '8.000 bananas', 'Recuperar o Raio Congelante', '2024-04-25', '2024-04-30', 'Planejada'),
('Missão Proteger o Museu de Arte', 'Proteger o Museu de Arte dos possíveis roubos planejados por um vilão',
 (SELECT id_local FROM locais WHERE nome='Museu de Arte'),
 'Baixa', '4.000 bananas', 'Proteger o Museu de Arte', '2024-04-28', '2024-05-02', 'Planejada'),
('Operação Resgatar Agnes', 'Resgatar Agnes, a irmã mais nova de Gru, que foi sequestrada por um vilão',
 (SELECT id_local FROM locais WHERE nome='Local desconhecido'),
 'Alta', '12.000 bananas', 'Resgatar Agnes são e salva', '2024-05-01', '2024-05-06', 'Planejada'),
('Missão Desvendar os Planos de Vector', 'Infiltrar na base de Vector e descobrir seus planos maléficos',
 (SELECT id_local FROM locais WHERE nome='Base secreta do Vector'),
 'Média', '6.000 bananas', 'Descobrir os planos de Vector', '2024-05-04', '2024-05-09', 'Planejada'),
('Operação Impedir o Furto do Grande Diamante', 'Impedir o furto do grande diamante pelo grupo de vilões',
 (SELECT id_local FROM locais WHERE nome='Museu de História Natural'),
 'Alta', '20.000 bananas', 'Impedir o furto do diamante', '2024-05-07', '2024-05-12', 'Planejada'),
('Missão Defesa da Fortaleza dos Minions', 'Defender a fortaleza dos Minions contra um ataque iminente de inimigos',
 (SELECT id_local FROM locais WHERE nome='Fortaleza dos Minions'),
 'Alta', '10.000 bananas', 'Defender a fortaleza dos Minions', '2024-05-10', '2024-05-15', 'Planejada')
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- =========================================================
-- 5) PERSONAGENS_MISSOES
-- =========================================================
INSERT INTO personagens_missoes (id_personagem, id_missao, papel) VALUES
(1, 1, 'Líder'),
(2, 1, 'Suporte'),
(3, 1, 'Infiltrador'),
(4, 2, 'Infiltrador'),
(5, 2, 'Suporte'),
(6, 2, 'Líder'),
(7, 3, 'Líder'),
(8, 3, 'Infiltrador'),
(9, 3, 'Suporte'),
(10, 4, 'Líder')
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- =========================================================
-- 6) INIMIGOS (originais + faltantes)
-- =========================================================
INSERT INTO inimigos
(nome, descricao, habilidades, fraquezas, objetivo, id_local_atual, nivel_desafio, recompensa_por_vencelo, status, imagem)
VALUES
('Balthazar Bratt', 'Ex-astro de TV infantil, agora um vilão obcecado pela década de 1980',
 'Habilidade em artes marciais, Conhecimento em tecnologia', 'Vaidade, Arrogância',
 'Dominar o mundo usando seus dispositivos retro',
 (SELECT id_local FROM locais WHERE nome='Base secreta do Balthazar'),
 'Alto', '10.000 bananas', 'Ativo', 'balthazar_bratt.jpg'),

('Dr. Nefário', 'Cientista malvado e ex-assistente de Gru, especialista em invenções diabólicas',
 'Genialidade, Engenharia', 'Falta de confiança, Lealdade a Gru',
 'Derrotar Gru e provar sua superioridade',
 (SELECT id_local FROM locais WHERE nome='Fábrica de Gelatina'),
 'Muito Alto', '15.000 bananas', 'Ativo', 'dr_nefario.jpg'),

('Vector', 'Jovem e arrogante vilão, obcecado por ser o maior inimigo de Gru',
 'Engenharia, Robótica', 'Arrogância, Falta de maturidade',
 'Provar que é melhor que Gru e se tornar o maior vilão',
 (SELECT id_local FROM locais WHERE nome='Base secreta do Vector'),
 'Médio', '8.000 bananas', 'Ativo', 'vector.jpg'),

('Grupo de Vilões', 'Coletivo de vilões menores que se uniram para realizar roubos e planos malignos',
 'Varia conforme o membro', 'Varia conforme o membro',
 'Enriquecer e causar caos na sociedade',
 (SELECT id_local FROM locais WHERE nome='Local desconhecido'),
 'Médio', '5.000 bananas', 'Ativo', 'grupo_viloes.jpg'),

('Guardas da Ilha', 'Guardas contratados para proteger a Ilha dos Vilões de invasores e intrusos',
 'Habilidades de combate, Patrulha', 'Inferioridade numérica, Desconhecimento do ambiente',
 'Proteger a Ilha dos Vilões e seus segredos',
 (SELECT id_local FROM locais WHERE nome='Ilha dos Vilões'),
 'Médio', '4.000 bananas', 'Ativo', 'guardas_ilha.jpg'),

('Guardas do Museu', 'Guardas de segurança contratados para proteger as valiosas obras do Museu de Arte',
 'Vigilância, Patrulha', 'Inferioridade numérica, Falhas nos sistemas de segurança',
 'Proteger as obras de arte e o patrimônio cultural',
 (SELECT id_local FROM locais WHERE nome='Museu de Arte'),
 'Baixo', '3.000 bananas', 'Ativo', 'guardas_museu.jpg'),

('Minions do Balthazar', 'Minions que traíram Gru para servir ao vilão Balthazar Bratt',
 'Lealdade, Engenhosidade', 'Falta de liderança, Fraqueza física',
 'Ajudar Balthazar Bratt a realizar seus planos malignos',
 (SELECT id_local FROM locais WHERE nome='Base secreta do Balthazar'),
 'Baixo', '2.000 bananas', 'Ativo', 'minions_balthazar.jpg'),

('Minions do Dr. Nefário', 'Minions que seguem as ordens do cientista malvado Dr. Nefário',
 'Lealdade, Engenhosidade', 'Falta de liderança, Fraqueza física',
 'Ajudar Dr. Nefário em seus planos de vingança contra Gru',
 (SELECT id_local FROM locais WHERE nome='Fábrica de Gelatina'),
 'Baixo', '2.000 bananas', 'Ativo', 'minions_nefario.jpg'),

('Minions de Vector', 'Minions recrutados por Vector para ajudar em seus planos maléficos',
 'Lealdade, Engenhosidade', 'Falta de liderança, Fraqueza física',
 'Ajudar Vector em seus planos para derrotar Gru',
 (SELECT id_local FROM locais WHERE nome='Base secreta do Vector'),
 'Baixo', '2.000 bananas', 'Ativo', 'minions_vector.jpg'),

('Possíveis Ladrões', 'Suspeitos de praticar furtos no Museu de Arte, mas suas identidades são desconhecidas',
 'Varia conforme o membro', 'Varia conforme o membro',
 'Roubar valiosas obras de arte',
 (SELECT id_local FROM locais WHERE nome='Museu de Arte'),
 'Baixo', '2.000 bananas', 'Ativo', 'ladroes_museu.jpg'),

-- ------- faltantes -------
('Agentes da Liga Anti-Vilões',
 'Equipe de agentes treinados e equipados com tecnologia avançada para impedir ações criminosas.',
 'Táticas de combate, vigilância, uso de gadgets de contenção',
 'Excesso de confiança, dependência de comunicação central',
 'Proteger a sede e impedir infiltrações',
 (SELECT id_local FROM locais WHERE nome='Liga Anti-Vilões HQ'),
 'Médio', '4.500 bananas', 'Ativo', 'agentes_liga.jpg'),

('Capangas',
 'Grupo de ajudantes contratados por vilões para executar tarefas e proteger áreas.',
 'Combate em grupo, intimidação, patrulha',
 'Pouco treinamento individual, medo de líderes mais fortes',
 'Ajudar vilões em missões e proteger recursos',
 (SELECT id_local FROM locais WHERE nome='Local desconhecido'),
 'Baixo', '2.500 bananas', 'Ativo', 'capangas.jpg'),

('Armadilhas',
 'Conjunto de armadilhas mecânicas e eletrônicas espalhadas para impedir invasores.',
 'Detecção de movimento, bloqueios automáticos, redes, dardos e alarmes',
 'Pode ser desativada com engenharia/hack; falhas de manutenção',
 'Impedir acesso a áreas críticas',
 (SELECT id_local FROM locais WHERE nome='Ilha dos Vilões'),
 'Médio', '3.000 bananas', 'Ativo', 'armadilhas.jpg'),

('Equipamentos de cerco',
 'Dispositivos pesados usados para invadir e dominar áreas fortificadas.',
 'Força bruta, destruição controlada, bloqueio de rotas',
 'Lento, precisa de logística; vulnerável a sabotagem',
 'Tomar posições estratégicas e abrir caminho para invasão',
 (SELECT id_local FROM locais WHERE nome='Fortaleza dos Minions'),
 'Alto', '6.000 bananas', 'Ativo', 'equipamentos_cerco.jpg')

ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- =========================================================
-- 7) MISSOES_INIMIGOS (completo e coerente)
-- =========================================================

-- Missão 1: Balthazar Bratt, Minions do Balthazar
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Balthazar Bratt', 'Minions do Balthazar')
WHERE m.nome = 'Operação Resgate de Gru'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 2: Agentes da Liga Anti-Vilões
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Agentes da Liga Anti-Vilões')
WHERE m.nome = 'Missão Infiltrar na Liga Anti-Vilões'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 3: Dr. Nefário, Minions do Dr. Nefário
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Dr. Nefário', 'Minions do Dr. Nefário')
WHERE m.nome = 'Operação Salvar a Grande Fábrica de Gelatina'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 4: Guardas da Ilha + Armadilhas (ameaça)
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo,
       CASE WHEN i.nome = 'Armadilhas' THEN 'Perigo/Ameaça' ELSE 'Inimigo' END
FROM missoes m
JOIN inimigos i ON i.nome IN ('Guardas da Ilha', 'Armadilhas')
WHERE m.nome = 'Missão Explorar a Ilha dos Vilões'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 5: Capangas (vilão desconhecido não cadastrado)
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Capangas')
WHERE m.nome = 'Operação Recuperar o Raio Congelante'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 6: Possíveis Ladrões, Guardas do Museu
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Possíveis Ladrões', 'Guardas do Museu')
WHERE m.nome = 'Missão Proteger o Museu de Arte'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 7: Capangas (vilão desconhecido não cadastrado)
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Capangas')
WHERE m.nome = 'Operação Resgatar Agnes'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 8: Vector, Minions de Vector + Armadilhas (na base do Vector)
UPDATE inimigos
SET id_local_atual = (SELECT id_local FROM locais WHERE nome='Base secreta do Vector')
WHERE nome = 'Armadilhas';

INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo,
       CASE WHEN i.nome = 'Armadilhas' THEN 'Perigo/Ameaça' ELSE 'Inimigo' END
FROM missoes m
JOIN inimigos i ON i.nome IN ('Vector', 'Minions de Vector', 'Armadilhas')
WHERE m.nome = 'Missão Desvendar os Planos de Vector'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 9: Grupo de Vilões (e você pode criar inimigos do museu depois se quiser)
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Inimigo'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Grupo de Vilões')
WHERE m.nome = 'Operação Impedir o Furto do Grande Diamante'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- Missão 10: Equipamentos de cerco (ameaça principal)
INSERT INTO missoes_inimigos (id_missao, id_inimigo, papel)
SELECT m.id_missao, i.id_inimigo, 'Ameaça Principal'
FROM missoes m
JOIN inimigos i ON i.nome IN ('Equipamentos de cerco')
WHERE m.nome = 'Missão Defesa da Fortaleza dos Minions'
ON DUPLICATE KEY UPDATE papel = VALUES(papel);

-- ---------------------------------------------------------
-- atividades 👇
-- ---------------------------------------------------------

-- 1
SELECT p.nome FROM personagens p 
JOIN personagens_missoes pm ON p.id_personagem = pm.id_personagem 
JOIN missoes m ON pm.id_missao = m.id_missao WHERE m.nome = 'Operação Resgate de Gru';

-- 2
SELECT i.nome FROM inimigos i 
JOIN missoes_inimigos mi ON i.id_inimigo = mi.id_inimigo 
JOIN missoes m ON mi.id_missao = m.id_missao WHERE m.nome = 'Missão Infiltrar na Liga Anti-Vilões';

-- 3
SELECT p.nome FROM personagens p 
JOIN gadgets g ON p.id_gadget_favorito = g.id_gadget WHERE g.nome = 'Raio Congelante';

-- 4
SELECT p.nome, g.nome AS gadget FROM personagens p 
LEFT JOIN gadgets g ON p.id_gadget_favorito = g.id_gadget;

-- 5
select nome, pontuacao,
if (pontuacao >= 200, 'forte',
if (pontuacao >= 100, 'fraco', 'medio')
) as classificacao
from personagens
order by pontuacao desc;

-- 6
SELECT * FROM gadgets ORDER BY nome ASC;

-- 7
SELECT l.nome, COUNT(i.id_inimigo) FROM locais l 
LEFT JOIN inimigos i ON l.id_local = i.id_local_atual GROUP BY l.nome;

-- 8
SELECT status, COUNT(*) FROM missoes GROUP BY status;

-- 9
SELECT m.nome, AVG(p.nivel) FROM missoes m 
JOIN personagens_missoes pm ON m.id_missao = pm.id_missao 
JOIN personagens p ON pm.id_personagem = p.id_personagem GROUP BY m.nome;

-- 10
SELECT tipo, COUNT(*) FROM gadgets GROUP BY tipo;

-- 11
SELECT m.dificuldade,
AVG(p.nivel) AS media_nivel
FROM personagens p
JOIN personagens_missoes pm ON p.id_personagem = pm.id_personagem
JOIN missoes m ON pm.id_missao = m.id_missao
GROUP BY m.dificuldade;

-- 12
SELECT nome, objetivo
FROM missoes;

-- 13
SELECT m.nome, COUNT(pm.id_personagem) AS total_personagens
FROM missoes m
LEFT JOIN personagens_missoes pm ON m.id_missao = pm.id_missao
GROUP BY m.nome;

-- 14
SELECT nome_missao, nome_personagem, nivel
FROM (
    SELECT m.nome AS nome_missao,
           p.nome AS nome_personagem,
           p.nivel,
           RANK() OVER (PARTITION BY m.id_missao ORDER BY p.nivel DESC) r
    FROM personagens p
    JOIN personagens_missoes pm ON p.id_personagem = pm.id_personagem
    JOIN missoes m ON pm.id_missao = m.id_missao
) t
WHERE r = 1;

-- 15
SELECT m.status,
AVG(p.nivel) AS media_nivel
FROM personagens p
JOIN personagens_missoes pm ON p.id_personagem = pm.id_personagem
JOIN missoes m ON pm.id_missao = m.id_missao
GROUP BY m.status;

-- 16
SELECT l.nome AS local,
AVG(p.nivel) AS media_nivel
FROM personagens p
JOIN personagens_missoes pm ON p.id_personagem = pm.id_personagem
JOIN missoes m ON pm.id_missao = m.id_missao
JOIN locais l ON m.id_local = l.id_local
GROUP BY l.nome;

-- 17
SELECT p.nome, COUNT(pm.id_missao) AS total_missoes
FROM personagens p
LEFT JOIN personagens_missoes pm ON p.id_personagem = pm.id_personagem
GROUP BY p.nome;

-- 18
SELECT g.nome,
COUNT(*) AS total_personagens
FROM personagens p
INNER JOIN gadgets g
ON p.id_gadget_favorito = g.id_gadget
GROUP BY g.nome
ORDER BY total_personagens DESC
LIMIT 1;

-- 19
SELECT m.status,
AVG(p.nivel) AS media_nivel
FROM missoes m
INNER JOIN personagens_missoes pm
ON m.id_missao = pm.id_missao
INNER JOIN personagens p
ON pm.id_personagem = p.id_personagem
WHERE m.status IN ('Concluída', 'Andamento')
GROUP BY m.status;

-- 20
SELECT m.nome AS missao,
p.habilidades,
COUNT(*) AS total
FROM missoes m
INNER JOIN personagens_missoes pm
ON m.id_missao = pm.id_missao
INNER JOIN personagens p
ON pm.id_personagem = p.id_personagem
GROUP BY m.nome, p.habilidades;

-- 21
CREATE OR REPLACE VIEW personagens_gadgets AS
SELECT p.nome AS personagem,
g.nome AS gadget_favorito
FROM personagens p
LEFT JOIN gadgets g
ON p.id_gadget_favorito = g.id_gadget;
SELECT * FROM  personagens_gadgets;

-- 22
CREATE OR REPLACE VIEW vw_missoes_status AS
SELECT status,
COUNT(*) AS total_missoes
FROM missoes
WHERE status IN ('Concluída', 'Andamento')
GROUP BY status;

-- 23
CREATE OR REPLACE VIEW vw_inimigos_missoes AS
SELECT i.nome AS inimigo,
m.nome AS missao,
mi.papel
FROM inimigos i
INNER JOIN missoes_inimigos mi
ON i.id_inimigo = mi.id_inimigo
INNER JOIN missoes m
ON mi.id_missao = m.id_missao;

-- 24
CREATE OR REPLACE VIEW vw_media_nivel_por_missao AS
SELECT m.nome AS missao,
AVG(p.nivel) AS media_nivel
FROM missoes m
INNER JOIN personagens_missoes pm
ON m.id_missao = pm.id_missao
INNER JOIN personagens p
ON pm.id_personagem = p.id_personagem
GROUP BY m.nome;

-- 25
CREATE OR REPLACE VIEW vw_missoes_por_local AS
SELECT l.nome AS local,
COUNT(m.id_missao) AS total_missoes
FROM locais l
LEFT JOIN missoes m
ON l.id_local = m.id_local
GROUP BY l.nome;




