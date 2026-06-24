-- Catálogos base
-- Ejecutar después de 01_schema.sql

INSERT INTO bow_type (code, description) VALUES
    ('RECURVE',     'Arco recurvo olímpico / ILF'),
    ('BAREBOW',     'Arco desnudo (barebow)'),
    ('TRADITIONAL', 'Arco tradicional / longbow / self bow'),
    ('COMPOUND',    'Arco compuesto')
ON CONFLICT (code) DO NOTHING;

INSERT INTO shooting_style (code, description, bow_type_id) VALUES
    ('OLYMPIC_RECURVE',        'Recurvo olímpico (dedos)',           (SELECT id FROM bow_type WHERE code = 'RECURVE')),
    ('BAREBOW_STANDARD',       'Barebow estándar',                   (SELECT id FROM bow_type WHERE code = 'BAREBOW')),
    ('BAREBOW_STRINGWALKING',  'Barebow string walking',             (SELECT id FROM bow_type WHERE code = 'BAREBOW')),
    ('TRADITIONAL_FINGER',     'Tradicional con dedos',              (SELECT id FROM bow_type WHERE code = 'TRADITIONAL')),
    ('COMPOUND_RELEASE',       'Compuesto con release',              (SELECT id FROM bow_type WHERE code = 'COMPOUND')),
    ('COMPOUND_FINGERS',       'Compuesto con dedos',                (SELECT id FROM bow_type WHERE code = 'COMPOUND'))
ON CONFLICT (code) DO NOTHING;

INSERT INTO chart_purpose (code, description) VALUES
    ('TARGET',      'Tiro de precisión / indoor-outdoor'),
    ('HUNTING',     'Caza'),
    ('TRADITIONAL', 'Arco tradicional / madera'),
    ('3D',          'Tiro 3D / field')
ON CONFLICT (code) DO NOTHING;

INSERT INTO manufacturer (name, country, website) VALUES
    ('Easton',         'USA', 'https://eastonarchery.com'),
    ('Gold Tip',       'USA', 'https://goldtip.com'),
    ('Victory',        'USA', 'https://victoryarchery.com'),
    ('Carbon Express', 'USA', 'https://carbonexpressarrows.com'),
    ('Black Eagle',    'USA', 'https://blackeaglearrows.com'),
    ('Skylon',         'España', 'https://skylonarrows.com'),
    ('Avalon',         'Países Bajos', 'https://avalon-archery.com'),
    ('Pandarus',       NULL, NULL)
ON CONFLICT (name) DO NOTHING;

INSERT INTO point_weight (grains) VALUES
    (60),(70),(80),(85),(90),(100),(110),(120),(125),
    (130),(140),(145),(150),(160),(175),(190),(200)
ON CONFLICT (grains) DO NOTHING;
