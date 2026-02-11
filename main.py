import db
from psycopg2.extras import RealDictCursor
from flask import Flask, render_template, request, redirect, url_for, session, flash


app = Flask(__name__)
app.secret_key = '3958df516946488646a0cc2aaa54d3fa71c773f211166bc6e27f80057163f24f' 



@app.route("/accueil", methods=['GET', 'POST'])
def accueil():
    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    if request.method == 'GET':
        action = request.args.get('action')
        if action == 'search_vip':
            recherche = request.args.get('recherche')
            cursor.execute("SELECT * FROM vip WHERE nom ILIKE  %s  OR prenom ILIKE %s ", ( '%' + recherche +'%', '%'+ recherche +'%',))
            vip = cursor.fetchall()
            cursor.execute("SELECT * FROM album WHERE titre ILIKE %s or nommaisondisque ILIKE %s ", ('%' + recherche + '%', '%' + recherche + '%',))
            album = cursor.fetchall()
            return render_template('accueil.html', vips=vip, album = album)
    return render_template('accueil.html')


@app.route("/admin")
def admin():
    return render_template("admin.html")

@app.route("/defile")
def defile():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT d.id_defile , CONCAT(v.prenom, ' ', v.nom) AS createur, d.lieu , d.date , d.id_vip FROM defile d JOIN vip v ON d.id_vip = v.id_vip;")
            lst_defile=cur.fetchall()
    conn.close()
    return render_template("defile.html", lst_defile=lst_defile)

@app.route("/album")
def album():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT a.id_album , CONCAT(v.prenom, ' ', v.nom) AS artiste, a.titre , a.id_vip FROM album a JOIN vip v ON a.id_vip = v.id_vip;")
            lst_album=cur.fetchall()
    conn.close()
    return render_template("album.html", lst_album=lst_album)

@app.route("/film")
def film():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT f.visa , CONCAT(v.prenom, ' ', v.nom) AS realisateur, f.titre , f.date_real , f.id_vip FROM film f JOIN vip v ON f.id_vip = v.id_vip;")
            lst_film=cur.fetchall()
    conn.close()
    return render_template("film.html", lst_film=lst_film)

@app.route("/revue")
def revue():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT numero_revue , date_parution FROM revue;")
            lst_revue=cur.fetchall()
    conn.close()
    return render_template("revue.html", lst_revue=lst_revue)

@app.route("/photo")
def photo():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_photo , date_photo FROM photo;")
            lst_photo=cur.fetchall()
    conn.close()
    return render_template("photo.html", lst_photo=lst_photo)

@app.route("/celebrites")
def celenbrites():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM vip;")
            lst_vip=cur.fetchall()
    conn.close()
    return render_template("celebrites.html", lst_vip=lst_vip)

@app.route("/revue/<int:numero_revue>")
def detailsrevue(numero_revue):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT a.*, r.date_parution FROM article a JOIN revue r ON a.numero_revue = r.numero_revue WHERE a.numero_revue = %s;",
                (numero_revue,)
            )
            lst_articles = cur.fetchall()
    conn.close()
    return render_template("detailsrevue.html", lst_articles=lst_articles, revue=numero_revue)


@app.route("/revue/<int:numero_revue>/<int:id_article>")
def detailsarticle(numero_revue, id_article):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT a.* ,r.date_parution FROM article a JOIN revue r ON a.numero_revue = r.numero_revue WHERE a.numero_revue = %s AND a.id_article = %s;",
                (numero_revue, id_article),
            )
            result = cur.fetchone()

    conn.close()

    if result:
        article = result[:5] 
        revue = result[5]
    else:
        article = None
        revue = None

    return render_template("detailsarticle.html", revue=revue, article=article)

@app.route("/album/<int:id_album>")
def detailsalbum(id_album):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT al.id_album, al.titre, al.date_rea, al.nommaisondisque, CONCAT(v.prenom, ' ', v.nom) FROM album al JOIN artiste a ON al.id_vip = a.id_vip JOIN musique m ON al.id_album = m.id_album JOIN vip v ON a.id_vip = v.id_vip WHERE al.id_album = %s;", (id_album,))
            album = cur.fetchone()
            print(album)
    conn.close()
    return render_template("detailsalbum.html", album=album, )


@app.route("/defile/<int:id_defile>")
def detailsdefile(id_defile):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""SELECT d.*, CONCAT(c.prenom, ' ', c.nom) AS createur, CONCAT(m.prenom, ' ', m.nom) as mannequin FROM defile d
                            JOIN mannequinat man ON man.id_defile = d.id_defile
                            JOIN mannequin ma ON ma.id_mannequin = man.id_mannequin
                            JOIN vip m ON m.id_vip = ma.id_vip
                            JOIN vip c ON c.id_vip = d.id_vip 
	                        WHERE d.id_defile = %s;""", (id_defile,))   
            defile = cur.fetchone()
            print(defile)
    conn.close()
    return render_template("detailsdefile.html", defile=defile)




@app.route("/film/<int:visa>")
def detailsfilm(visa):
    with db.connect() as conn:
        with conn.cursor() as cur:
            #cur.execute("SELECT * FROM film WHERE visa = %s;", (visa,))
            cur.execute("""SELECT f.*,CONCAT(a.prenom, ' ', a.nom) AS acteur, CONCAT(r.prenom,' ', r.nom) as real FROM film f
                            JOIN acting ac ON f.visa = ac.visa
                            JOIN acteur act ON ac.id_acteur = act.id_acteur
                            JOIN vip a ON a.id_vip = act.id_vip  
                            JOIN vip r ON r.id_vip = f.id_vip 
                            WHERE f.visa = %s ;""", (visa,))   
            film = cur.fetchall()
            print(film)
    conn.close()
    return render_template("detailsfilm.html", film=film)



@app.route("/celebrites/<int:id_vip>")
def detailsvip(id_vip):
    try:
        with db.connect() as conn:
            with conn.cursor() as cur:
                # Récupérer les détails du VIP
                cur.execute("""
                    SELECT nom, prenom, sexe, nationalite, date_naissance, date_deces
                    FROM vip
                    WHERE id_vip = %s;
                """, (id_vip,))
                vip_details = cur.fetchone()

                # Vérifier si le VIP existe
                if not vip_details:
                    return "VIP non trouvé", 404

                # Récupérer les autres données liées, comme les albums
                cur.execute("""
                    SELECT titre, date_rea, nommaisondisque
                    FROM album
                    WHERE id_vip = %s;
                """, (id_vip,))
                albums = cur.fetchall()

                # Récupérer les photos
                cur.execute("""
                    SELECT id_photo
                    FROM present_photo
                    WHERE id_vip = %s;
                """, (id_vip,))
                photos = cur.fetchall()

                cur.execute("""
                    SELECT titre,date_real
                    FROM film
                    WHERE id_vip = %s;
                """, (id_vip,))
                films = cur.fetchall()

                cur.execute("""
                    SELECT lieu,date
                    FROM defile
                    WHERE id_vip = %s;
                """, (id_vip,))
                defiles = cur.fetchall()

                cur.execute("""
                    SELECT 
                        d.date_mariage, 
                        d.lieu_mariage, 
                        CASE 
                            WHEN d.id_vip_1 = %s THEN CONCAT(v2.prenom, ' ', v2.nom)
                            WHEN d.id_vip_2 = %s THEN CONCAT(v1.prenom, ' ', v1.nom)
                        END AS conjoint,
                        CASE 
                            WHEN d.id_vip_1 = %s AND d.date_separation IS NOT NULL THEN ' (divorcé)'
                            WHEN d.id_vip_2 = %s AND d.date_separation IS NOT NULL THEN ' (divorcé)'
                            ELSE ''
                        END AS divorce_info
                    FROM detail_mariage d 
                    LEFT JOIN vip v1 ON d.id_vip_1 = v1.id_vip
                    LEFT JOIN vip v2 ON d.id_vip_2 = v2.id_vip
                    WHERE d.id_vip_1 = %s OR d.id_vip_2 = %s;
                """, (id_vip, id_vip, id_vip, id_vip, id_vip, id_vip))
                mariages = cur.fetchall()

                cur.execute("""
                    SELECT 
                        l.date_annonce, 
                        CASE
                            WHEN l.id_vip = %s THEN CONCAT(v3.prenom, ' ', v3.nom)
                            WHEN l.id_vip_liaison = %s THEN CONCAT(v4.prenom, ' ', v4.nom)
                        END AS liaison
                    FROM liaison l
                    LEFT JOIN vip v3 ON l.id_vip = v3.id_vip
                    LEFT JOIN vip v4 ON l.id_vip_liaison = v4.id_vip
                    WHERE l.id_vip = %s OR l.id_vip_liaison = %s;
                """, (id_vip, id_vip, id_vip, id_vip))
                liaisons = cur.fetchall()

        return render_template(
            "detailceleb.html",
            vip_details=vip_details,
            albums=albums,
            photos=photos,
            films=films,
            defiles=defiles,
            mariages=mariages,
            liaison = liaisons,
        )

    except Exception as e:
        return f"Erreur : {str(e)}", 500




@app.route('/log_admin', methods=['GET','POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        # Authentification
        if username == 'admin' and password == '123':  # Remplacez par une vraie authentification
            session['user'] = username
            return redirect(url_for('dashboard'))
    flash("Nom dutilisateur ou mot de passe incorrect.")
    return render_template('log_admin.html')

@app.route('/tab_bord', methods=['GET', 'POST'])
def dashboard():
    if 'user' not in session:
        return redirect(url_for('login'))
    
    conn = db.connect()
    cursor = conn.cursor()
    
    # Calcul des statistiques
    cursor.execute("SELECT COUNT(*) FROM vip")
    total_vips = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM article")
    total_articles = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM photo")
    total_photos = cursor.fetchone()[0]
    
    conn.close()
    
    return render_template('tab_bord.html', total_vips=total_vips, total_articles=total_articles, total_photos=total_photos)


@app.route('/manage', methods=['GET', 'POST'])
def manage():
    if 'user' not in session:
        return redirect(url_for('log_admin'))
    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    if request.method == 'POST':
        action = request.form.get('action')
        # Ajouter un VIP
        if action == 'add_vip':
            nom = request.form.get('nom')
            prenom = request.form.get('prenom')
            sexe = request.form.get('sexe')
            nationalite = request.form.get('nationalite')
            date_naissance = request.form.get('date_naissance')
            date_deces = request.form.get('date_deces') or None
            cursor.execute("INSERT INTO vip (nom, prenom, sexe, nationalite, date_naissance, date_deces) VALUES (%s, %s, %s, %s, %s, %s)",(nom, prenom, sexe, nationalite, date_naissance, date_deces,))
        elif action == 'update_vip':
            id_vip = request.form.get('id_vip')
            nom = request.form.get('nom')
            prenom = request.form.get('prenom')
            sexe = request.form.get('sexe')
            nationalite = request.form.get('nationalite')
            date_naissance = request.form.get('date_naissance')
            date_deces = request.form.get('date_deces') or None
            cursor.execute("UPDATE vip SET nom = %s, prenom = %s, sexe = %s, nationalite = %s, date_naissance = %s, date_deces = %s, WHERE id_vip = %s",(nom, prenom, sexe, nationalite, date_naissance, date_deces, id_vip,))
        # Supprimer un VIP
        elif action == 'delete_vip':
            id_vip = request.form.get('id_vip')
            cursor.execute("DELETE FROM vip WHERE id_vip = %s", (id_vip,)) 
        conn.commit()

    cursor.execute("SELECT * FROM vip")
    vip = cursor.fetchall()
    conn.close()
    return render_template('manage.html', vips=vip)

@app.route('/manage_article', methods=['GET', 'POST'])
def manage_art():
    if 'user' not in session:
        return redirect(url_for('log_admin'))
    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    if request.method == 'POST':
        action = request.form.get('action')
        # Ajouter un article
        if action == 'add_article':
            titre = request.form.get('Titre')
            num_page_article = request.form.get('Num_page')
            resume_article = request.form.get('Resume')
            numero_revue = request.form.get('Num_revue')
            cursor.execute("INSERT INTO article (titre, num_page_article, resume_, numero_revue) VALUES (%s, %s, %s, %s)", (titre, num_page_article, resume_article, numero_revue,))
        # Supprimer un Article
        elif action == 'delete_article':
            id_article = request.form.get('id_article')
            cursor.execute("DELETE FROM article WHERE id_article = %s", (id_article,))
        conn.commit()

    cursor.execute("SELECT * FROM article")
    article = cursor.fetchall()
    conn.close()
    return render_template('manage_article.html', article=article)


@app.route('/manage_photo', methods=['GET', 'POST'])
def manage_photo():
    if 'user' not in session:
        return redirect(url_for('log_admin'))
    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    if request.method == 'POST':
        action = request.form.get('action')
        # Ajouter une photo
        if action == 'add_photo':
            version_numerise = request.form.get('Vers_num') or None
            date_photo = request.form.get('date_photo')
            nom_photographe = request.form.get('nom_photographe')
            agence_photo = request.form.get('agence_photo')
            circonstance_photo = request.form.get('circonstance_photo') or None
            cursor.execute("INSERT INTO photo (version_numerise, date_photo, nom_photographe, agence_photo, circonstance_photo) VALUES (%s, %s, %s, %s, %s)", (version_numerise, date_photo, nom_photographe, agence_photo, circonstance_photo,))
        # Supprimer une photo
        elif action == 'delete_photo':
            id_photo = request.form.get('id_photo')
            cursor.execute("DELETE FROM photo WHERE id_photo = %s", (id_photo,))
        conn.commit()

    cursor.execute("SELECT * FROM photo")
    photo = cursor.fetchall()
    conn.close()
    return render_template('manage_photo.html', photo=photo)


@app.route('/manage_mariage', methods=['GET', 'POST'])
def manage_mariage():
    if 'user' not in session:
        return redirect(url_for('log_admin'))
    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    if request.method == 'POST':
        action = request.form.get('action')
        # Ajouter un mariage
        if action == 'add_mariage':
            date_mariage = request.form.get('date_mariage')
            lieu_mariage = request.form.get('lieu_mariage')
            date_separation = request.form.get('date_separation') or None
            circonstance_separation = request.form.get('circonstance_separation') or None
            id_vip_1 = request.form.get('id_vip_1')
            id_vip_2 = request.form.get('id_vip_2')
            cursor.execute("INSERT INTO detail_mariage (date_mariage, lieu_mariage, date_separation, circonstance_separation ,id_vip_1, id_vip_2) VALUES (%s,%s, %s, %s, %s, %s)",(date_mariage, lieu_mariage, date_separation, circonstance_separation,id_vip_1, id_vip_2,))
        # Ajouter une liaison
        elif action == 'add_liaison':
            id_vip = request.form.get('id_vip')
            id_vip_liaison = request.form.get('id_vip_liaison')
            date_annonce = request.form.get('date_annonce')
            cursor.execute("INSERT INTO liaison (id_vip, id_vip_liaison, date_annonce) VALUES (%s, %s, %s)",(id_vip, id_vip_liaison, date_annonce,))
        # Supprimer un mariage
        elif action == 'delete_mariage':
            id_mariage = request.form.get('id_mariage')
            cursor.execute("DELETE FROM detail_mariage WHERE id_mariage = %s", (id_mariage,))

        conn.commit()

    cursor.execute("SELECT * FROM detail_mariage")
    mariage = cursor.fetchall()

    cursor.execute("SELECT * FROM liaison")
    liaison = cursor.fetchall()

    conn.close()
    return render_template('manage_mariage.html', mariage=mariage, liaison=liaison)



@app.route('/manage_activite', methods=['GET', 'POST'])
def manage_activite():
    if 'user' not in session:
        return redirect(url_for('log_admin'))

    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    if request.method == 'POST':
        action = request.form.get('action')

        # Ajouter un album
        if action == 'add_album':
            titre = request.form.get('titre')
            date_rea = request.form.get('date_rea')
            nom_maisondisque = request.form.get('nommaisondisque')
            id_vip = request.form.get('id_vip')
            cursor.execute("INSERT INTO album (titre, date_rea, nommaisondisque, id_vip) VALUES (%s, %s, %s, %s)",(titre, date_rea, nom_maisondisque, id_vip))
            conn.commit()
                
        # Mettre à jour un album
        elif action == 'update_album':
            id_album = request.form.get('id_album')
            titre = request.form.get('titre')
            date_rea = request.form.get('date_rea')
            nom_maisondisque = request.form.get('nommaisondisque')
            id_vip = request.form.get('id_vip')
           
            cursor.execute("UPDATE album SET titre = %s, date_rea = %s, nommaisondisque = %s, id_vip = %s WHERE id_album = %s",(titre, date_rea, nom_maisondisque, id_vip, id_album))
            conn.commit()
        elif action == 'delete_album':
            id_album = request.form.get('id_album')

            cursor.execute("DELETE FROM album WHERE id_album = %s", (id_album,))
            conn.commit()

        elif action == 'add_defile':
            lieu = request.form.get('lieu')
            date_defile = request.form.get('date_defile')
            id_vip = request.form.get('id_vip')
            cursor.execute("INSERT INTO defile (lieu, date, id_vip) VALUES (%s, %s, %s)",(lieu, date_defile, id_vip))
            conn.commit()

        elif action == 'update_defile':
            id_defile = request.form.get('id_defile')
            lieu = request.form.get('lieu')
            date_defile = request.form.get('date_defile')
            id_vip = request.form.get('id_vip')
            cursor.execute("UPDATE defile SET lieu = %s, date = %s, id_vip = %s WHERE id_defile = %s",(lieu, date_defile, id_vip, id_defile))
            conn.commit()

        elif action == 'delete_defile':
            id_defile = request.form.get('id_defile')
            cursor.execute("DELETE FROM defile WHERE id_defile = %s", (id_defile,))
            conn.commit()

        elif action == 'add_film':
            visa = request.form.get('visa')
            date_realisation = request.form.get('date_realisation')
            titre = request.form.get('titre')
            id_vip = request.form.get('id_vip')

            cursor.execute("INSERT INTO film (visa, date_real, titre, id_vip) VALUES (%s ,%s, %s, %s)",(visa, date_realisation, titre, id_vip))
            conn.commit()

        elif action == 'update_film':
            visa = request.form.get('visa')
            date_realisation = request.form.get('date_realisation')
            titre = request.form.get('titre')
            id_vip = request.form.get('id_vip')
            cursor.execute("UPDATE film SET date_real = %s, titre = %s, id_vip = %s WHERE visa = %s",(date_realisation, titre, id_vip, visa))
            conn.commit()
        elif action == 'delete_film':
            visa = request.form.get('visa')
            cursor.execute("DELETE FROM film WHERE visa = %s", (visa,))
            conn.commit()

    # Récupérer les albums pour affichage
    
    cursor.execute("SELECT * FROM album")
    albums = cursor.fetchall()
    cursor.execute("SELECT * FROM defile")
    defile = cursor.fetchall()
    cursor.execute("SELECT * FROM film")
    film = cursor.fetchall()
    conn.close()

    return render_template('manage_activite.html', albums=albums, defile=defile, film=film)


@app.route('/manage_link', methods=['GET','POST'])
def manage_link():
    if 'user' not in session:
        return redirect(url_for('login'))

    conn = db.connect()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    if request.method == 'POST':
        action = request.form.get('action')
        if action == 'add_musique':
            id_artiste = request.form.get('id_artiste')
            id_album = request.form.get('id_album')
            cursor.execute("INSERT INTO musique (id_artiste, id_album) VALUES (%s, %s)", (id_artiste, id_album))
            conn.commit()
        elif action == 'delete_musique':
            id_artiste = request.form.get('id_artiste')
            id_album = request.form.get('id_album')
            cursor.execute("DELETE FROM musique WHERE id_artiste = %s AND id_album = %s", (id_artiste, id_album))
            conn.commit()
        elif action == 'add_acting':
            visa = request.form.get('visa')
            id_acteur = request.form.get('id_acteur')
            cursor.execute("INSERT INTO acting (visa, id_acteur) VALUES (%s, %s)", (visa, id_acteur))
            conn.commit()
        elif action == 'delete_acting':
            visa = request.form.get('visa')
            id_acteur = request.form.get('id_acteur')
            cursor.execute("DELETE FROM acting WHERE visa = %s AND id_acteur = %s", (visa, id_acteur))
            conn.commit()
        elif action == 'add_mannequinat':
            id_mannequin = request.form.get('id_mannequin')
            id_defile = request.form.get('id_defile')
            cursor.execute("INSERT INTO mannequinat (id_mannequin, id_defile) VALUES (%s, %s)", (id_mannequin, id_defile))
            conn.commit()
        elif action == 'delete_mannequinat':
            id_mannequin = request.form.get('id_mannequin')
            id_defile = request.form.get('id_defile')
            cursor.execute("DELETE FROM mannequinat WHERE id_mannequin = %s AND id_defile = %s", (id_mannequin, id_defile))
            conn.commit()

    cursor.execute("SELECT * FROM musique")
    musiques = cursor.fetchall()
    cursor.execute("SELECT * FROM acting")
    acting = cursor.fetchall()
    cursor.execute("SELECT * FROM mannequinat")
    mannequinat = cursor.fetchall()
    conn.close()


    return render_template('manage_link.html',musique = musiques, acting = acting, mannequinat = mannequinat)



@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('login'))


if __name__ == '__main__':
  app.run()