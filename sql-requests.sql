select * from newschema.artiste ;
select * from newschema.film ;
select * from newschema.internaute ;
select * from newschema.notation ;
select * from newschema.pays;
select * from newschema.role;
select * from newschema.realisateurs;

#Exo 1 Nom et année de naissance des artistes nés avant 1950.
select a.nom, a.annéeNaiss from newschema.artiste as a
where a.annéeNaiss < 1950;

#Exo 2 Titre de tous les drames.
select f.titre, f.genre from newschema.film as f
where f.genre = 'Drame';

#Exo 3 Quels rôles a joué Bruce Willis.
select DISTINCT a.nom,  a.prénom, r.nomRôle from newschema.artiste as a
inner join newschema.role as r on a.idArtiste=r.idActeur
where a.prénom = 'Bruce' and a.nom = 'Willis';

#Exo 4 Qui est le réalisateur de Memento.
select f.idRéalisateur, f.titre, r.nom from newschema.film as f
inner join newschema.realisateurs as r on f.idRéalisateur=r.idRéalisateur
where f.titre = 'Memento';

#Exo 5 Quelles sont les notes obtenues par le film Fargo
select n.note, f.titre from newschema.notation as n
inner join newschema.film as f on n.idFilm=f.idFilm
where f.titre = 'Fargo';

#Exo 6 Qui a joué le rôle de Chewbacca?
select DISTINCT r.nomRôle, a.nom, a.prénom from newschema.role as r
inner join newschema.artiste as a on a.idArtiste=r.idActeur
where r.nomRôle = 'Chewbacca';

#Exo 7 Dans quels films Bruce Willis a-t-il joué le rôle de John McClane?
select DISTINCT a.nom,  a.prénom, r.nomRôle from newschema.artiste as a
inner join newschema.role as r on a.idArtiste=r.idActeur
where a.prénom = 'Bruce' and a.nom = 'Willis' and r.nomRôle = 'John McClane';

#Exo 8 Nom des acteurs de 'Sueurs froides'
select DISTINCT a.nom,  a.prénom, f.titre from newschema.artiste as a
inner join newschema.role as r on a.idArtiste=r.idActeur
inner join newschema.film as f on f.idFilm=r.idFilm
where f.titre = 'Sueurs froides';

#Exo 9 Quelles sont les films notés par l''internaute Prénom 0 Nom0
select DISTINCT f.titre, nom from  
(select n.idFilm, CONCAT(i.nom, ' ', i.prénom) as nom from newschema.internaute as i
inner join newschema.notation as n on n.email=i.email
where i.nom = 'Nom0' and i.prénom = 'Prénom0') as note
inner join newschema.film as f on f.idFilm=note.idFilm;

#Exo 10 Films dont le réalisateur est Tim Burton, et l’un des acteurs Johnny Depp.
select DISTINCT CONCAT(a.nom,' ',  a.prénom) as nom, f.titre, f.idRéalisateur from newschema.artiste as a
inner join newschema.role as r on a.idArtiste=r.idActeur
inner join newschema.film as f on f.idFilm=r.idFilm
where CONCAT(a.prénom,' ',a.nom) = 'Johnny Depp';

#Exo 11 Titre des films dans lesquels a joué ́Woody Allen. Donner aussi le rôle.
select DISTINCT CONCAT(a.nom,' ',  a.prénom) as Acteur_nom, r.nomRôle, f.titre from newschema.artiste as a
inner join newschema.role as r on a.idArtiste=r.idActeur
inner join newschema.film as f on f.idFilm=r.idFilm
where CONCAT(a.prénom,' ',a.nom) = 'Woody Allen';

#Exo 12 Quel metteur en scène a tourné dans ses propres films ? Donner  le nom, le rôle et le titre des films.
select DISTINCT CONCAT(a.prénom,' ',  a.nom) as Acteur_nom, re.nom as realisateur, r.nomRôle, f.titre from newschema.artiste as a
inner join newschema.role as r on a.idArtiste=r.idActeur
inner join newschema.film as f on f.idFilm=r.idFilm
inner join newschema.realisateurs as re 
on f.idRéalisateur = re.idRéalisateur
and trim(concat(a.prénom,' ',  a.nom)) = trim(re.nom);

#Exo 13 Titre des films de Quentin Tarantino dans lesquels il n’a pas joué
select filmsDeTarantino.titre, filmsDeTarantino.nom, acteursSansTarantino.acteur from
(select DISTINCT f.titre, f.idFilm, re.nom as realisateur from newschema.film as f
inner join newschema.realisateurs as re 
on f.idRéalisateur = re.idRéalisateur
where trim(re.nom) = 'Quentin Tarantino'
) as filmsDeTarantino
inner join 
(select r.idFilm, r.idActeur, concat(a.prénom,' ',  a.nom) as acteur from newschema.role as r 
inner join newschema.artiste as a
on a.idArtiste=r.idActeur
where a.prénom != 'Tarantino') as acteursSansTarantino;

#Exo 14 Quel metteur en scène a tourné ́en tant qu’acteur ? Donner le nom, le rôle et le titre des films dans lesquels cet artiste a joué.
select acteur.nom, r.nomRôle, f.titre from (
select * from newschema.artiste as a
where concat(a.prénom,' ',  a.nom) in 
(select DISTINCT trim(re.nom) from newschema.film as f
inner join newschema.realisateurs as re 
on f.idRéalisateur = re.idRéalisateur) 
) as acteur
inner join newschema.role as r on acteur.idArtiste=r.idActeur
inner join newschema.film as f on f.idFilm=r.idFilm;

#Exo 15 Donnez les films de Hitchcock sans James Stewart
select f.titre, concat(a.prénom,' ',  a.nom) as acteur, re.nom as realisateur from newschema.film as f
inner join newschema.realisateurs as re 
on f.idRéalisateur = re.idRéalisateur
left join newschema.role as r
on f.idFilm=r.idFilm 
left join newschema.artiste as a
on a.idArtiste=r.idActeur
where concat(a.prénom,' ',  a.nom) != 'James Stewart' and re.nom = ' Alfred Hitchcock';

#Exo 16 Dans quels films le réalisateur a-t-il le même prénom que l’un des interprètes ? (titre, nom du réalisateur, nom de l’interprète). Le réalisateur et l’interprète ne doivent pas être la même personne.
select re_prénom, re_nom, a.prénom, a.nom from
(select distinct left(re.nom, instr(trim(re.nom), " ")+1) as re_prénom, 
right(re.nom, length(re.nom)-instr(trim(re.nom), " ")) as re_nom,
r.idActeur from newschema.realisateurs as re 
inner join newschema.film as f
on f.idRéalisateur = re.idRéalisateur
inner join newschema.role as r
on f.idFilm=r.idFilm 
) as reprenom
inner join newschema.artiste as a
on a.idArtiste=reprenom.idActeur
where trim(prénom) = trim(reprenom.re_prénom) and trim(nom) != trim(reprenom.re_nom);

#Exo 17 Les films sans rôle
select titre,nomRôle  from newschema.film as f
left join newschema.role as r
on f.idFilm=r.idFilm 
where nomRôle is null;

#Exo 18 Quelles sont les films non notés par l''internaute Prénom1 Nom1
select DISTINCT f.titre, nom from  
(select n.idFilm, CONCAT(i.nom, ' ', i.prénom) as nom from newschema.internaute as i
inner join newschema.notation as n on n.email=i.email
where i.nom != 'Nom1' and i.prénom != 'Prénom1') as note
right join newschema.film as f on f.idFilm=note.idFilm;

#Exo 19 Quels acteurs n’ont jamais réalisé de film ?
select distinct concat(acteursSansFilm.prénom,' ',  acteursSansFilm.nom) as acteur_nom from (
select * from newschema.artiste as a
where concat(a.prénom,' ',  a.nom) not in 
(select trim(re.nom) from newschema.realisateurs as re)
) as acteursSansFilm;

#Exo 20 Quelle est la moyenne des notes de Memento
select * from newschema.notemoyenne
where titre = 'Memento';

#Exo 21 id, nom et prénom des réalisateurs, et nombre de films qu’ils ont tournés.
select nom, count(idFilm) from newschema.realisateurs as re
inner join newschema.film as f
on f.idRéalisateur = re.idRéalisateur 
group by nom;

#Exo 22 Nom et prénom des réalisateurs qui ont tourné au moins deux films.
select nom, count(idFilm) from newschema.realisateurs as re
inner join newschema.film as f
on f.idRéalisateur = re.idRéalisateur 
group by nom
having count(idFilm)>=2;

#Exo 23 Quels films ont une moyenne des notes supérieure à 7
select * from newschema.notemoyenne
where moyenne > 7;
