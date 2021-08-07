# frozen_string_literal: true

require 'pg'

conn = PG.connect(dbname: 'simple_memo_app_development')
sql  = <<~SQL
  DROP TABLE IF EXISTS memos;

  CREATE TABLE memos (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    content TEXT NOT NULL
  );

  INSERT INTO memos (title, content)
    VALUES (
        '1つ目のメモ',
        E'1つ目のメモの本文です。1つ目のメモの本文です。1つ目のメモの本文です。1つ目のメモの本文です。\n1つ目のメモの本文です。1つ目のメモの本文です。1つ目のメモの本文です。1つ目のメモの本文です。'
      ),
      (
        '2つ目のメモ',
        E'2つ目のメモの本文です。2つ目のメモの本文です。2つ目のメモの本文です。2つ目のメモの本文です。\n2つ目のメモの本文です。2つ目のメモの本文です。2つ目のメモの本文です。2つ目のメモの本文です。'
      ),
      (
        '3つ目のメモ',
        E'3つ目のメモの本文です。3つ目のメモの本文です。3つ目のメモの本文です。3つ目のメモの本文です。\n3つ目のメモの本文です。3つ目のメモの本文です。3つ目のメモの本文です。3つ目のメモの本文です。'
      );
SQL

conn.exec(sql)
