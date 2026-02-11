import psycopg2 
import psycopg2.extras



def connect():
  conn = psycopg2.connect(
    user = 'touhami.bentounsi',
    host = 'sqledu.univ-eiffel.fr',
    dbname = 'touhami.bentounsi_db',
    password = 'Alexzebi2004!',
    cursor_factory = psycopg2.extras.NamedTupleCursor 
  )
  conn.autocommit = True
  return conn