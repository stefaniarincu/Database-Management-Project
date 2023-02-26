-----------------------------------------------------------CREARE TABELE------------------------------------------------------------
CREATE TABLE tara
    (id_tara VARCHAR2(3) CONSTRAINT pk_tara PRIMARY KEY,
     nume_tara VARCHAR2(50) CONSTRAINT null_nume_tara NOT NULL);

CREATE TABLE locatie
    (id_locatie NUMBER(4) CONSTRAINT pk_locatie PRIMARY KEY,
     id_tara VARCHAR2(3) CONSTRAINT null_loc_tara NOT NULL,
     oras VARCHAR2(30) CONSTRAINT null_oras_loc NOT NULL,
	 strada VARCHAR2(20) CONSTRAINT null_strada_loc NOT NULL,
	 nr_strada NUMBER(3),
     CONSTRAINT fk_loc_tara FOREIGN KEY(id_tara) REFERENCES tara(id_tara));
     
CREATE TABLE job
    (cod_job VARCHAR2(6) CONSTRAINT pk_job PRIMARY KEY,
	 nume_job VARCHAR2(20) CONSTRAINT null_nume_job NOT NULL,
	 salariu_min NUMBER(8, 2) CONSTRAINT null_sal_min NOT NULL,
	 salariu_max NUMBER(8, 2) CONSTRAINT null_sal_max NOT NULL,
	 CONSTRAINT unq_nume_job UNIQUE(nume_job),
	 CONSTRAINT ck_sal_min CHECK(salariu_min > 0.0),
	 CONSTRAINT ck_sal_max CHECK(salariu_max > 0.0));

CREATE TABLE cinematograf
    (cod_cinema NUMBER(4) CONSTRAINT pk_cinema PRIMARY KEY,
     nume_cinema VARCHAR2(40) CONSTRAINT null_nume_cinema NOT NULL,
	 id_locatie NUMBER(4) CONSTRAINT null_loc_cinema NOT NULL,
	 complex VARCHAR2(40),
	 telefon VARCHAR2(20),
	 email CHAR(25) CONSTRAINT null_email_cinema NOT NULL,
	 data_desch DATE DEFAULT SYSDATE,
	 CONSTRAINT unq_email_cinema UNIQUE(email),
	 CONSTRAINT fk_cinem_loc FOREIGN KEY(id_locatie) REFERENCES locatie(id_locatie),
     CONSTRAINT unqid_loc_cin UNIQUE(id_locatie));

CREATE TABLE angajat
    (cod_angajat NUMBER(4) CONSTRAINT pk_angajat PRIMARY KEY,
	 nume VARCHAR2(25) CONSTRAINT null_nume_ang NOT NULL,
	 prenume VARCHAR2(25),
     email CHAR(25) CONSTRAINT null_email_ang NOT NULL,
	 telefon VARCHAR2(20),
     data_ang DATE DEFAULT SYSDATE,
     salariu NUMBER(8,2) CONSTRAINT null_sal_ang NOT NULL,
     nr_ore NUMBER(2) CONSTRAINT null_nr_ore NOT NULL,
     id_superior NUMBER(4) CONSTRAINT fk_ang_ang_sup  REFERENCES angajat(cod_angajat),
     cod_cinema NUMBER(4) CONSTRAINT null_ang_cin NOT NULL,
     cod_job VARCHAR2(6) CONSTRAINT null_ang_job NOT NULL,
	 CONSTRAINT unq_nume_pren_ang UNIQUE(nume, prenume),
	 CONSTRAINT unq_email_ang UNIQUE(email),
     CONSTRAINT ck_nr_ore_ang CHECK(nr_ore > 0 AND nr_ore < 24),
     CONSTRAINT ck_sal_ang CHECK(salariu > 0),
     CONSTRAINT fk_ang_cin FOREIGN KEY(cod_cinema) REFERENCES cinematograf(cod_cinema),
     CONSTRAINT fk_ang_job FOREIGN KEY(cod_job) REFERENCES job(cod_job));

CREATE TABLE istoric_lucru
    (cod_angajat NUMBER(4) CONSTRAINT fk_ang_lucr REFERENCES angajat(cod_angajat) ON DELETE CASCADE,
     data_start DATE CONSTRAINT null_data_start NOT NULL,
     data_demisie DATE DEFAULT SYSDATE,
     cod_cinema NUMBER(4) CONSTRAINT null_ist_cin NOT NULL,
	 cod_job VARCHAR2(6) CONSTRAINT null_ist_job NOT NULL,
     CONSTRAINT fk_cin_lucr FOREIGN KEY(cod_cinema) REFERENCES cinematograf(cod_cinema) ON DELETE CASCADE,
     CONSTRAINT fk_job_lucr FOREIGN KEY(cod_job) REFERENCES job(cod_job) ON DELETE CASCADE,
	 CONSTRAINT pk_ang_ist_lucr PRIMARY KEY(cod_angajat, data_start));

CREATE TABLE film
    (cod_film NUMBER(4) CONSTRAINT pk_film PRIMARY KEY,
     nume_film VARCHAR2(25) CONSTRAINT null_nume_film NOT NULL,
	 gen_princ VARCHAR2(20) CONSTRAINT null_gen NOT NULL, 
	 durata NUMBER(3) DEFAULT 0,
	 rating NUMBER(2, 1) CONSTRAINT ck_rating CHECK(rating > 0.0 AND rating <= 10.0),
	 an_aparitie NUMBER(4) CONSTRAINT null_an_aparitie NOT NULL,
	 CONSTRAINT ck_an_ap CHECK(an_aparitie > 0),
	 CONSTRAINT unq_nume_film_an_ap UNIQUE(nume_film, an_aparitie));
     
CREATE TABLE ruleaza
    (cod_rulare NUMBER(4) CONSTRAINT pk_ruleaza PRIMARY KEY,
	 cod_cinema NUMBER(4) CONSTRAINT null_rul_cin NOT NULL,
	 cod_film NUMBER(4) CONSTRAINT null_rul_film NOT NULL,
	 data_inceput DATE DEFAULT SYSDATE,
	 data_final DATE DEFAULT SYSDATE + 15,
     CONSTRAINT fk_cin_rul FOREIGN KEY(cod_cinema) REFERENCES cinematograf(cod_cinema) ON DELETE CASCADE,
     CONSTRAINT fk_film_rul FOREIGN KEY(cod_film) REFERENCES film(cod_film) ON DELETE CASCADE);

CREATE TABLE actor
    (id_actor NUMBER(4) CONSTRAINT pk_actor PRIMARY KEY,
	 nume VARCHAR2(25) CONSTRAINT null_nume_actor NOT NULL,
     prenume VARCHAR2(25),
     id_tara VARCHAR2(3) CONSTRAINT null_tara_act NOT NULL,
	 nr_premii NUMBER(3) DEFAULT 0,
	 an_debut NUMBER(4) CONSTRAINT null_an_debut_act NOT NULL,
	 CONSTRAINT unq_nume_pren_act UNIQUE(nume, prenume),
     CONSTRAINT ck_nr_premii_act CHECK(nr_premii >= 0),
	 CONSTRAINT ck_an_debut_act CHECK(an_debut > 0),
     CONSTRAINT fk_act_tara FOREIGN KEY(id_tara) REFERENCES tara(id_tara));
     
CREATE TABLE joaca
    (cod_joaca NUMBER(4) CONSTRAINT pk_joaca PRIMARY KEY,
	 cod_film NUMBER(4) CONSTRAINT null_film_joaca NOT NULL,
     id_actor NUMBER(4) CONSTRAINT null_act_joaca NOT NULL,
	 rol VARCHAR2(20) CONSTRAINT null_rol_joaca NOT NULL,
     CONSTRAINT fk_film_joaca FOREIGN KEY(cod_film) REFERENCES film(cod_film) ON DELETE CASCADE,
     CONSTRAINT fk_act_joaca FOREIGN KEY(id_actor) REFERENCES actor(id_actor) ON DELETE CASCADE);
 
CREATE TABLE regizor
    (id_regizor NUMBER(4) CONSTRAINT pk_regizor PRIMARY KEY,
	 nume VARCHAR2(25) CONSTRAINT null_nume_regizor NOT NULL,
     prenume VARCHAR2(25),
	 id_tara VARCHAR2(3) CONSTRAINT null_tara_reg NOT NULL,
	 nr_premii NUMBER(3) DEFAULT 0,
	 CONSTRAINT unq_nume_pren_reg UNIQUE(nume, prenume),
	 CONSTRAINT ck_nr_premii_reg CHECK(nr_premii >= 0),
     CONSTRAINT fk_tara_reg FOREIGN KEY(id_tara) REFERENCES tara(id_tara));
     
CREATE TABLE regizeaza
    (cod_film NUMBER(4) CONSTRAINT fk_film_regiz REFERENCES film(cod_film) ON DELETE CASCADE,
	 id_regizor NUMBER(4) CONSTRAINT fk_regizor_regiz REFERENCES regizor(id_regizor) ON DELETE CASCADE,
     an_inceput NUMBER(4) CONSTRAINT null_an_inc_reg NOT NULL,
	 CONSTRAINT pk_regizor_film PRIMARY KEY(cod_film, id_regizor),
	 CONSTRAINT ck_an_inc_reg CHECK(an_inceput > 0));

CREATE TABLE sala
    (nr_sala NUMBER(2),
	 cod_cinema NUMBER(4) CONSTRAINT fk_sala_cinema REFERENCES cinematograf(cod_cinema) ON DELETE CASCADE,
	 tip VARCHAR2(10), 
	 CONSTRAINT ck_nr_sala CHECK(nr_sala <= 40 AND nr_sala > 0),
	 CONSTRAINT pk_sala_cin PRIMARY KEY(nr_sala, cod_cinema));

CREATE TABLE difuzare
    (cod_difuzare NUMBER(4) CONSTRAINT pk_difuzare PRIMARY KEY,
	 cod_film NUMBER(4) CONSTRAINT null_dif_film NOT NULL,
	 nr_sala NUMBER(2) CONSTRAINT null_sala_dif NOT NULL,
	 cod_cinema NUMBER(4) CONSTRAINT null_cin_dif NOT NULL,
	 data_inc DATE DEFAULT SYSDATE,
	 ora_inc NUMBER(2) CONSTRAINT null_ora_inc NOT NULL,
	 CONSTRAINT ck_ora_inc CHECK(ora_inc > 0 AND ora_inc < 24),
	 CONSTRAINT fk_film_dif FOREIGN KEY(cod_film) REFERENCES film(cod_film) ON DELETE CASCADE,
	 CONSTRAINT fk_nr_sala_cin_dif FOREIGN KEY(nr_sala, cod_cinema) 
                    REFERENCES sala(nr_sala, cod_cinema) ON DELETE CASCADE);
     
CREATE TABLE bilet_cumparat
    (cod_bilet NUMBER(4) CONSTRAINT pk_bilet PRIMARY KEY,
	 pret NUMBER(8, 2) DEFAULT 0.0,
	 nr_loc NUMBER(3) CONSTRAINT null_loc_bilet NOT NULL,
	 nr_rand NUMBER(2) CONSTRAINT null_rand_bilet NOT NULL,
	 cod_difuzare NUMBER(4) CONSTRAINT null_cod_dif_bilet NOT NULL,
	 CONSTRAINT ck_pret CHECK(pret >= 0.0),
	 CONSTRAINT ck_nr_loc CHECK(nr_loc > 0 AND nr_loc <= 300),
	 CONSTRAINT ck_nr_rand CHECK(nr_rand > 0 AND nr_rand <= 20),
	 CONSTRAINT fk_bilet_dif FOREIGN KEY(cod_difuzare) REFERENCES difuzare(cod_difuzare) ON DELETE CASCADE);   

--------------------------------------------------------------INSERARE DATE----------------------------------------------------------
INSERT INTO tara
VALUES('RO', 'Romania');
INSERT INTO tara
VALUES('SUA', 'Statele Unite ale Americii');
INSERT INTO tara
VALUES('EN', 'Anglia');
INSERT INTO tara
VALUES('CA', 'Canada');
INSERT INTO tara
VALUES('IL', 'Israel');
INSERT INTO tara
VALUES('AR', 'Argentina');
INSERT INTO tara
VALUES('MD', 'Moldova');
INSERT INTO tara
VALUES('NO', 'Norvegia');

SELECT * FROM tara;

INSERT INTO locatie
VALUES(100, 'RO', 'Bucuresti', 'Bd Doina Cornea', 4);
INSERT INTO locatie
VALUES(105, 'RO', 'Bucuresti', 'Bd Timisoara', 26);
INSERT INTO locatie
VALUES(110, 'RO', 'Bucuresti', 'Mihai Eminescu', null);
INSERT INTO locatie
VALUES(115, 'RO', 'Sibiu', 'Aurel Vlaicu', 11);
INSERT INTO locatie
VALUES(120, 'RO', 'Suceava', 'Energeticului', null);
INSERT INTO locatie
VALUES(125, 'RO', 'Iasi', 'Tudor Vladimirescu', 2);
INSERT INTO locatie
VALUES(130, 'RO', 'Constanta', 'Aurel Vlaicu', 220);
INSERT INTO locatie
VALUES(135, 'RO', 'Cluj-Napoca', 'Bd Eroilor', 51);
INSERT INTO locatie
VALUES(140, 'RO', 'Baia Mare', 'Victoriei', 73);
INSERT INTO locatie
VALUES(145, 'RO', 'Pitesti', 'Calea Bucuresti', 36);
INSERT INTO locatie
VALUES(150, 'RO', 'Drobeta Turnu Severin', 'Bd Alunis', 78);

SELECT * FROM locatie;

INSERT INTO job
VALUES('CAS', 'Casier', 3792.1, 6293.0);
INSERT INTO job
VALUES('AG_C', 'Agent de Curatenie', 1239.2, 1897.9);
INSERT INTO job
VALUES('MAN', 'Manager', 5439.22, 6934.2);
INSERT INTO job
VALUES('ING_S', 'Inginer Sunet', 3234.2, 4593.3);
INSERT INTO job
VALUES('ING_T', 'Inginer Tehnic', 2134.2, 5593.3);
INSERT INTO job
VALUES('PLAS', 'Plasator', 1231.4, 3432.43);
INSERT INTO job
VALUES('BAR_C', 'Barman Cafenea', 1312.3, 2313.3);
INSERT INTO job
VALUES('BAR', 'Barman', 1192.3, 1922.0);

SELECT * FROM job;

INSERT INTO cinematograf
VALUES(120, 'Cinema City PLake', 105, 'Park Lake', '0314.032.700', 'cin.city.pklk@yahoo.com', '2 may 2016');
INSERT INTO cinematograf
VALUES(140, 'Cinema City Sibiu', 115, null, '0734.566.932', 'cin.city.arta@yahoo.com', '27 december 2008');
INSERT INTO cinematograf
VALUES(160, 'Cinema City Cluj', 135, 'Iulius Mall', '0314.130.400', 'cin.city.ilm@yahoo.com', '16 april 2014');
INSERT INTO cinematograf
VALUES(180, 'Cinema City Constanta', 130, null, null, 'cin.city.ct@yahoo.com', '17 october 2018');
INSERT INTO cinematograf
VALUES(200, 'Cinema City Baia Mare', 140, null, '0362.403.030', 'cin.city.bm@yahoo.com', '7 may 2016');
INSERT INTO cinematograf
VALUES(220, 'Cinema City Afi Cotroceni', 100, 'Afi Cotroceni', '0355.671.129', 'cin.city.afi@yahoo.com', '13 april 2013');
INSERT INTO cinematograf
VALUES(240, 'Cinema City Iasi', 125, 'Iulius Mall', '0314.130.000', 'cin.city.iasi@yahoo.com', '9 july 2009');
INSERT INTO cinematograf
VALUES(260, 'Cinema City Pitesti', 145, 'VIVO!', '0314.130.080', 'cin.city.pit@yahoo.com', '12 may 2014');
INSERT INTO cinematograf
VALUES(280, 'Cinema City DrobetaTS', 150, 'Severin Shopping Center', '031.413.0380', 'cin.city.dts@yahoo.com', '4 july 2016'); 

SELECT * FROM cinematograf;

INSERT INTO angajat
VALUES(1000, 'Popescu', 'Ion', 'ion.popescu@gmail.com', '0741.311.314', '3 june 2018', 6023.5, 9, null, 120, 'MAN');
INSERT INTO angajat
VALUES(1017, 'Tudor', 'Maria', 'maria.tudor@gmail.com', '0712.133.292', '5 september 2017', 5998.8, 12, null, 140, 'MAN');
INSERT INTO angajat
VALUES(1034, 'Georgesc', 'Vasile', 'vasile.georgesc@gmail.com', null, '5 may 2019', 1555.1, 6, null, 140, 'AG_C');
INSERT INTO angajat
VALUES(1051, 'Matei', 'Andrei', 'andrei.matei@gmail.com', '0799.532.678', '27 january 2020', 4672.5, 8, 1000, 120, 'CAS');
INSERT INTO angajat
VALUES(1085, 'Iana', 'Gabriela', 'gabriela.iana@gmail.com', '0712.623.881', '12 april 2021', 3972.5, 8, 1051, 120, 'CAS');
INSERT INTO angajat
VALUES(1102, 'Miron', 'Costin', 'costin.miron@gmail.com', '0771.229.345', '19 november 2019', 5789.1, 9, null, 260, 'MAN');
INSERT INTO angajat
VALUES(1119, 'Banu', 'Codrin', 'codrin.banu@gmail.com', '0741.721.921', '19 november 2019', 1231.1, 4, 1102, 260, 'ING_S');
INSERT INTO angajat
VALUES(1136, 'Crivat', 'Gheorghe', 'gheo.crivat@gmail.com', null, '21 december 2018', 5772.6, 7, null, 180, 'MAN');
INSERT INTO angajat
VALUES(1153, 'Stan', 'Elena', 'elena.stan@gmail.com', '0789.123.433', '13 february 2019', 4129.7, 10, 1136, 180, 'ING_S');
INSERT INTO angajat
VALUES(1170, 'Pitco', 'Natanael', 'nate.pitco@gmail.com', null, '2 may 2018', 6191.0, 6, null, 200, 'MAN');
INSERT INTO angajat
VALUES(1187, 'Florea', 'Ana', 'ana.florea@gmail.com', null, '9 july 2020', 5972.5, 8, null, 240, 'MAN');
INSERT INTO angajat
VALUES(1204, 'Nistor', 'Viviana', 'viv.nistor@gmail.com', '0712.385.763', '12 april 2022', 3472.5, 6, 1187, 240, 'ING_T');
INSERT INTO angajat
VALUES(1221, 'Leona', 'Antonia', 'anto.leona@gmail.com', '0711.332.454', '19 august 2020', 5789.1, 8, null, 260, 'MAN');
INSERT INTO angajat
VALUES(1238, 'Nils', 'Corina', 'corina.nils@gmail.com', null, '1 march 2019', 6100.5, 9, null, 160, 'MAN');
INSERT INTO angajat
VALUES(1255, 'Petre', 'Cosmin', 'cosmin.petre@gmail.com', '0718.223.344', '26 june 2021', 5972.5, 7, 1255, 160, 'ING_S');
INSERT INTO angajat
VALUES(1272, 'Popa', 'Maria', 'maria.popa@yahoo.com', '0792.233.211', '15 may 2017', 6132.1, 8, null, 220, 'MAN');
INSERT INTO angajat
VALUES(1289, 'Dumitran', 'George', 'george.dumi@gmail.com', '0793.557.876', '22 june 2019', 4432.1, 4, null, 160, 'ING_T');
INSERT INTO angajat
VALUES(1306, 'Stanciu', 'Ecaterina', 'eca_stnc@gmail.com', '0732.323.233', '12 december 2021', 3693.6, 6, 1170, 200, 'ING_S');
INSERT INTO angajat
VALUES(1323, 'Chesaru', 'Ana', 'ana.chesaru@yahoo.com', '0723.324.443', '6 october 2022', 1922, 8, 1272, 220, 'BAR');
INSERT INTO angajat
VALUES(1340, 'Toth', 'Raluca', 'raluca_toth@gmail.com', '0799.112.321', '15 february 2022', 1666.5, 4, 1272, 220, 'BAR');
INSERT INTO angajat
VALUES(1357, 'Luca', 'Ioan', 'ioan.luca@yahoo.com', '0791.211.322', '7 june 2022', 4747.1, 8, 1289, 160, 'ING_T');
INSERT INTO angajat
VALUES(1394, 'Coca', 'Emanuel', 'emanuel.coca@gmail.com', '0790.134.755', '1 january 2019', 2525.6, 4, 1136, 180, 'PLAS');
INSERT INTO angajat
VALUES(1411, 'Pitulan', 'Gabriela', 'gabitza.p@gmail.com', '0700.212.332', '12 december 2020', 2999.2, 6, 1238, 160, 'PLAS');
INSERT INTO angajat
VALUES(1428, 'Miron', 'Luminita', 'lumi.miron@yahoo.com', null, '6 october 2022', 5555.5, 5, 1272, 220, 'CAS');
INSERT INTO angajat
VALUES(1445, 'Tanase', 'Vlad', 'vlad.t@gmail.com', '0721.345.788', '1 december 2022', 5050.3, 6, 1428, 220, 'CAS');
INSERT INTO angajat
VALUES(1462, 'Tamas', 'Vasilica', 'v.tamas@gmail.com', null, '1 december 2022', 2002, 6, 1238, 160, 'BAR');

SELECT * FROM angajat;

INSERT INTO istoric_lucru
VALUES(1034, '3 may 2018', '5 may 2019', 120, 'AG_C');
INSERT INTO istoric_lucru
VALUES(1102, '17 july 2019', '18 november 2019', 120, 'PLAS');
INSERT INTO istoric_lucru
VALUES(1221, '19 november 2018', '19 august 2020', 260, 'MAN');
INSERT INTO istoric_lucru
VALUES(1255, '7 november 2020', '20 june 2021', 160, 'BAR');
INSERT INTO istoric_lucru
VALUES(1119, '7 may 2014', '7 june 2015', 260, 'ING_S');
INSERT INTO istoric_lucru
VALUES(1119, '8 june 2015', '18 november 2019', 260, 'CAS');
INSERT INTO istoric_lucru
VALUES(1289, '20 march 2019', '13 june 2019', 240, 'ING_T');
INSERT INTO istoric_lucru
VALUES(1462, '15 july 2022', '29 november 2022', 220, 'BAR_C');
INSERT INTO istoric_lucru
VALUES(1411, '7 may 2018', '11 december 2020', 260, 'PLAS');
INSERT INTO istoric_lucru
VALUES(1340, '9 december 2021', '9 february 2022', 160, 'BAR_C');

SELECT * FROM istoric_lucru;

INSERT INTO sala
VALUES(1, 120, 'VIP');
INSERT INTO sala
VALUES(4, 120, 'Multiplex');
INSERT INTO sala
VALUES(7, 120, 'Megaplex');
INSERT INTO sala
VALUES(10, 140, 'Multiplex');
INSERT INTO sala
VALUES(13, 160, 'Complex');
INSERT INTO sala
VALUES(16, 160, 'VIP');
INSERT INTO sala
VALUES(19, 180, 'Megaplex');
INSERT INTO sala
VALUES(22, 200, 'Multiplex');
INSERT INTO sala
VALUES(25, 240, 'Complex');
INSERT INTO sala
VALUES(28, 220, 'VIP');
INSERT INTO sala
VALUES(31, 220, 'VIP');
INSERT INTO sala
VALUES(34, 200, 'Megaplex');
INSERT INTO sala
VALUES(37, 260, 'Multiplex');
INSERT INTO sala
VALUES(40, 260, 'Complex');
INSERT INTO sala
VALUES(4, 140, 'Complex');
INSERT INTO sala
VALUES(7, 200, 'Complex');
INSERT INTO sala
VALUES(10, 120, 'Megaplex');
INSERT INTO sala
VALUES(13, 120, 'VIP');
INSERT INTO sala
VALUES(16, 260, 'VIP');
INSERT INTO sala
VALUES(19, 220, 'Multiplex');

SELECT * FROM sala;

INSERT INTO film
VALUES(10, 'Uncharted', 'Actiune', 116, 6.4, 2022);
INSERT INTO film
VALUES(110, 'Spiderman: No Way Home', 'Actiune', 148, 8.4, 2021);
INSERT INTO film
VALUES(210, 'Free Guy', 'Actiune', 115, 7.1, 2021);
INSERT INTO film
VALUES(310, 'Little Women', 'Romance', 135, 7.8, 2019);
INSERT INTO film
VALUES(410, 'It', 'Horror', 135, 7.4, 2017);
INSERT INTO film
VALUES(510, 'Encanto', 'Animatie', 109, 7.8, 2021);
INSERT INTO film
VALUES(610, 'Star Wars: Episode III', 'Science Fiction', 140, 7.6, 2005);
INSERT INTO film
VALUES(710, 'Black Widow', 'Actiune', 134, 6.4, 2021);
INSERT INTO film
VALUES(810, 'Titanic', 'Drama', 194, 7.9, 1997);
INSERT INTO film
VALUES(910, 'The Batman', 'Crima', 176, 8.0, 2022);
INSERT INTO film
VALUES(1010, 'Red Notice', 'Comedie', 118, 6.3, 2021);
INSERT INTO film
VALUES(1110, 'Venom', 'Actiune', 112, 7.9, 2018);
INSERT INTO film
VALUES(1210, 'Crimson Peak', 'Horror', 119, 7.0, 2015);
INSERT INTO film
VALUES(1310, 'Yes Day', 'Familie', 146, 5.7, 2021);
INSERT INTO film
VALUES(1410, 'Zootopia', 'Animatie', 108, 8.5, 2016);
INSERT INTO film
VALUES(1510, 'Doctor Strange', 'Science Fiction', 116, 7.5, 2016);
INSERT INTO film
VALUES(1610, 'It chapter 2', 'Horror', 169, 6.5, 2019);
INSERT INTO film
VALUES(1710, 'Death on the Nile', 'Mister', 127, 6.9, 2022);
INSERT INTO film
VALUES(1810, 'Sherlock Holmes', 'Mister', 128, 8.6, 2009);
INSERT INTO film
VALUES(1910, 'Divergent', 'Romance', 140, 8.1, 2014);

SELECT * FROM film;

INSERT INTO ruleaza
VALUES(260, 120, 10, '2 march 2022', '13 may 2022');
INSERT INTO ruleaza
VALUES(300, 120, 1210, '21 june 2018', '13 january 2019');
INSERT INTO ruleaza
VALUES(340, 140, 1110, '17 july 2020', '23 november 2020');
INSERT INTO ruleaza
VALUES(380, 180, 1110, '17 july 2020', '23 november 2020');
INSERT INTO ruleaza
VALUES(420, 200, 810, '15 april 2018', '19 may 2019');
INSERT INTO ruleaza
VALUES(460, 200, 410, '5 september 2017', '16 december 2017');
INSERT INTO ruleaza
VALUES(500, 200, 1610, '15 november 2019', '8 february 2020');
INSERT INTO ruleaza
VALUES(540, 160, 1610, '15 november 2019', '8 february 2020');
INSERT INTO ruleaza
VALUES(580, 140, 710, '28 may 2021', '13 october 2021');
INSERT INTO ruleaza
VALUES(620, 180, 1210, '23 december 2015', '27 may 2016');
INSERT INTO ruleaza
VALUES(660, 180, 510, '1 january 2022', '23 april 2022');
INSERT INTO ruleaza
VALUES(700, 220, 910, '15 march 2022', '23 july 2022');
INSERT INTO ruleaza
VALUES(740, 220, 1710, '15 april 2022', '3 september 2022');
INSERT INTO ruleaza
VALUES(780, 200, 610, '5 june 2015', '18 august 2015');
INSERT INTO ruleaza
VALUES(820, 240, 610, '6 june 2015', '18 september 2015');
INSERT INTO ruleaza
VALUES(860, 160, 1310, '6 april 2021', '14 november 2021');
INSERT INTO ruleaza
VALUES(900, 120, 1610, '15 november 2019', '8 february 2020');
INSERT INTO ruleaza
VALUES(940, 200, 710, '28 may 2021', '13 october 2021');
INSERT INTO ruleaza
VALUES(980, 240, 1210, '23 december 2015', '27 may 2016');
INSERT INTO ruleaza
VALUES(1020, 240, 510, '1 january 2022', '23 april 2022');
INSERT INTO ruleaza
VALUES(1060, 260, 1510, '19 may 2017', '21 december 2017');
INSERT INTO ruleaza
VALUES(1100, 260, 310, '15 august 2019', '5 january 2020');
INSERT INTO ruleaza
VALUES(1140, 120, 310, '15 august 2019', '5 january 2020');
INSERT INTO ruleaza
VALUES(1180, 160, 310, '16 august 2019', '5 january 2020');
INSERT INTO ruleaza
VALUES(1220, 220, 1010, '15 september 2021', '14 february 2022');
INSERT INTO ruleaza
VALUES(1260, 240, 1010, '17 september 2021', '14 february 2022');
INSERT INTO ruleaza
VALUES(1300, 120, 1010, '16 september 2021', '11 february 2022');
INSERT INTO ruleaza
VALUES(1340, 140, 1310, '6 april 2021', '14 november 2021');
INSERT INTO ruleaza
VALUES(1380, 140, 110, '16 december 2021', '14 february 2022');
INSERT INTO ruleaza
VALUES(1420, 160, 210, '6 july 2021', '19 october 2021');
INSERT INTO ruleaza 
VALUES(1460, 120, 810, '7 may 2021', '13 september 2021');
INSERT INTO ruleaza 
VALUES(1500, 120, 1410, '14 february 2017', '18 may 2017');
INSERT INTO ruleaza 
VALUES(1540, 140, 410, '7 december 2017', '12 june 2018');
INSERT INTO ruleaza 
VALUES(1580, 140, 510, '3 june 2022', '2 september 2022');
INSERT INTO ruleaza 
VALUES(1620, 140, 310, '1 january 2020', '15 march 2020');
INSERT INTO ruleaza 
VALUES(1660, 140, 1810, '31 october 2020', '30 december 2020');
INSERT INTO ruleaza 
VALUES(1700, 160, 510, '1 january 2022', '3 march 2022');
INSERT INTO ruleaza 
VALUES(1740, 180, 1110, '14 january 2021', '14 march 2021');
INSERT INTO ruleaza 
VALUES(1780, 180, 610, '21 august 2021', '15 november 2021');
INSERT INTO ruleaza 
VALUES(1820, 180, 1910, '5 july 2017', '15 november 2017');
INSERT INTO ruleaza 
VALUES(1860, 180, 710, '3 june 2021', '3 december 2021');
INSERT INTO ruleaza 
VALUES(1900, 200, 1010, '14 february 2022', '15 may 2022');
INSERT INTO ruleaza 
VALUES(1940, 240, 10, '14 july 2022', '14 august 2022');
INSERT INTO ruleaza 
VALUES(1980, 240, 1910, '4 april 2021', '14 july 2021');

SELECT * FROM ruleaza;

INSERT INTO actor
VALUES(5, 'Zendaya', null, 'SUA', 22, 2009);
INSERT INTO actor
VALUES(10, 'Holland', 'Tom', 'EN', 7, 2008);
INSERT INTO actor
VALUES(15, 'Reynolds', 'Ryan', 'CA', 9, 1991);
INSERT INTO actor
VALUES(20, 'Watson', 'Emma', 'EN', 24, 2001);
INSERT INTO actor
VALUES(25, 'Wolfhard', 'Finn', 'CA', 3, 2017);
INSERT INTO actor
VALUES(30, 'Gadot', 'Gal', 'IL', 3, 2004);
INSERT INTO actor
VALUES(35, 'Downey Jr', 'Robert', 'SUA', 29, 1970);
INSERT INTO actor
VALUES(40, 'Pattinson', 'Robert', 'EN', 30, 2005);

SELECT * FROM actor;

INSERT INTO joaca
VALUES(30, 10, 10, 'principal');
INSERT INTO joaca
VALUES(50, 110, 10, 'principal');
INSERT INTO joaca
VALUES(70, 410, 25, 'principal');
INSERT INTO joaca
VALUES(90, 1610, 25, 'secundar');
INSERT INTO joaca
VALUES(110, 210, 15, 'principal');
INSERT INTO joaca
VALUES(130, 1010, 30, 'principal');
INSERT INTO joaca
VALUES(150, 310, 20, 'principal');
INSERT INTO joaca
VALUES(170, 110, 5, 'principal');
INSERT INTO joaca
VALUES(190, 910, 40, 'principal');
INSERT INTO joaca
VALUES(210, 1710, 30, 'principal');
INSERT INTO joaca
VALUES(230, 1810, 35, 'principal');

SELECT * FROM joaca;

INSERT INTO regizor
VALUES(30, 'Watts', 'Jon', 'SUA', 0);
INSERT INTO regizor
VALUES(50, 'Levy', 'Shawn', 'CA', 0);
INSERT INTO regizor
VALUES(70, 'Reeves', 'Matt', 'SUA', 1);
INSERT INTO regizor
VALUES(90, 'Gerwig', 'Greta', 'SUA', 6);
INSERT INTO regizor
VALUES(110, 'Lucas', 'George', 'SUA', 7);
INSERT INTO regizor
VALUES(130, 'Fleischer', 'Ruben', 'SUA', 0);
INSERT INTO regizor
VALUES(150, 'Muschietti', 'Andy', 'AR', 0);
INSERT INTO regizor
VALUES(170, 'Branagh', 'Kenneth', 'EN', 22);
INSERT INTO regizor
VALUES(190, 'Ritchie', 'Guy', 'EN', 5);
INSERT INTO regizor
VALUES(210, 'Serkis', 'Andy', 'EN', 8);

SELECT * FROM regizor;

INSERT INTO regizeaza
VALUES(1110, 210, 2017);
INSERT INTO regizeaza
VALUES(1110, 130, 2017);
INSERT INTO regizeaza
VALUES(610, 110, 2003);
INSERT INTO regizeaza
VALUES(110, 30, 2020);
INSERT INTO regizeaza
VALUES(210, 50, 2020);
INSERT INTO regizeaza
VALUES(910, 70, 2021);
INSERT INTO regizeaza
VALUES(310, 90, 2017);
INSERT INTO regizeaza
VALUES(10, 130, 2021);
INSERT INTO regizeaza
VALUES(410, 150, 2015);
INSERT INTO regizeaza
VALUES(1610, 150, 2017);
INSERT INTO regizeaza
VALUES(1710, 170, 2020);
INSERT INTO regizeaza
VALUES(1810, 190, 2008);

SELECT * FROM regizeaza;

INSERT INTO difuzare
VALUES(50, 10, 1, 120, '3 april 2022', 19);
INSERT INTO difuzare
VALUES(71, 1210, 7, 120, '9 july 2018', 12);
INSERT INTO difuzare
VALUES(92, 710, 10, 140, '5 august 2021', 15);
INSERT INTO difuzare
VALUES(113, 1510, 37, 260, '19 may 2017', 9);
INSERT INTO difuzare
VALUES(155, 1110, 4, 140, '3 august 2022', 10);
INSERT INTO difuzare
VALUES(176, 1010, 28, 220, '19 december 2021', 11);
INSERT INTO difuzare
VALUES(197, 610, 34, 200, '18 august 2015', 14);
INSERT INTO difuzare
VALUES(218, 410, 22, 200, '15 november 2017', 9);
INSERT INTO difuzare
VALUES(239, 1310, 16, 160, '9 july 2021', 19);
INSERT INTO difuzare
VALUES(260, 1610, 16, 160, '1 december 2019', 22);
INSERT INTO difuzare
VALUES(281, 1010, 25, 240, '18 september 2021', 11);
INSERT INTO difuzare
VALUES(323, 1210, 25, 240, '1 march 2016', 18);
INSERT INTO difuzare
VALUES(344, 910, 28, 220, '3 july 2022', 17);
INSERT INTO difuzare
VALUES(365, 1210, 4, 120, '7 october 2018', 11);
INSERT INTO difuzare
VALUES(386, 710, 7, 200, '27 june 2021', 16);
INSERT INTO difuzare
VALUES(407, 1510, 40, 260, '7 august 2017', 12);
INSERT INTO difuzare
VALUES(428, 1710, 31, 220, '1 september 2022', 13);
INSERT INTO difuzare
VALUES(449, 1310, 10, 140, '6 june 2021', 22);
INSERT INTO difuzare
VALUES(470, 510, 19, 180, '2 february 2022', 19);
INSERT INTO difuzare
VALUES(491, 1210, 19, 180, '2 february 2022', 12);

SELECT * FROM difuzare;

INSERT INTO bilet_cumparat
VALUES(11, 17.1, 17, 3, 50);
INSERT INTO bilet_cumparat
VALUES(16, 22.5, 1, 1, 386);
INSERT INTO bilet_cumparat
VALUES(21, 18.6, 78, 10, 323);
INSERT INTO bilet_cumparat
VALUES(26, 36.9, 22, 5, 491);
INSERT INTO bilet_cumparat
VALUES(31, 0.0, 15, 2, 491);
INSERT INTO bilet_cumparat
VALUES(36, 24.3, 98, 14, 113);
INSERT INTO bilet_cumparat
VALUES(41, 22.5, 56, 4, 176);
INSERT INTO bilet_cumparat
VALUES(46, 40.1, 27, 3, 92);
INSERT INTO bilet_cumparat
VALUES(51, 10.4, 61, 7, 260);
INSERT INTO bilet_cumparat
VALUES(56, 12.2, 15, 3, 407);

SELECT * FROM bilet_cumparat;

COMMIT;

--------------------------------------------------------------EXERCITII (6 - 12)-----------------------------------------------------

--6. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat independent care sa utilizeze 
--doua tipuri diferite de colectii studiate. Apelati subprogramul.

/*
    Pentru fiecare cinematograf din baza de date sa se afiseze un top al 3 celor mai bine cotate filme (criteriul de departajare si
de clasificare in acest top se va face pe baza ratingului) care au rulat in cadrul acestuia. 
    Se vor face afisari corespunzatoare si verificari pentru:
I.     cazul in care un cinematograf nu a rulat cel putin 3 filme pana in prezent
II.    cazul in care un cinematograf nu a rulat cel putin 3 filme DISTINCTE pana in prezent
III.   cazul in care un cinematograf a rulat cel putin 3 filme DISTINCTE pana in prezent, dar nu se poate realiza un top 3 deoarece 
filmele din cadrul acelui cinematograf au au ratinguri comune, ce nu permit departajarea pe cel putin 3 locuri
IV.    cazul in care un cinematograf a rulat cel putin 3 filme DISTINCTE pana in prezent si se poate realiza departajarea acestora 
pe 3 locuri distincte
*/

--PROCEDURA (subprogram stocat), TABEL IMBRICAT ce contine date de tip RECORD, VARRAY, TABEL INDEXAT

CREATE OR REPLACE PROCEDURE proc_proiect_ex6_rs IS
    CURSOR c(parametru cinematograf.cod_cinema%TYPE) IS
            SELECT c.nume_cinema, f.nume_film, f.rating, f.an_aparitie
            FROM film f
            JOIN (SELECT DISTINCT cod_cinema, cod_film
                  FROM ruleaza) r ON r.cod_film = f.cod_film 
            JOIN (SELECT cod_cinema, nume_cinema
                  FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
            WHERE c.cod_cinema = parametru
            ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
            
    TYPE record_CF IS RECORD 
        (poz NUMBER,
         nume_cinema cinematograf.nume_cinema%TYPE,
         nume_film film.nume_film%TYPE,
         rating film.rating%TYPE,
         an_aparitie film.an_aparitie%TYPE); 
         
    TYPE tab_imb_CF IS TABLE OF record_CF;
    t_CF tab_imb_CF := tab_imb_CF();
    
    TYPE varr_cinemaC IS VARRAY(20) OF cinematograf.cod_cinema%TYPE;
    vect_cod_cin varr_cinemaC;
    
    TYPE varr_cinemaN IS VARRAY(20) OF cinematograf.nume_cinema%TYPE;
    vect_num_cin varr_cinemaN;
    
    TYPE tab_ind_cnt IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t_cntFilm tab_ind_cnt;
    
    cnt_FilmDist NUMBER;
    v_prec film.rating%TYPE;
    v_top NUMBER := 1;
    v_cnt NUMBER := 1;
BEGIN 
    SELECT c.cod_cinema, nume_cinema, COUNT(cod_film)
    BULK COLLECT INTO vect_cod_cin, vect_num_cin, t_cntFilm
    FROM cinematograf c, ruleaza r
    WHERE c.cod_cinema = r.cod_cinema(+)
    GROUP BY c.cod_cinema, nume_cinema; 
    
    FOR i IN vect_cod_cin.FIRST..vect_cod_cin.LAST LOOP
        dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
        IF t_cntFilm(i) = 0 THEN
            dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' NU a rulat NICIUN film pana in prezent.');
            dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
        ELSIF t_cntFilm(i) = 1 THEN
            dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' a rulat un singur film pana in prezent.');
            dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
        ELSIF t_cntFilm(i) = 2 THEN
            dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat doar 2 filme pana in prezent.');
            dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
        ELSE
            v_top := 1;
            v_cnt := 1;
            /*
            SELECT COUNT(f.cod_film) INTO cnt_FilmDist
            FROM film f
            JOIN (SELECT DISTINCT cod_cinema, cod_film
                  FROM ruleaza) r ON r.cod_film = f.cod_film 
            JOIN (SELECT cod_cinema, nume_cinema
                  FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
            WHERE c.cod_cinema = vect_cod_cin(i)        
            ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
            */
            
            SELECT COUNT(DISTINCT cod_film) INTO cnt_FilmDist
            FROM ruleaza
            WHERE cod_cinema = vect_cod_cin(i);
            
            IF cnt_FilmDist = 1 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, dar eliminand duplicatele doar un singur film DISTINCT pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
            ELSIF cnt_FilmDist = 2 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, dar dar eliminand duplicatele doar 2 filme DISTINCTE pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
            ELSE
                OPEN c(vect_cod_cin(i));
                t_CF.EXTEND;
                FETCH c INTO t_CF(v_cnt).nume_cinema, t_CF(v_cnt).nume_film, t_CF(v_cnt).rating, t_CF(v_cnt).an_aparitie;
                t_CF(v_cnt).poz := v_top;
                v_prec := t_CF(v_cnt).rating;
                LOOP
                    t_CF.EXTEND;
                    v_cnt := v_cnt + 1;
                    FETCH c INTO t_CF(v_cnt).nume_cinema, t_CF(v_cnt).nume_film, t_CF(v_cnt).rating, t_CF(v_cnt).an_aparitie;
                    EXIT WHEN c%NOTFOUND;
                    IF t_CF(v_cnt).rating <> v_prec THEN
                        v_top := v_top + 1;
                    END IF;
                    EXIT WHEN v_top = 4;
                    t_CF(v_cnt).poz := v_top;
                    v_prec := t_CF(v_cnt).rating;
                END LOOP;
                --IF v_top <> 4 THEN
                IF v_top <> 4 AND v_top <> 3 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, iar eliminand duplicatele ' || cnt_FilmDist || ' filme DISTINCTE, dar ratingurile nu pot determina un top 3 cele mai indragite filme.');
                    dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
                ELSE
                    dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, iar eliminand duplicatele ' || cnt_FilmDist || ' filme DISTINCTE.');
                    dbms_output.put_line('----Top 3 cele mai bine cotate filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '----');
                    v_top := 0;
                    FOR j IN t_CF.FIRST..t_CF.LAST LOOP
                        IF t_CF(j).poz <> v_top THEN
                            v_top := t_CF(j).poz;
                            dbms_output.new_line;
                            dbms_output.put_line('------LOCUL ' || v_top || ' ------');
                            dbms_output.put_line('---Ratingul: ' || t_CF(j).rating|| ' ---');
                        END IF;
                        dbms_output.put_line('Filmul: ' || t_CF(j).nume_film || ', aparut in anul: ' || t_CF(j).an_aparitie);
                    END LOOP;
                END IF;
                t_CF.DELETE;
                CLOSE c;
            END IF;
        END IF;
        dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
        dbms_output.new_line();   
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END proc_proiect_ex6_rs;
/ 

EXECUTE proc_proiect_ex6_rs;

DROP PROCEDURE proc_proiect_ex6_rs;


--7. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat independent care sa utilizeze 2 tipuri 
--diferite de cursoare studiate, unul dintre acestea fiind cursor parametrizat. Apelati subprogramul

/*
    Sa se creeze o procedura care primeste ca parametru un numar ce reprezinta optiunea dorita de utilizator si afiseaza 
informatii coerente, in concordanta cu alegerea introdusa de acesta. Optiunile existente sunt 1 si 2.
    Pentru optiunea 1 se vor lista toate cinematografele existente in baza de date, impreuna cu informatii coerente despre
situatia de angajare din cadrul cinematografului respectiv, ceea ce inseamna ca se vor afisa joburile care au posturi 
ocupate, impreuna cu angajatii care lucreaza pe jobul respectiv, in acel cinematograf sau un mesaj care sa indice faptului ca 
pentru acel cinematograf nu avem inregistrat niciun angajat
    Pentru optiunea 2, se vor lista toate cinematografele existente in baza de date, precizandu-se numarul angajatilor care
lucreaza in prezent in acel cinematograf si numarul angajatilor care au lucrat in trecut in acel cinematograf. De asemenea, 
impreuna cu cinematografele se afiseaza informatii coerente despre situatia de angajare din cadrul cinematografului respectiv,
ceea ce inseamna ca se vor afisa joburile care au posturi ocupate in prezent sau care au fost ocupate in trecut si angajatii 
care lucreaza pe jobul respectiv, in acel cinematograf si/sau care au lucrat in trecut pe jobul respectiv, in acel cinematograf, 
impreuna cu un mesaj care sa precizeze ce fel de angajat este(Actual / Istoric)
    Orice alt numar reprezinta o optiune incorecta
*/

--PROCEDURA (subprogram stocat), EXPRESIE CURSOR IMRICATA, CURSOR EXPLICIT, CURSOR PARAMETRIZAT, CICLU CURSOR, 
--CICLU CURSOR CU SUBCERERI, REF CURSOR

CREATE OR REPLACE PROCEDURE proc_proiect_ex7_rs(optiune NUMBER) IS   
    --expresie cursor imbricata
    CURSOR c_expr
                IS SELECT nume_cinema, CURSOR (SELECT nume_job, CURSOR (SELECT nume || ' ' || prenume
                                                                        FROM angajat a
                                                                        WHERE a.cod_cinema = c.cod_cinema AND j.cod_job = a.cod_job)
                                               FROM job j)
                    FROM cinematograf c;
    v_nume_cinema cinematograf.nume_cinema%TYPE;
    v_nume_job job.nume_job%TYPE;
    v_nume_ang VARCHAR2(70);
    v_nr_ang NUMBER;
    cnt NUMBER;
    TYPE refcursor IS REF CURSOR;
    v_cursor_imbr refcursor;
    v_cursor refcursor;
    
    --cursor explicit
    CURSOR c_expl IS SELECT c.cod_cinema v_cod_cinema, c.nume_cinema v_nume_cinema, COUNT(a.cod_angajat) v_cnt_ang, 
                                                                            (SELECT COUNT(*)
                                                                             FROM  istoric_lucru il
                                                                             WHERE c.cod_cinema = il.cod_cinema(+))v_hist_ang
                    FROM cinematograf c, angajat a
                    WHERE c.cod_cinema = a.cod_cinema(+)
                    GROUP BY c.cod_cinema, c.nume_cinema;
    
    --cursor parametrizat
    CURSOR c_param(param_cin cinematograf.cod_cinema%TYPE, param_job job.nume_job%TYPE) 
        IS SELECT nume || ' ' || prenume
           FROM angajat a, job j
           WHERE cod_cinema = param_cin AND a.cod_job = j.cod_job AND j.nume_job = param_job;
           
    --cursor parametrizat
    CURSOR c_param_hist(param_cin cinematograf.cod_cinema%TYPE, param_job job.nume_job%TYPE) 
        IS SELECT nume || ' ' || prenume
           FROM angajat a, job j, istoric_lucru il
           WHERE il.cod_cinema = param_cin AND il.cod_job = j.cod_job 
                AND j.nume_job = param_job AND il.cod_angajat = a.cod_angajat;
BEGIN
    IF optiune = 1 THEN
        OPEN c_expr;
        LOOP
            FETCH c_expr INTO v_nume_cinema, v_cursor_imbr;
            EXIT WHEN c_expr%NOTFOUND;
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            dbms_output.put_line('Cinematograful ' || UPPER(v_nume_cinema));
            dbms_output.new_line();
            cnt := 0;
            LOOP
                FETCH v_cursor_imbr INTO v_nume_job, v_cursor;
                EXIT WHEN v_cursor_imbr%NOTFOUND;
                
                FETCH v_cursor INTO v_nume_ang;
                IF v_cursor%ROWCOUNT > 0 THEN
                    dbms_output.put_line('---------Jobul ' || UPPER(v_nume_job) || ' ---------');
                    dbms_output.put_line('     Angajatul ' || v_nume_ang);
                    LOOP 
                        FETCH v_cursor INTO v_nume_ang;
                        EXIT WHEN v_cursor%NOTFOUND;
                        dbms_output.put_line('     Angajatul ' || v_nume_ang);
                    END LOOP;
                    dbms_output.new_line();
                END IF;
                IF v_cursor%ROWCOUNT = 0 THEN
                    cnt := cnt + 1;
                END IF;
            END LOOP;
            IF v_cursor_imbr%ROWCOUNT = cnt THEN
                dbms_output.put_line('     NICIUN ANGAJAT ');
                dbms_output.new_line();
            END IF;
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
        END LOOP;
        CLOSE c_expr;
    ELSIF optiune = 2 THEN
        --ciclu cursor
        FOR k IN c_expl LOOP
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            IF k.v_cnt_ang = 0 THEN
                IF k.v_hist_ang = 0 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza si nu a lucrat NICIUN angajat');
                ELSIF k.v_hist_ang = 1 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza in prezent NICIUN angajat, insa in trecut a mai lucrat un singur angajat');
                ELSE
                    dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza in prezent NICIUN angajat, insa in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                END IF;
            ELSE
                IF k.v_cnt_ang = 1 THEN
                    IF k.v_hist_ang = 0 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut nu a mai lucrat NICIUN angajat');
                    ELSIF k.v_hist_ang = 1 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut a mai lucrat un singur angajat');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                    END IF;
                ELSE 
                    IF k.v_hist_ang = 0 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut nu a mai lucrat NICIUN angajat');
                    ELSIF k.v_hist_ang = 1 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut a mai lucrat un singur angajat');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                    END IF;
                END IF;
                --ciclu cursor cu subcereri
                FOR i IN (SELECT nume_job, (SELECT COUNT(a.cod_angajat)
                                            FROM  angajat a
                                            WHERE a.cod_job(+) = j.cod_job 
                                            AND a.cod_cinema = k.v_cod_cinema) nr_ang, 
                                           (SELECT COUNT(il.cod_angajat)
                                            FROM  istoric_lucru il
                                            WHERE j.cod_job = il.cod_job(+) 
                                            AND il.cod_cinema = k.v_cod_cinema) hist_ang
                           FROM job j) LOOP
                    IF i.nr_ang != 0 THEN
                        OPEN c_param(k.v_cod_cinema, i.nume_job);
                        dbms_output.new_line();
                        dbms_output.put_line('---------Jobul ' || UPPER(i.nume_job) || ' ---------');
                        LOOP
                            FETCH c_param INTO v_nume_ang;
                                EXIT WHEN c_param%NOTFOUND;
                                dbms_output.put_line('  (Actual)    Angajatul ' || v_nume_ang);
                            END LOOP;
                        CLOSE c_param;
                        IF i.hist_ang != 0 THEN
                            OPEN c_param_hist(k.v_cod_cinema, i.nume_job);
                            LOOP
                                FETCH c_param_hist INTO v_nume_ang;
                                    EXIT WHEN c_param_hist%NOTFOUND;
                                    dbms_output.put_line('  (Istoric)    Angajatul ' || v_nume_ang);
                            END LOOP;
                            CLOSE c_param_hist;
                        END IF;
                    ELSIF i.hist_ang != 0 THEN
                        OPEN c_param_hist(k.v_cod_cinema, i.nume_job);
                        dbms_output.new_line();
                        dbms_output.put_line('---------Jobul ' || UPPER(i.nume_job) || ' ---------');
                        LOOP
                            FETCH c_param_hist INTO v_nume_ang;
                            EXIT WHEN c_param_hist%NOTFOUND;
                            dbms_output.put_line('  (Istoric)    Angajatul ' || v_nume_ang);
                        END LOOP;
                        CLOSE c_param_hist;
                    END IF;
                END LOOP;
            END IF; 
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            dbms_output.new_line();
        END LOOP;
    ELSE
        dbms_output.put_line('Optiunea nu e valida');
    END IF;
EXCEPTION 
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');       
END proc_proiect_ex7_rs;
/

DECLARE 
    optiune NUMBER := &optiune;
BEGIN
    proc_proiect_ex7_rs(optiune);
END;
/

DROP PROCEDURE proc_proiect_ex7_rs;

--8. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat
--independent de tip functie care sa utilizeze intr-o singura comanda SQL 3 dintre tabelele definite. 
--Definiti minim 2 exceptii. Apelati subprogramul astfel incat sa evidentiati toate cazurile tratate.

/*
    Fiind dat genul unui film si un an sa se afiseze suma preturilor tuturor biletelor cumparate pentru filmele care se incadreaza
in genul respectiv si pe baza carora s-a intrat la difuzari ce au avut ca data de inceput un an mai mare decat anul dat ca parametru
    Se vor trata exceptiile:
I.      anul dat ca parametru este negativ
II.     anul dat ca parametru este mai mare decat cel curent
III.    pentru genul dat ca parametru nu exista filme in baza de date
IV.     nu exista nicio difuzare pentru niciun film cu genul dat ca parametru care sa aiba loc dupa anul dat ca parametru
V.      nu exista niciun bilet cumparat la vreo difuzare ce a avut loc dupa anul dat ca parametru a vreunui film ce are genul dat ca parametru
*/

--JOIN ce include 3 tabele (FILM, DIFUZARE, BILET_CUMPARAT)

CREATE OR REPLACE FUNCTION funct_proiect_ex8_rs(gen IN film.gen_princ%TYPE, an IN CHAR)
        RETURN NUMBER IS
    exc_err_an_neg EXCEPTION;
    exc_err_an EXCEPTION;
    exc_err_gen EXCEPTION;
    exc_err_dif EXCEPTION;
    exc_err_bilet EXCEPTION;
    cnt NUMBER;
    pret NUMBER;
BEGIN
    IF an < 0 THEN 
        RAISE exc_err_an_neg;
    END IF;
    IF an > TO_CHAR(SYSDATE, 'YYYY') THEN 
        RAISE exc_err_an;
    END IF;
    SELECT COUNT(*) INTO cnt
    FROM film
    WHERE UPPER(gen_princ) = UPPER(gen);
    IF cnt = 0 THEN
        RAISE exc_err_gen;
    END IF;
    SELECT COUNT(cod_difuzare) INTO cnt
    FROM film f, difuzare d
    WHERE UPPER(gen_princ) = UPPER(gen) AND f.cod_film = d.cod_film AND TO_CHAR(data_inc, 'YYYY') >= an;
    IF cnt = 0 THEN
        RAISE exc_err_dif;
    END IF;
    --JOIN ce include 3 tabele (FILM, DIFUZARE, BILET_CUMPARAT)
    SELECT SUM(bc.pret) INTO pret
    FROM film f, difuzare d, bilet_cumparat bc
    WHERE UPPER(f.gen_princ) = UPPER(gen) AND f.cod_film = d.cod_film 
         AND bc.cod_difuzare(+) = d.cod_difuzare AND TO_CHAR(d.data_inc, 'YYYY') >= an;
    IF pret is null THEN
        RAISE exc_err_bilet;
    END IF;
    RETURN pret;
EXCEPTION
    WHEN exc_err_an_neg THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nu puteti introduce un an negativ!');
    WHEN exc_err_an THEN
        RAISE_APPLICATION_ERROR(-20004, 'Ati introdus un an mai mare decat anul curent, si nu exista date despre difuzari din viitor!');
    WHEN exc_err_gen THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nu exista niciun film care sa aiba genul ' || UPPER(gen) || '!');
    WHEN exc_err_dif THEN
        RAISE_APPLICATION_ERROR(-20006, 'Nu exista nicio difuzare pentru filme de genul ' || UPPER(gen) || ' care sa fi avut loc dupa anul ' || an || '!');
    WHEN exc_err_bilet THEN
        RAISE_APPLICATION_ERROR(-20007, 'Nu exista niciun bilet vandut la difuzare care a avut loc dupa anul ' || an || ' a vreunui film cu genul ' || UPPER(gen) || '!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END funct_proiect_ex8_rs;
/

--gen = actiune 
--an = 2019
SET SERVEROUTPUT ON
ACCEPT p_gen PROMPT 'Introduceti genul filmului: '
ACCEPT p_an PROMPT 'Introduceti anul: '
DECLARE
    gen film.gen_princ%TYPE := '&p_gen';
    an NUMBER := &p_an;
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs(gen, an);
    dbms_output.put_line('Suma preturilor biletelor cumparate pentru difuzari de dupa anul ' || an || ' ale filmelor ce au genul ' || UPPER(gen) || ' este de:   ' || pret);
END;
/
SET SERVEROUTPUT OFF
--Suma preturilor biletelor cumparate pentru difuzari de dupa anul 2019 ale filmelor ce au genul ACTIUNE este de:   79.7

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Actiune', '2024');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20004: Ati introdus un an mai mare decat anul curent, si nu exista date despre difuzari din viitor!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Teatru', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20005: Nu exista niciun film care sa aiba genul TEATRU!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Romance', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20006: Nu exista nicio difuzare pentru filme de genul ROMANCE care sa fi avut loc dupa anul 2019!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Romance', 'scara');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20002: Alta eroare

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Comedie', '-2022');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20003: Nu puteti introduce un an negativ!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Animatie', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20007: Nu exista niciun bilet vandut la difuzare care a avut loc dupa anul 2019 a vreunui film cu genul ANIMATIE!

DROP FUNCTION funct_proiect_ex8_rs;


--9. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat 
--independent de tip procedura care sa utilizeze intr-o singura comanda SQL 5 dintre tabelele 
--definite. Tratati toate exceptiile care pot aparea, incluzand exceptiile NO_DATA_FOUND si 
--TOO_MANY_ROWS. Apelati subprogramul astfel incat sa evidentiati toate cazurile tratate.

/*
    Sa se implementeze o procedura care primeste ca parametrii un an si un nume de actor. Vrem sa cautam date despre filmele 
care au rulat pe o perioada mai lung? de 4 luni intr-un cinematograf deschis luni sau sambata, tinand cont ca anul rularii 
respective sa fie mai mare decat anul dat ca parametru, si de acesmenea, acel film sa aiba inregistrata o difuzare intr-o sala
de tipul 'vip' sau care contine in numele tipului subsirul 'multi'.
    Sa se modifice structura tabelei FILM astfel incat sa se retina intr-o singura coloana date despre numarul de premii stranse 
de toti actorii din baza de date care au participat la distributia filmului respectiv, numarul acestor actori, numarul de premii
stranse de toti regizorii din baza de date care au participat la distributia filmului respectiv si numarul acestor regizori. In 
aceasta noua coloana se vor numara doar premiile actorilor si numarul actorilor care au anul de debut diferit de anul de debut
preluat de la actorul cu numele sau prenumele dat ca parametru in procedura.
    In cadrul procedurii descrise mai sus, vrem sa afisam detalii despre cinematograf, ziua deschiderii acestuia, detalii despre 
salile in care au avut loc difuzarile filmului curent, numele filmului curent si ratingul acestuia. Folosind coloana aditionala 
din tabela FILM vom calcula o medie dintre numarul de premii castigate de persoanele care fac parte din distributie si numarul 
acestor persoane, aceasta fiind media de premiere a filmului.
    Se vor trata cazurile(exceptiile) in care
I.      anul dat ca parametru este negativ
II.     anul dat ca parametru este mai mare decat cel curent
III.    pentru anul dat ca parametru nu exista cinematografe care sa se fi deschis luni sau sambata
IV.     nu exista niciun actor cu numele dat ca parametru
V.      exista mai multi actori cu numele dat ca parametru
    De asemenea, se vor afisa corespunzator mesaje pentru
I.      cazul in care media de premiere a filmului este 0
    I.1.    si avem date despre mai multi membrii care au participat in distributie
    I.2.    si avem date despre un singur membru care a participat in distributie
    I.3.    si nu avem date despre niciun membru care a participat in distributie
II.    cazul in care media de premiere a filmului este diferita de 0
    II.1.   si avem date despre mai multi membrii care au participat in distributie
    II.2.   si avem date despre un singur membru care a participat in distributie
    II.3.   si nu avem date despre niciun membru care a participat in distributie
*/

--comanda SQL ce include 5 tabele, prin intermediul subcererilor (ACTOR, JOACA, REGIZOR, REGIZEAZA, FILM)

--comanda SQL ce include 5 tabele, prin intermediul JOIN-ului (FILM, RULEAZA, DIFUZARE, CINEMATOGRAF, SALA), 
--la care se adauga prin intermediul subcererilor inca o data tabela FILM si coloana aditionala din tabela FILM preluata ca TABLE


CREATE OR REPLACE TYPE obj IS OBJECT
    (nr_premii NUMBER,
     part NUMBER);
/
CREATE OR REPLACE TYPE tab_imbr IS TABLE OF obj;
/
ALTER TABLE film
ADD (date_membrii tab_imbr) NESTED TABLE date_membrii STORE AS tab_date_membrii;

CREATE OR REPLACE PROCEDURE proc_proiect_ex9_rs(an CHAR, numeA VARCHAR2) IS
    exc_an_neg EXCEPTION;
    exc_an EXCEPTION;
    exc_an_NDF EXCEPTION;
    cnt NUMBER;
    an_deb actor.an_debut%TYPE;
BEGIN
    IF an < 0 THEN 
        RAISE exc_an_neg;
    END IF;
    IF an > TO_CHAR(SYSDATE, 'YYYY') THEN 
        RAISE exc_an;
    END IF;
    
    SELECT COUNT(*) INTO cnt
    FROM cinematograf
    WHERE to_char(data_desch, 'YYYY') >= an AND (UPPER(to_char(data_desch, 'DAY')) LIKE '%MONDAY%' 
                OR UPPER(to_char(data_desch, 'DAY')) LIKE '%SATURDAY%');
    IF cnt = 0 THEN
        RAISE exc_an_NDF;
    END IF;
    
    SELECT an_debut INTO an_deb
    FROM actor
    WHERE (LOWER(prenume) LIKE LOWER(numeA) OR LOWER(nume) LIKE LOWER(numeA));
    
    --comanda SQL ce include 5 tabele, prin intermediul subcererilor (ACTOR, JOACA, REGIZOR, REGIZEAZA, FILM)
    FOR i IN (SELECT f.cod_film cod, NVL((SELECT SUM(nr_premii)
                                          FROM actor a, joaca j
                                          WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film
                                                AND a.an_debut <> an_deb), 0) premii_act,
                                NVL((SELECT COUNT(a.id_actor)
                                 FROM actor a, joaca j
                                 WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film
                                       AND a.an_debut <> an_deb), 0) nr_act,
                            NVL((SELECT SUM(nr_premii)
                                 FROM regizor r, regizeaza ra
                                 WHERE r.id_regizor = ra.id_regizor AND ra.cod_film = f.cod_film), 0) premii_reg,
                        NVL((SELECT COUNT(nr_premii)
                         FROM regizor r, regizeaza ra
                         WHERE r.id_regizor = ra.id_regizor AND ra.cod_film = f.cod_film), 0) nr_reg
                FROM film f) LOOP
         UPDATE film
         SET date_membrii = tab_imbr( obj(i.premii_act, i.nr_act), obj(i.premii_reg, i.nr_reg))
         WHERE cod_film = i.cod;
    END LOOP;
    
    --comanda SQL ce include 5 tabele, prin intermediul JOIN-ului (FILM, RULEAZA, DIFUZARE,   CINEMATOGRAF, SALA), la care se 
    --adauga prin intermediul subcererilor inca o data tabela FILM si coloana aditionala din tabela film preluata ca TABLE
    FOR i IN (SELECT c.nume_cinema numeC, to_char(data_desch, 'DAY') zi,  f.nume_film numeF, d.nr_sala salaD, 
                s.tip salaT, f.rating ratingF,
                    (SELECT SUM(b.part)
                     FROM film a, TABLE (a.date_membrii) b
                     WHERE a.cod_film = f.cod_film) nr_part,
                    (SELECT SUM(b.nr_premii)
                     FROM film a, TABLE (a.date_membrii) b
                     WHERE a.cod_film = f.cod_film) nr_premii,
                    (SELECT nvl(SUM(b.nr_premii)/ NULLIF(SUM(b.part), 0), 0) 
                     FROM film a, TABLE (a.date_membrii) b
                     WHERE a.cod_film = f.cod_film) medie_premii      
                FROM film f, ruleaza r, difuzare d, cinematograf c, sala s
                WHERE c.cod_cinema = r.cod_cinema AND r.cod_film = f.cod_film
                   AND (UPPER(to_char(data_desch, 'DAY')) LIKE '%MONDAY%' OR UPPER(to_char(data_desch, 'DAY')) LIKE '%SATURDAY%')
                   AND to_char(data_desch, 'YYYY') >= an
                   AND f.cod_film = d.cod_film 
                   AND d.nr_sala = s.nr_sala AND s.cod_cinema = c.cod_cinema
                   AND (LOWER(s.tip) LIKE '%multi%' OR LOWER(s.tip) LIKE 'vip')
                   AND months_between(r.data_final, r.data_inceput) > 4
               ORDER BY 7 DESC, 6 DESC, 5 DESC, 4 DESC) LOOP
        IF UPPER(i.zi) LIKE '%SATURDAY%' THEN
            i.zi := 'SAMBATA';
        ELSE 
            i.zi := 'LUNI';
        END IF;
        dbms_output.new_line();
        IF i.medie_premii = 0 THEN
            IF i.nr_part = 1  THEN
                dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membriu in productie, iar acesta nu a castigat NICIUN premiu');
            ELSIF i.nr_part > 0 THEN
                dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part || ' membrii in productie, iar acestia nu a castigat NICIUN premiu');
            ELSE 
                dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                dbms_output.put_line('Pentru acest film nu s-au putut colectiona date despre actori sau regizori');
            END IF;
        ELSE
            IF i.nr_premii = 1 THEN
                IF i.nr_part = 1 THEN
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membru in productie, iar acesta a castigat in total un singur premiu');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                ELSE
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part 
                                    || ' membrii in productie, iar acestia au castigat in total un singur premiu');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                END IF;
            ELSE
                IF i.nr_part = 1 THEN
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membru in productie, iar acesta a castigat in total ' || i.nr_premii || ' premii');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                ELSE
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part || ' membrii in productie, iar acestia au castigat in total ' || i.nr_premii || ' premii');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                END IF;
            END IF;
        END IF;
    END LOOP;        
EXCEPTION
    WHEN exc_an_neg THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nu puteti introduce un an negativ!');
    WHEN exc_an THEN
        RAISE_APPLICATION_ERROR(-20004, 'Ati introdus un an mai mare decat anul curent, si nu exista date despre cinematografe deschise in viitor!');
    WHEN exc_an_NDF THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nu exista niciun cinematograf deschis luni sau sambata, dupa anul ' || an || '!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Nu exista niciun actor cu numele sau prenumele ' || UPPER(numeA) || '!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20007, 'Exista mai muti actori cu numele sau prenumele ' || UPPER(numeA) || '!');
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20008, 'Alta eroare!');
END proc_proiect_ex9_rs;
/

EXECUTE proc_proiect_ex9_rs('2000', 'Ryan');
--afisare

SELECT * FROM FILM;

EXECUTE proc_proiect_ex9_rs('-10', 'Zendaya');
--ORA-20003: Nu puteti introduce un an negativ!

EXECUTE proc_proiect_ex9_rs('2033', 'Zendaya');
--ORA-20004: Ati introdus un an mai mare decat anul curent, si nu exista date despre cinematografe deschise in viitor!

EXECUTE proc_proiect_ex9_rs('2000', 'Gigi');
--ORA-20006: Nu exista niciun actor cu numele sau prenumele GIGI!

EXECUTE proc_proiect_ex9_rs('2000', 'Robert');
--ORA-20007: Exista mai muti actori cu numele sau prenumele ROBERT!

EXECUTE proc_proiect_ex9_rs('scara', 'Ryan');
--ORA-20008: Alta eroare!

ALTER TABLE film
DROP COLUMN date_membrii;

DROP TYPE tab_imbr;
DROP TYPE obj;

DROP PROCEDURE proc_proiect_ex9_rs;


--10. Definiti un trigger de tip LMD la nivel de comanda. Declansati trigger-ul.

/*
    Vrem sa definim un declansator care sa verifice anumite proprietati inainte de orice tip de inserare in tabela ACTOR. 
Trebuie sa verificam daca toti actorii care se afla momentan stocati in baza de date sunt inregistrati ca jucand in cel putin un 
film, daca datele despre anul de debut ale fiecarui actor sunt corecte, in concordanta cu filmele in care acesta a jucat 
(anul de debut sa nu fie mai tarziu decat cel de aparitie al filmului in care joaca) si ca datele despre numarul de premii obtinute
de fiecare actor sa fie coerente in raport cu anul de debut (50% din numarul de premii sa nu fie mai mare decat anul actual - anul de debut * 100)
*/

CREATE OR REPLACE TRIGGER trig_proiect_ex10_rs
    BEFORE INSERT ON actor
DECLARE
    cnt NUMBER;
BEGIN
    FOR i IN (SELECT COUNT(j.id_actor) cnt
              FROM actor a, joaca j
              WHERE a.id_actor = j.id_actor(+)
              GROUP BY a.id_actor) LOOP
        IF i.cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nu puteti introduce un nou actor pana cand nu aveti date despre cel putin o aparitie intr-un film pentru fiecare actor din baza de date!');
        END IF;
    END LOOP;
    
    SELECT COUNT(a.id_actor) INTO cnt
    FROM actor a, joaca j, film f
    WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film 
          AND an_debut > an_aparitie;
    IF cnt <> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la anul de debut al unui actor sau filmele in care acesta a jucat!');
    END IF;
    
    SELECT COUNT(id_actor) INTO cnt
    FROM actor
    WHERE (to_char(SYSDATE, 'YYYY') - an_debut) * 100 < nr_premii * 0.5 ;
    IF cnt <> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la numarul de premii sau anul de debut al unui actor!');
    END IF;
END trig_proiect_ex10_rs;
/

INSERT INTO actor 
VALUES(1, 'ana', 'lugojana', 'RO', 220, 2022);
--1 row inserted

INSERT INTO actor 
VALUES(2, 'ana', 'blandiana', 'RO', 2, 2017);
--Error report -
--ORA-20002: Nu puteti introduce un nou actor pana cand nu aveti date despre cel putin o aparitie intr-un film pentru fiecare actor din baza de date!
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 9
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 9
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_PROIECT_EX10_RS'

INSERT INTO joaca
VALUES(1, 910, 1, 'principal');
--1 row inserted

INSERT INTO actor 
VALUES(2, 'ana', 'blandiana', 'RO', 2, 2017);
--Error report -
--ORA-20002: Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la numarul de premii sau anul de debut al unui actor!
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 25
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_PROIECT_EX10_RS'

ROLLBACK;

INSERT INTO actor 
VALUES(1, 'ana', 'lugojana', 'RO', 2, 2020);
--1 row inserted

INSERT INTO joaca
VALUES(1, 1810, 1, 'principal');
--1 row inserted

INSERT INTO actor 
VALUES(2, 'ana', 'blandiana', 'RO', 2, 2017);
--Error report -
--ORA-20002: Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la anul de debut al unui actor sau filmele in care acesta a jucat!
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 18
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_PROIECT_EX10_RS'

DROP TRIGGER trig_proiect_ex10_rs;


--11. Definiti un trigger de tip LMD la nivel de linie. Declansati trigger-ul.

/*
    Vrem sa definim un declansator care sa verifice anumite proprietati la nivel de linie inainte de o inserare, stergere 
sau updatare a unui camp ce apartine coloanei "cod_cinema", "cod_job" sau "id_superior" in tabela ANGAJAT.
    Inainte de a insera o noua persoana in tabela ANGAJAT in cazul in care dorim sa punem noua persoana pe postul de manager trebuie 
sa ne asiguram ca nu mai exista un alt manager in acel cinematograf, de asemenea, trebuie sa avem grija ca id-ul superiorului sa se
regaseasca in acelasi cinematograf ca cel ales pentru noul angajat si salariul atribuit sa se incadreze in intervalul determinat de job.
    Inainte de a sterge o valoare din tabela ANGAJAT trebuie sa updatam coloana "id_superior"  pentru subalternii sai deoarece este 
cheie externa care referentiaza o valoare din tabela ANGAJAT.
    Inainte de a updata una din liniile tabelei ANGAJAT, pentru una din coloanele precizate, trebuie sa verificam daca in 
cinematograful in care dorim sa il mutam, sau in vechiul cinematograf (depinde de coloanele asupra carora facem update), in cazul 
in care pe acel angajat dorim sa il punem pe postul de manager sau a posedat postul de manager (depinde de coloanele asupra carora 
facem update) sa nu fie mai multi manageri, de asemenea, trebuie sa avem grija ca id-ul superiorului sa se regaseasca in acelasi 
cinematograf ca cel in care se afla sau se va afla angajatul actualizat (depinde de coloanele asupra carora facem update).
    De asemenea, dupa update sau delete vrem sa modificam datele din tabela ISTORIC_LUCRU si coloana "id_superior" pentru subalternii 
angajatului curent, in functie de cazurile determinate de coloanele asupra carora facem update. In plus, pentru update trebuie 
modificate (daca este cazul) data de angajare si salariul, iar aceasta modificare se produce prin intermediul trigger-ului declarat.
*/

CREATE OR REPLACE TRIGGER trig_before_proiect_ex11_rs
    BEFORE INSERT OR DELETE OR UPDATE OF cod_cinema, cod_job, id_superior ON angajat
    FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
    cnt NUMBER;
    sal_min NUMBER;
    sal_max NUMBER;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_cinema = :NEW.cod_cinema
              AND cod_job LIKE :NEW.cod_job;
        IF :NEW.cod_job LIKE ('%MAN%') THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful dorit!');
            END IF;
        END IF;
        
        IF :NEW.id_superior IS NOT null THEN
            SELECT COUNT(*) INTO cnt
            FROM angajat
            WHERE cod_cinema = :NEW.cod_cinema AND cod_angajat = :NEW.id_superior;
            IF cnt = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
            END IF;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM job
        WHERE cod_job LIKE :NEW.cod_job;
        IF cnt <> 0 THEN
            SELECT salariu_min, salariu_max INTO sal_min, sal_max
            FROM job
            WHERE cod_job LIKE :NEW.cod_job;
            IF sal_min > :NEW.salariu THEN
                RAISE_APPLICATION_ERROR(-20002, 'Salariul este mai mic decat cel minim pentru jobul ales!');
            ELSIF sal_max < :NEW.salariu THEN
                RAISE_APPLICATION_ERROR(-20002, 'Salariul este mai mare decat cel maxim pentru jobul ales!');
            END IF;
        END IF;
    ELSIF DELETING THEN
        UPDATE angajat
        SET id_superior = :OLD.id_superior
        WHERE id_superior = :OLD.cod_angajat;
    ELSIF UPDATING('cod_cinema') AND UPDATING('cod_job') THEN
    	IF UPDATING('id_superior') THEN
            IF :NEW.id_superior IS NOT null THEN
                SELECT COUNT(*) INTO cnt
                FROM angajat
                WHERE cod_cinema = :NEW.cod_cinema AND cod_angajat = :NEW.id_superior;
                IF cnt = 0 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
                END IF;
            END IF;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_job = :NEW.cod_job AND cod_cinema = :NEW.cod_cinema;
        IF :NEW.cod_job = 'MAN' THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful dorit!');
            END IF;
        END IF;
    ELSIF UPDATING('cod_cinema') THEN
    	IF UPDATING('id_superior') THEN
            IF :NEW.id_superior IS NOT null THEN
                SELECT COUNT(*) INTO cnt
                FROM angajat
                WHERE cod_cinema = :NEW.cod_cinema AND cod_angajat = :NEW.id_superior;
                IF cnt = 0 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
                END IF;
            END IF;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_job = :OLD.cod_job AND cod_cinema = :NEW.cod_cinema;
        IF :OLD.cod_job = 'MAN' THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful dorit!');
            END IF;
        END IF;
	ELSIF UPDATING('cod_job') THEN
        IF UPDATING('id_superior') THEN
            IF :NEW.id_superior IS NOT null THEN
                SELECT COUNT(*) INTO cnt
                FROM angajat
                WHERE cod_cinema = :OLD.cod_cinema AND cod_angajat = :NEW.id_superior;
                IF cnt = 0 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
                END IF;
            END IF;
        END IF;
                
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_job = :NEW.cod_job AND cod_cinema = :OLD.cod_cinema;
        IF :OLD.cod_job = 'MAN' THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful curent!');
            END IF;
        END IF;
    ELSIF UPDATING('id_superior') THEN
        IF :NEW.id_superior IS NOT null THEN
            SELECT COUNT(*) INTO cnt
            FROM angajat
            WHERE cod_cinema = :OLD.cod_cinema AND cod_angajat = :NEW.id_superior;
            IF cnt = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
            END IF;
        END IF;
    END IF;
    COMMIT;
END trig_before_proiect_ex11_rs;
/

CREATE OR REPLACE TRIGGER trig_after_proiect_ex11_rs
    FOR DELETE OR UPDATE OF cod_cinema, cod_job, id_superior ON angajat
    COMPOUND TRIGGER
        TYPE rec_upd IS RECORD
            (id_ang angajat.cod_angajat%TYPE,
             id_sup angajat.id_superior%TYPE,
             v_cin angajat.cod_cinema%TYPE,
             n_cin angajat.cod_cinema%TYPE,
             v_job angajat.cod_job%TYPE,
             n_job angajat.cod_job%TYPE,
             d_ang angajat.data_ang%TYPE,
             v_sal angajat.salariu%TYPE,
             flag NUMBER);
        TYPE tab_idx_upd IS TABLE OF rec_upd INDEX BY PLS_INTEGER;  
        t_upd tab_idx_upd;
        
        TYPE tab_idx_del IS TABLE OF angajat.cod_angajat%TYPE INDEX BY PLS_INTEGER;  
        t_del tab_idx_del;
        poz NUMBER;
        sal_max NUMBER;
        sal_min NUMBER;
    AFTER EACH ROW IS
    BEGIN
        IF DELETING THEN
            poz := t_del.COUNT + 1;
            t_del(poz) := :OLD.cod_angajat; 
        ELSIF UPDATING('cod_cinema') AND UPDATING('cod_job') THEN
            poz := t_upd.COUNT + 1;
            t_upd(poz).id_ang := :OLD.cod_angajat; 
            t_upd(poz).id_sup := :OLD.id_superior; 
            t_upd(poz).v_cin := :OLD.cod_cinema; 
            t_upd(poz).d_ang := :OLD.data_ang; 
            t_upd(poz).n_cin := :NEW.cod_cinema;
            t_upd(poz).v_job := :OLD.cod_job;
            t_upd(poz).n_job := :NEW.cod_job;
            t_upd(poz).flag := 0;
            t_upd(poz).v_sal := :OLD.salariu;
            IF UPDATING('id_superior') THEN
                t_upd(poz).flag := 1;
            END IF;
        ELSIF UPDATING('cod_cinema')THEN
            poz := t_upd.COUNT + 1;
            t_upd(poz).id_ang := :OLD.cod_angajat; 
            t_upd(poz).id_sup := :OLD.id_superior; 
            t_upd(poz).v_cin := :OLD.cod_cinema; 
            t_upd(poz).d_ang := :OLD.data_ang; 
            t_upd(poz).n_cin := :NEW.cod_cinema;
            t_upd(poz).v_job := :OLD.cod_job;
            t_upd(poz).v_sal := :OLD.salariu;
            t_upd(poz).flag := 0;
            t_upd(poz).n_job := :OLD.cod_job;
            IF UPDATING('id_superior') THEN
                t_upd(poz).flag := 1;
            END IF;
        ELSIF UPDATING('cod_job') THEN
            poz := t_upd.COUNT + 1;
            t_upd(poz).id_ang := :OLD.cod_angajat; 
            t_upd(poz).id_sup := :OLD.id_superior; 
            t_upd(poz).v_cin := :OLD.cod_cinema; 
            t_upd(poz).d_ang := :OLD.data_ang; 
            t_upd(poz).n_cin := :OLD.cod_cinema;
            t_upd(poz).v_job := :OLD.cod_job;
            t_upd(poz).v_sal := :OLD.salariu;
            t_upd(poz).n_job := :NEW.cod_job;
            t_upd(poz).flag := 1;
        END IF;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1..t_del.COUNT LOOP            
            DELETE FROM istoric_lucru
            WHERE cod_angajat = t_del(i);
        END LOOP;
        FOR i IN 1..t_upd.COUNT LOOP
            IF t_upd(i).v_cin <> t_upd(i).n_cin THEN
                UPDATE angajat
                SET id_superior = t_upd(i).id_sup
                WHERE id_superior = t_upd(i).id_ang;
                IF t_upd(i).flag = 0 THEN    
                    UPDATE angajat
                    SET id_superior = null
                    WHERE cod_angajat = t_upd(i).id_ang;
                END IF;
            END IF;     
            
            INSERT INTO istoric_lucru 
            VALUES(t_upd(i).id_ang, t_upd(i).d_ang, SYSDATE, t_upd(i).v_cin, t_upd(i).v_job);
                
            UPDATE angajat
            SET data_ang = SYSDATE
            WHERE cod_angajat = t_upd(i).id_ang;   
            
            IF t_upd(i).v_job NOT LIKE t_upd(i).n_job THEN
                SELECT salariu_max, salariu_min INTO sal_max, sal_min
                FROM job
                WHERE cod_job LIKE t_upd(i).n_job;
                
                IF sal_max < t_upd(i).v_sal THEN
                    UPDATE angajat
                    SET salariu = sal_max
                    WHERE cod_angajat = t_upd(i).id_ang;
                ELSIF sal_min > t_upd(i).v_sal THEN
                    UPDATE angajat
                    SET salariu = sal_min
                    WHERE cod_angajat = t_upd(i).id_ang;
                END IF;
            END IF;
        END LOOP;  
    END AFTER STATEMENT;
END trig_after_proiect_ex11_rs;
/

INSERT INTO angajat
VALUES (1, 'ana', 'blandiana', 'ana.bland@gmail', null, sysdate, 59827, 8, null, 120, 'MAN');
--Error report -
--ORA-20002: Exista deja un manager in cinematograful dorit!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 14
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

INSERT INTO angajat
VALUES (1, 'ana', 'blandiana', 'ana.bland@gmail', null, sysdate, 59827, 8, null, 120, 'AG_C');
--Error report -
--ORA-20002: Salariul este mai mare decat cel maxim pentru jobul ales!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 37
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

UPDATE angajat
SET cod_cinema = 140
WHERE cod_angajat = 1000;
--Error report -
--ORA-20002: Exista deja un manager in cinematograful dorit!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 81
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

UPDATE angajat
SET cod_job = 'BAR'
WHERE cod_angajat = 1000;
--1 row updated
--1 row inserted into istoric_lucru
--nu modifica id_superior pt subalternii sai 

SELECT * FROM istoric_lucru;

DELETE FROM angajat
WHERE cod_angajat = 1000;
--1 row deleted
--sterge din istoric si modifica id_duperior pt subalternii sai

SELECT * FROM istoric_lucru;

UPDATE angajat
SET cod_cinema = 200, cod_job = 'PLAS', id_superior = 1170
WHERE cod_angajat = 1272;
--1 row updated
--modificari in lant

SELECT * FROM istoric_lucru;
SELECT * FROM angajat;

UPDATE angajat
SET cod_cinema = 200, cod_job = 'PLAS', id_superior = 1000
WHERE cod_angajat = 1272;
--Error report -
--ORA-20002: Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 51
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

DROP TRIGGER trig_before_proiect_ex11_rs;
DROP TRIGGER trig_after_proiect_ex11_rs;

ROLLBACK;


--12. Definiti un trigger de tip LDD. Declansati trigger-ul.

/*
    Vrem sa creem un tabel de istoric actiuni din baza de date, in care vom introduce date corespunzatoare folosindu-ne de un trigger de tip LDD.
*/

CREATE TABLE istoric_actiuni_bd
    (nume_bd VARCHAR2(50),
     user_logat VARCHAR2(30),
     eveniment VARCHAR2(20),
     tip_obiect_referit VARCHAR2(30),
     nume_obiect_referit VARCHAR2(30),
     data TIMESTAMP(3));

CREATE OR REPLACE TRIGGER trig_proiect_ex12_rs
    AFTER ALTER OR DROP OR CREATE ON SCHEMA
BEGIN
    INSERT INTO istoric_actiuni_bd
    VALUES (SYS.DATABASE_NAME, SYS.LOGIN_USER, 
            SYS.SYSEVENT, SYS.DICTIONARY_OBJ_TYPE, 
            SYS.DICTIONARY_OBJ_NAME, SYSTIMESTAMP(3));
END trig_proiect_ex12_rs;
/

SELECT * FROM ISTORIC_ACTIUNI_BD;

DROP TRIGGER trig_proiect_ex12_rs;

--------------------------------------------------------------EXERCITII (13 - 14)-----------------------------------------------------

--13. Definiti un pachet care sa contina toate obiectele definite in cadrul proiectului

---Pachet auxiliar ---> SQL dinamic pentru ALTER table, create OBJECT si create TABLE of OBJECT
CREATE OR REPLACE PACKAGE pach_aux AS
    PROCEDURE altering_film;
    PROCEDURE dropping;
END pach_aux;
/

CREATE OR REPLACE PACKAGE BODY pach_aux AS
    PROCEDURE altering_film IS
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE obj IS OBJECT(nr_premii NUMBER,part NUMBER);';
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE tab_imbr IS TABLE OF obj;';
        EXECUTE IMMEDIATE 'ALTER TABLE film ADD (date_membrii tab_imbr) NESTED TABLE date_membrii STORE AS tab_date_membrii';
    END altering_film;
    
    PROCEDURE dropping IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE film DROP COLUMN date_membrii';
        EXECUTE IMMEDIATE 'DROP TYPE tab_imbr';
        EXECUTE IMMEDIATE 'DROP TYPE obj';
    END dropping;
END pach_aux;
/

EXECUTE pach_aux.altering_film;

--Pachet propriu-ziu
CREATE OR REPLACE PACKAGE pachet_proiect_ex13_rs AS
    PROCEDURE proc_proiect_ex6_rs;
    
    PROCEDURE proc_proiect_ex7_rs(optiune NUMBER);
    
    FUNCTION funct_proiect_ex8_rs(gen IN film.gen_princ%TYPE, an IN CHAR) RETURN NUMBER;
    
    PROCEDURE proc_proiect_ex9_rs(an CHAR, numeA VARCHAR2);
       
END pachet_proiect_ex13_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet_proiect_ex13_rs AS
    PROCEDURE proc_proiect_ex6_rs IS
        CURSOR c(parametru cinematograf.cod_cinema%TYPE) IS
                SELECT c.nume_cinema, f.nume_film, f.rating, f.an_aparitie
                FROM film f
                JOIN (SELECT DISTINCT cod_cinema, cod_film
                      FROM ruleaza) r ON r.cod_film = f.cod_film 
                JOIN (SELECT cod_cinema, nume_cinema
                      FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
                WHERE c.cod_cinema = parametru
                ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
                
        TYPE record_CF IS RECORD 
            (poz NUMBER,
             nume_cinema cinematograf.nume_cinema%TYPE,
             nume_film film.nume_film%TYPE,
             rating film.rating%TYPE,
             an_aparitie film.an_aparitie%TYPE); 
             
        TYPE tab_imb_CF IS TABLE OF record_CF;
        t_CF tab_imb_CF := tab_imb_CF();
        
        TYPE varr_cinemaC IS VARRAY(20) OF cinematograf.cod_cinema%TYPE;
        vect_cod_cin varr_cinemaC;
        
        TYPE varr_cinemaN IS VARRAY(20) OF cinematograf.nume_cinema%TYPE;
        vect_num_cin varr_cinemaN;
        
        TYPE tab_ind_cnt IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        t_cntFilm tab_ind_cnt;
        
        cnt_FilmDist NUMBER;
        v_prec film.rating%TYPE;
        v_top NUMBER := 1;
        v_cnt NUMBER := 1;
    BEGIN 
        SELECT c.cod_cinema, nume_cinema, COUNT(cod_film)
        BULK COLLECT INTO vect_cod_cin, vect_num_cin, t_cntFilm
        FROM cinematograf c, ruleaza r
        WHERE c.cod_cinema = r.cod_cinema(+)
        GROUP BY c.cod_cinema, nume_cinema; 
        
        FOR i IN vect_cod_cin.FIRST..vect_cod_cin.LAST LOOP
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            IF t_cntFilm(i) = 0 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' NU a rulat NICIUN film pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
            ELSIF t_cntFilm(i) = 1 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' a rulat un singur film pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
            ELSIF t_cntFilm(i) = 2 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat doar 2 filme pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
            ELSE
                v_top := 1;
                v_cnt := 1;
                SELECT COUNT(f.cod_film) INTO cnt_FilmDist
                FROM film f
                JOIN (SELECT DISTINCT cod_cinema, cod_film
                      FROM ruleaza) r ON r.cod_film = f.cod_film 
                JOIN (SELECT cod_cinema, nume_cinema
                      FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
                WHERE c.cod_cinema = vect_cod_cin(i)
                ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
                IF cnt_FilmDist = 1 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, dar eliminand duplicatele doar un singur film DISTINCT pana in prezent.');
                    dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
                ELSIF cnt_FilmDist = 2 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, dar dar eliminand duplicatele doar 2 filme DISTINCTE pana in prezent.');
                    dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
                ELSE
                    OPEN c(vect_cod_cin(i));
                    t_CF.EXTEND;
                    FETCH c INTO t_CF(v_cnt).nume_cinema, t_CF(v_cnt).nume_film, t_CF(v_cnt).rating, t_CF(v_cnt).an_aparitie;
                    t_CF(v_cnt).poz := v_top;
                    v_prec := t_CF(v_cnt).rating;
                    LOOP
                        t_CF.EXTEND;
                        v_cnt := v_cnt + 1;
                        FETCH c INTO t_CF(v_cnt).nume_cinema, t_CF(v_cnt).nume_film, t_CF(v_cnt).rating, t_CF(v_cnt).an_aparitie;
                        EXIT WHEN c%NOTFOUND;
                        IF t_CF(v_cnt).rating <> v_prec THEN
                            v_top := v_top + 1;
                        END IF;
                        EXIT WHEN v_top = 4;
                        t_CF(v_cnt).poz := v_top;
                        v_prec := t_CF(v_cnt).rating;
                    END LOOP;
                    IF v_top <> 4 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, iar eliminand duplicatele ' || cnt_FilmDist || ' filme DISTINCTE, dar ratingurile nu pot determina un top 3 cele mai indragite filme.');
                        dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, iar eliminand duplicatele ' || cnt_FilmDist || ' filme DISTINCTE.');
                        dbms_output.put_line('----Top 3 cele mai bine cotate filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '----');
                        v_top := 0;
                        FOR j IN t_CF.FIRST..t_CF.LAST LOOP
                            IF t_CF(j).poz <> v_top THEN
                                v_top := t_CF(j).poz;
                                dbms_output.new_line;
                                dbms_output.put_line('------LOCUL ' || v_top || ' ------');
                                dbms_output.put_line('---Ratingul: ' || t_CF(j).rating|| ' ---');
                            END IF;
                            dbms_output.put_line('Filmul: ' || t_CF(j).nume_film || ', aparut in anul: ' || t_CF(j).an_aparitie);
                        END LOOP;
                    END IF;
                    t_CF.DELETE;
                    CLOSE c;
                END IF;
            END IF;
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            dbms_output.new_line();   
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
    END proc_proiect_ex6_rs;
    
    PROCEDURE proc_proiect_ex7_rs(optiune NUMBER) IS   
        --expresie cursor imbricata
        CURSOR c_expr
                    IS SELECT nume_cinema, CURSOR (SELECT nume_job, CURSOR (SELECT nume || ' ' || prenume
                                                                            FROM angajat a
                                                                            WHERE a.cod_cinema = c.cod_cinema AND j.cod_job = a.cod_job)
                                                   FROM job j)
                        FROM cinematograf c;
        v_nume_cinema cinematograf.nume_cinema%TYPE;
        v_nume_job job.nume_job%TYPE;
        v_nume_ang VARCHAR2(70);
        v_nr_ang NUMBER;
        cnt NUMBER;
        TYPE refcursor IS REF CURSOR;
        v_cursor_imbr refcursor;
        v_cursor refcursor;
        
        --cursor explicit
        CURSOR c_expl IS SELECT c.cod_cinema v_cod_cinema, c.nume_cinema v_nume_cinema, COUNT(a.cod_angajat) v_cnt_ang, 
                                                                                (SELECT COUNT(*)
                                                                                 FROM  istoric_lucru il
                                                                                 WHERE c.cod_cinema = il.cod_cinema(+))v_hist_ang
                        FROM cinematograf c, angajat a
                        WHERE c.cod_cinema = a.cod_cinema(+)
                        GROUP BY c.cod_cinema, c.nume_cinema;
        
        --cursor parametrizat
        CURSOR c_param(param_cin cinematograf.cod_cinema%TYPE, param_job job.nume_job%TYPE) 
            IS SELECT nume || ' ' || prenume
               FROM angajat a, job j
               WHERE cod_cinema = param_cin AND a.cod_job = j.cod_job AND j.nume_job = param_job;
               
        --cursor parametrizat
        CURSOR c_param_hist(param_cin cinematograf.cod_cinema%TYPE, param_job job.nume_job%TYPE) 
            IS SELECT nume || ' ' || prenume
               FROM angajat a, job j, istoric_lucru il
               WHERE il.cod_cinema = param_cin AND il.cod_job = j.cod_job 
                    AND j.nume_job = param_job AND il.cod_angajat = a.cod_angajat;
    BEGIN
        IF optiune = 1 THEN
            OPEN c_expr;
            LOOP
                FETCH c_expr INTO v_nume_cinema, v_cursor_imbr;
                EXIT WHEN c_expr%NOTFOUND;
                dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
                dbms_output.put_line('Cinematograful ' || UPPER(v_nume_cinema));
                dbms_output.new_line();
                cnt := 0;
                LOOP
                    FETCH v_cursor_imbr INTO v_nume_job, v_cursor;
                    EXIT WHEN v_cursor_imbr%NOTFOUND;
                    
                    FETCH v_cursor INTO v_nume_ang;
                    IF v_cursor%ROWCOUNT > 0 THEN
                        dbms_output.put_line('---------Jobul ' || UPPER(v_nume_job) || ' ---------');
                        dbms_output.put_line('     Angajatul ' || v_nume_ang);
                        LOOP 
                            FETCH v_cursor INTO v_nume_ang;
                            EXIT WHEN v_cursor%NOTFOUND;
                            dbms_output.put_line('     Angajatul ' || v_nume_ang);
                        END LOOP;
                        dbms_output.new_line();
                    END IF;
                    IF v_cursor%ROWCOUNT = 0 THEN
                        cnt := cnt + 1;
                    END IF;
                END LOOP;
                IF v_cursor_imbr%ROWCOUNT = cnt THEN
                    dbms_output.put_line('     NICIUN ANGAJAT ');
                    dbms_output.new_line();
                END IF;
                dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            END LOOP;
            CLOSE c_expr;
        ELSIF optiune = 2 THEN
            --ciclu cursor            
            FOR k IN c_expl LOOP
                dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
                IF k.v_cnt_ang = 0 THEN
                    IF k.v_hist_ang = 0 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza si nu a lucrat NICIUN angajat');
                    ELSIF k.v_hist_ang = 1 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza in prezent NICIUN angajat, insa in trecut a mai lucrat un singur angajat');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza in prezent NICIUN angajat, insa in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                    END IF;
                ELSE
                    IF k.v_cnt_ang = 1 THEN
                        IF k.v_hist_ang = 0 THEN
                            dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut nu a mai lucrat NICIUN angajat');
                        ELSIF k.v_hist_ang = 1 THEN
                            dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut a mai lucrat un singur angajat');
                        ELSE
                            dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                        END IF;
                    ELSE 
                        IF k.v_hist_ang = 0 THEN
                            dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut nu a mai lucrat NICIUN angajat');
                        ELSIF k.v_hist_ang = 1 THEN
                            dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut a mai lucrat un singur angajat');
                        ELSE
                            dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                        END IF;
                    END IF;
                    --ciclu cursor cu subcereri
                    FOR i IN (SELECT nume_job, (SELECT COUNT(a.cod_angajat)
                                                FROM  angajat a
                                                WHERE a.cod_job(+) = j.cod_job 
                                                AND a.cod_cinema = k.v_cod_cinema) nr_ang, 
                                               (SELECT COUNT(il.cod_angajat)
                                                FROM  istoric_lucru il
                                                WHERE j.cod_job = il.cod_job(+) 
                                                AND il.cod_cinema = k.v_cod_cinema) hist_ang
                               FROM job j) LOOP
                        IF i.nr_ang != 0 THEN
                            OPEN c_param(k.v_cod_cinema, i.nume_job);
                            dbms_output.new_line();
                            dbms_output.put_line('---------Jobul ' || UPPER(i.nume_job) || ' ---------');
                            LOOP
                                FETCH c_param INTO v_nume_ang;
                                    EXIT WHEN c_param%NOTFOUND;
                                    dbms_output.put_line('  (Actual)    Angajatul ' || v_nume_ang);
                                END LOOP;
                            CLOSE c_param;
                            IF i.hist_ang != 0 THEN
                                OPEN c_param_hist(k.v_cod_cinema, i.nume_job);
                                LOOP
                                    FETCH c_param_hist INTO v_nume_ang;
                                        EXIT WHEN c_param_hist%NOTFOUND;
                                        dbms_output.put_line('  (Istoric)    Angajatul ' || v_nume_ang);
                                END LOOP;
                                CLOSE c_param_hist;
                            END IF;
                        ELSIF i.hist_ang != 0 THEN
                            OPEN c_param_hist(k.v_cod_cinema, i.nume_job);
                            dbms_output.new_line();
                            dbms_output.put_line('---------Jobul ' || UPPER(i.nume_job) || ' ---------');
                            LOOP
                                FETCH c_param_hist INTO v_nume_ang;
                                EXIT WHEN c_param_hist%NOTFOUND;
                                dbms_output.put_line('  (Istoric)    Angajatul ' || v_nume_ang);
                            END LOOP;
                            CLOSE c_param_hist;
                        END IF;
                    END LOOP;
                END IF; 
                dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
                dbms_output.new_line();
            END LOOP;
        ELSE
            dbms_output.put_line('Optiunea nu e valida');
        END IF;
    EXCEPTION 
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');       
    END proc_proiect_ex7_rs;
    
    FUNCTION funct_proiect_ex8_rs(gen IN film.gen_princ%TYPE, an IN CHAR)
        RETURN NUMBER IS
        exc_err_an_neg EXCEPTION;
        exc_err_an EXCEPTION;
        exc_err_gen EXCEPTION;
        exc_err_dif EXCEPTION;
        exc_err_bilet EXCEPTION;
        cnt NUMBER;
        pret NUMBER;
    BEGIN
        IF an < 0 THEN 
            RAISE exc_err_an_neg;
        END IF;
        IF an > TO_CHAR(SYSDATE, 'YYYY') THEN 
            RAISE exc_err_an;
        END IF;
        SELECT COUNT(*) INTO cnt
        FROM film
        WHERE UPPER(gen_princ) = UPPER(gen);
        IF cnt = 0 THEN
            RAISE exc_err_gen;
        END IF;
        SELECT COUNT(cod_difuzare) INTO cnt
        FROM film f, difuzare d
        WHERE UPPER(gen_princ) = UPPER(gen) AND f.cod_film = d.cod_film AND TO_CHAR(data_inc, 'YYYY') >= an;
        IF cnt = 0 THEN
            RAISE exc_err_dif;
        END IF;
        --JOIN ce include 3 tabele (FILM, DIFUZARE, BILET_CUMPARAT)
        SELECT SUM(bc.pret) INTO pret
        FROM film f, difuzare d, bilet_cumparat bc
        WHERE UPPER(f.gen_princ) = UPPER(gen) AND f.cod_film = d.cod_film 
             AND bc.cod_difuzare(+) = d.cod_difuzare AND TO_CHAR(d.data_inc, 'YYYY') >= an;
        IF pret is null THEN
            RAISE exc_err_bilet;
        END IF;
        RETURN pret;
    EXCEPTION
        WHEN exc_err_an_neg THEN
            RAISE_APPLICATION_ERROR(-20003, 'Nu puteti introduce un an negativ!');
        WHEN exc_err_an THEN
            RAISE_APPLICATION_ERROR(-20004, 'Ati introdus un an mai mare decat anul curent, si nu exista date despre difuzari din viitor!');
        WHEN exc_err_gen THEN
            RAISE_APPLICATION_ERROR(-20005, 'Nu exista niciun film care sa aiba genul ' || UPPER(gen) || '!');
        WHEN exc_err_dif THEN
            RAISE_APPLICATION_ERROR(-20006, 'Nu exista nicio difuzare pentru filme de genul ' || UPPER(gen) || ' care sa fi avut loc dupa anul ' || an || '!');
        WHEN exc_err_bilet THEN
            RAISE_APPLICATION_ERROR(-20007, 'Nu exista niciun bilet vandut la difuzare care a avut loc dupa anul ' || an || ' a vreunui film cu genul ' || UPPER(gen) || '!');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
    END funct_proiect_ex8_rs;

    PROCEDURE proc_proiect_ex9_rs(an CHAR, numeA VARCHAR2) IS
        exc_an_neg EXCEPTION;
        exc_an EXCEPTION;
        exc_an_NDF EXCEPTION;
        cnt NUMBER;
        an_deb actor.an_debut%TYPE;
    BEGIN
        IF an < 0 THEN 
            RAISE exc_an_neg;
        END IF;
        IF an > TO_CHAR(SYSDATE, 'YYYY') THEN 
            RAISE exc_an;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM cinematograf
        WHERE to_char(data_desch, 'YYYY') >= an AND (UPPER(to_char(data_desch, 'DAY')) LIKE '%MONDAY%' 
                    OR UPPER(to_char(data_desch, 'DAY')) LIKE '%SATURDAY%');
        IF cnt = 0 THEN
            RAISE exc_an_NDF;
        END IF;
        
        SELECT an_debut INTO an_deb
        FROM actor
        WHERE (LOWER(prenume) LIKE LOWER(numeA) OR LOWER(nume) LIKE LOWER(numeA));
        
        --comanda SQL ce include 5 tabele, prin intermediul subcererilor (ACTOR, JOACA, REGIZOR, REGIZEAZA, FILM)
        FOR i IN (SELECT f.cod_film cod, NVL((SELECT SUM(nr_premii)
                                              FROM actor a, joaca j
                                              WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film
                                                    AND a.an_debut <> an_deb), 0) premii_act,
                                    NVL((SELECT COUNT(a.id_actor)
                                     FROM actor a, joaca j
                                     WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film
                                           AND a.an_debut <> an_deb), 0) nr_act,
                                NVL((SELECT SUM(nr_premii)
                                     FROM regizor r, regizeaza ra
                                     WHERE r.id_regizor = ra.id_regizor AND ra.cod_film = f.cod_film), 0) premii_reg,
                            NVL((SELECT COUNT(nr_premii)
                             FROM regizor r, regizeaza ra
                             WHERE r.id_regizor = ra.id_regizor AND ra.cod_film = f.cod_film), 0) nr_reg
                    FROM film f) LOOP
             UPDATE film
             SET date_membrii = tab_imbr( obj(i.premii_act, i.nr_act), obj(i.premii_reg, i.nr_reg))
             WHERE cod_film = i.cod;
        END LOOP;
        
        --comanda SQL ce include 5 tabele, prin intermediul JOIN-ului (FILM, RULEAZA, DIFUZARE,   CINEMATOGRAF, SALA), la care se 
        --adauga prin intermediul subcererilor inca o data tabela FILM si coloana aditionala din tabela film preluata ca TABLE
        FOR i IN (SELECT c.nume_cinema numeC, to_char(data_desch, 'DAY') zi,  f.nume_film numeF, d.nr_sala salaD, 
                    s.tip salaT, f.rating ratingF,
                        (SELECT SUM(b.part)
                         FROM film a, TABLE (a.date_membrii) b
                         WHERE a.cod_film = f.cod_film) nr_part,
                        (SELECT SUM(b.nr_premii)
                         FROM film a, TABLE (a.date_membrii) b
                         WHERE a.cod_film = f.cod_film) nr_premii,
                        (SELECT nvl(SUM(b.nr_premii)/ NULLIF(SUM(b.part), 0), 0) 
                         FROM film a, TABLE (a.date_membrii) b
                         WHERE a.cod_film = f.cod_film) medie_premii      
                    FROM film f, ruleaza r, difuzare d, cinematograf c, sala s
                    WHERE c.cod_cinema = r.cod_cinema AND r.cod_film = f.cod_film
                       AND (UPPER(to_char(data_desch, 'DAY')) LIKE '%MONDAY%' OR UPPER(to_char(data_desch, 'DAY')) LIKE '%SATURDAY%')
                       AND to_char(data_desch, 'YYYY') >= an
                       AND f.cod_film = d.cod_film 
                       AND d.nr_sala = s.nr_sala AND s.cod_cinema = c.cod_cinema
                       AND (LOWER(s.tip) LIKE '%multi%' OR LOWER(s.tip) LIKE 'vip')
                       AND months_between(r.data_final, r.data_inceput) > 4
                   ORDER BY 7 DESC, 6 DESC, 5 DESC, 4 DESC) LOOP
            IF UPPER(i.zi) LIKE '%SATURDAY%' THEN
                i.zi := 'SAMBATA';
            ELSE 
                i.zi := 'LUNI';
            END IF;
            dbms_output.new_line();
            IF i.medie_premii = 0 THEN
                IF i.nr_part = 1  THEN
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membriu in productie, iar acesta nu a castigat NICIUN premiu');
                ELSIF i.nr_part > 0 THEN
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part || ' membrii in productie, iar acestia nu a castigat NICIUN premiu');
                ELSE 
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Pentru acest film nu s-au putut colectiona date despre actori sau regizori');
                END IF;
            ELSE
                IF i.nr_premii = 1 THEN
                    IF i.nr_part = 1 THEN
                        dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                        dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membru in productie, iar acesta a castigat in total un singur premiu');
                        dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                    ELSE
                        dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                        dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part 
                                        || ' membrii in productie, iar acestia au castigat in total un singur premiu');
                        dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                    END IF;
                ELSE
                    IF i.nr_part = 1 THEN
                        dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                        dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membru in productie, iar acesta a castigat in total ' || i.nr_premii || ' premii');
                        dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                    ELSE
                        dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                    || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                    || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                        dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part || ' membrii in productie, iar acestia au castigat in total ' || i.nr_premii || ' premii');
                        dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                    END IF;
                END IF;
            END IF;
        END LOOP;        
    EXCEPTION
        WHEN exc_an_neg THEN
            RAISE_APPLICATION_ERROR(-20003, 'Nu puteti introduce un an negativ!');
        WHEN exc_an THEN
            RAISE_APPLICATION_ERROR(-20004, 'Ati introdus un an mai mare decat anul curent, si nu exista date despre cinematografe deschise in viitor!');
        WHEN exc_an_NDF THEN
            RAISE_APPLICATION_ERROR(-20005, 'Nu exista niciun cinematograf deschis luni sau sambata, dupa anul ' || an || '!');
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Nu exista niciun actor cu numele sau prenumele ' || UPPER(numeA) || '!');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20007, 'Exista mai muti actori cu numele sau prenumele ' || UPPER(numeA) || '!');
        WHEN OTHERS THEN 
            RAISE_APPLICATION_ERROR(-20008, 'Alta eroare!');
    END proc_proiect_ex9_rs;
END pachet_proiect_ex13_rs;
/

EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex6_rs;

EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex7_rs(1);
EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex7_rs(99);

DECLARE
    pret NUMBER;
BEGIN
    pret := pachet_proiect_ex13_rs.funct_proiect_ex8_rs('Teatru', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
DECLARE
    pret NUMBER;
BEGIN
    pret := pachet_proiect_ex13_rs.funct_proiect_ex8_rs('Actiune', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/

EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex9_rs('-10', 'Zendaya');
EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex9_rs('2000', 'Ryan');

EXECUTE pach_aux.dropping;
DROP PACKAGE pach_aux;
DROP PACKAGE pachet_proiect_ex13_rs;


--14. Definiti un pachet care sa includa tipuri de date complexe si obiecte necesare unui flux de actiuni 
--integrate, specifice bazei de date definite (minim 2 tipuri de date, minim 2 functii, minim 2 proceduri).

/*
    Procedura "colectare_date" aduna in tabelul de tip record, definit in cadrul pachetului informatii coerente, memorand date 
despre fiecare cinematograf din baza de date, colectand id-ul si numele acestuia, numele unui film care ruleaza in acel cinematograf,
numarul de rulari ce au avut loc in cinematograful actual pentru filmul actual, numarul de difuzari si numarul de bilete cumparate.
Numarul de difuzari ?i de bilete se vor afla cu ajutorul functiilor "nr_difuz?ri" si "nr_bilete".
    Procedura "afisare" va afisa datele memorate in tabelul de tip record cu ajutorul procedurii "colectare_date". Afisarea se va 
face pe categorii, listandu-se prima data cazul in care au fost memorate date complete despre cinematograf, filme, rul?ri, difuz?ri si bilete 
(cel putin o informatie completa), sau cazul in care nu avem nicio data completa memorata. De asemenea se va trata, cazul in care 
nu avem deloc date despre filme care sa fi rulat in acel cinematograf, sau ne lipsesc date despre rulari, difuzari sau bilete 
(cel putin una dintre ele are valoarea 0) pentru fiecare film care a rulat in acel cinematograf, iar atunci vom afisa continutul 
tabelului imbricat ce retine numele cinemtografelor care nu inregistreaza nici macar o informatie completa.
    Procedura "modificare" mareste salariul tuturor angajatilor care lucreaza in unul din cinematografele care au vandut maximul 
de bilete vandute (calculat de noi din baza de date). Se va verifica daca noul salariu se incadreaza in limitele salariilor pentru 
jobul pe care se afla acel angajat, cu ajutorul unei functii ("verif_sal"). Salariul se va mari cu 
num?rul maxim de bilete vandute * 0.5. De asemenea, la final se va afisa numarul de linii afectate de comanda UPDATE.
*/



CREATE OR REPLACE PACKAGE pachet_proiect_ex14_rs AS    
    --tip de date -> RECORD
    TYPE rec_pak IS RECORD
        (id_cinema cinematograf.cod_cinema%TYPE,
         n_cinema cinematograf.nume_cinema%TYPE,
         n_film film.nume_film%TYPE,
         cnt_rulat NUMBER,
         cnt_dif NUMBER,
         cnt_bilet NUMBER);
    --tip de date -> tabel imbricat ce retine obiecte de tipul RECORD definit mai sus
    TYPE tabel_auxiliar IS TABLE OF rec_pak;
    info_compl tabel_auxiliar := tabel_auxiliar();

    --tip de date -> tabel imbricat ce nume de cinemtografe
    TYPE tabel_auxiliar_2 IS TABLE OF cinematograf.nume_cinema%TYPE;
    info_err tabel_auxiliar_2 := tabel_auxiliar_2();

    --tip de date -> cursor explicit
    CURSOR c_cinema RETURN cinematograf%ROWTYPE;
    --tip de date -> cursor parametrizat
    CURSOR c_film (p_cinema cinematograf.cod_cinema%TYPE) IS
        (SELECT f.cod_film, nume_film, COUNT(*)
         FROM film f, ruleaza r
         WHERE f.cod_film = r.cod_film AND p_cinema = r.cod_cinema
         GROUP BY f.cod_film, nume_film);
   
    FUNCTION nr_bilete_cump(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER;
    
    FUNCTION nr_difuzari(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER;
    
    FUNCTION max_bilet RETURN NUMBER;
    
    FUNCTION verif_sal(c_job job.cod_job%TYPE, new_sal NUMBER) RETURN NUMBER;
    
    PROCEDURE colectare_date;
    
    PROCEDURE afisare;
    
    PROCEDURE modificare;
END pachet_proiect_ex14_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet_proiect_ex14_rs AS    
    CURSOR c_cinema RETURN cinematograf%ROWTYPE IS 
        SELECT * 
        FROM cinematograf;
    
    FUNCTION nr_bilete_cump(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER 
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM bilet_cumparat b, difuzare d
        WHERE b.cod_difuzare = d.cod_difuzare AND d.cod_cinema = c_cin AND d.cod_film = c_film;
        RETURN cnt;
    END nr_bilete_cump;
    
    FUNCTION nr_difuzari(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER 
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM difuzare d
        WHERE d.cod_cinema = c_cin AND d.cod_film = c_film;
        RETURN cnt;
    END nr_difuzari;
    
    FUNCTION max_bilet 
        RETURN NUMBER 
    IS
        maxim NUMBER := -1;
    BEGIN
        IF info_compl.COUNT > 0 THEN
            FOR i IN info_compl.FIRST..info_compl.LAST LOOP
                IF maxim < info_compl(i).cnt_bilet THEN
                    maxim := info_compl(i).cnt_bilet;
                END IF;
            END LOOP;
        END IF;
        RETURN maxim;        
    END max_bilet;
    
    FUNCTION verif_sal(c_job job.cod_job%TYPE, new_sal NUMBER) 
        RETURN NUMBER
    IS
        sal_max NUMBER;
    BEGIN
        SELECT salariu_max INTO sal_max
        FROM job
        WHERE cod_job = c_job;
        
        IF sal_max > new_sal THEN
            RETURN 1;
        ELSE 
            RETURN -1;
        END IF;
    END verif_sal;
    
    PROCEDURE colectare_date
    IS
        cod_f film.cod_film%TYPE;
        nume_f film.nume_film%TYPE;
        cnt_rul NUMBER;
        cnt_bil NUMBER;
        cnt_dif NUMBER;
        contor NUMBER;
    BEGIN
        IF info_compl.COUNT = 0 AND info_err.COUNT = 0 THEN
            FOR i IN c_cinema LOOP
                OPEN c_film(i.cod_cinema);
                contor := 0;
                LOOP 
                    FETCH c_film INTO cod_f, nume_f, cnt_rul;
                    EXIT WHEN c_film%NOTFOUND;
                    cnt_dif := nr_difuzari(i.cod_cinema, cod_f);
                    cnt_bil := nr_bilete_cump(i.cod_cinema, cod_f);
                    IF cnt_rul != 0 AND cnt_dif != 0  AND cnt_bil != 0 THEN
                        info_compl.EXTEND;
                        info_compl(info_compl.COUNT).id_cinema := i.cod_cinema;
                        info_compl(info_compl.COUNT).n_cinema := i.nume_cinema;
                        info_compl(info_compl.COUNT).n_film := nume_f;
                        info_compl(info_compl.COUNT).cnt_rulat := cnt_rul;
                        info_compl(info_compl.COUNT).cnt_bilet := cnt_bil;
                        info_compl(info_compl.COUNT).cnt_dif := cnt_dif;
                    ELSE 
                        contor := contor + 1;          
                    END IF;
                END LOOP;
                IF c_film%ROWCOUNT = 0 OR c_film%ROWCOUNT = contor THEN
                    info_err.EXTEND;
                    info_err(info_err.COUNT) := i.nume_cinema;
                END IF;
                CLOSE c_film;
            END LOOP; 
        END IF;
    END colectare_date;
    
    PROCEDURE afisare
    IS
        v_prec cinematograf.cod_cinema%TYPE := -100;
    BEGIN
        IF info_compl.COUNT =0  AND info_err.COUNT = 0 THEN
            colectare_date;
        END IF;
        IF info_compl.COUNT > 0 THEN
            dbms_output.put_line('---------------DATE COMPLETE (FILM, RULARE, DIFUZARE, BILETE)-------------');
            FOR i IN info_compl.FIRST..info_compl.LAST LOOP
                IF v_prec != info_compl(i).id_cinema THEN
                    dbms_output.new_line();
                    dbms_output.put_line('--------------------------------------------------------------------------');
                    dbms_output.put_line('                    ' || UPPER(info_compl(i).n_cinema));
                    dbms_output.new_line();
                    v_prec := info_compl(i).id_cinema;
                END IF;
                dbms_output.put_line(' [Filmul ' || UPPER(info_compl(i).n_film) || '] [Nr. Rulari ' ||   info_compl(i).cnt_rulat || ' ] [Nr. Difuzari ' ||   info_compl(i).cnt_dif || ' ] [Nr. Bilete ' ||   info_compl(i).cnt_bilet || ']');
            END LOOP;
            dbms_output.new_line();
            dbms_output.put_line('--------------------------------------------------------------------------');
            dbms_output.new_line();
            dbms_output.new_line();
        ELSE 
            dbms_output.put_line('---------------NU EXISTA DATE COMPLETE (FILM, RULARE, DIFUZARE, BILETE)-----------');
            dbms_output.put_line('--------------------------------------------------------------------------');
            dbms_output.new_line();
            dbms_output.new_line();
        END IF;
        IF info_err.COUNT > 0 THEN
            dbms_output.put_line('------------------------------DATE LIPSA----------------------------------');
            dbms_output.new_line();
            FOR i IN info_err.FIRST..info_err.LAST LOOP
                    dbms_output.put_line('                    ' || UPPER(info_err(i)));
            END LOOP;
         ELSE 
            dbms_output.put_line('-------------------------NU EXISTA DATE LIPSA-----------------------------');
            dbms_output.new_line();
        END IF;
    END afisare;
    
    PROCEDURE modificare
    IS
        maxim NUMBER;
        v_prec cinematograf.cod_cinema%TYPE := -100;
        v_flag NUMBER := 0;
        ok_update NUMBER;
        contor NUMBER := 0;
    BEGIN
        IF info_compl.COUNT =0  AND info_err.COUNT = 0 THEN
            colectare_date;
        END IF;
        maxim := max_bilet;
        IF maxim != -1 THEN
            FOR i IN info_compl.FIRST..info_compl.LAST LOOP
                IF v_prec != info_compl(i).id_cinema THEN
                    v_prec := info_compl(i).id_cinema;
                    v_flag := 0;
                END IF;
                IF v_prec = info_compl(i).id_cinema AND v_flag = 0 AND info_compl(i).cnt_bilet = maxim THEN
                        FOR k IN (SELECT cod_angajat, cod_job, cod_cinema, salariu
                                  FROM angajat 
                                  WHERE cod_cinema = info_compl(i).id_cinema) LOOP
                            ok_update := verif_sal(k.cod_job, k.salariu + (maxim * 0.5));
                            IF ok_update = 1 THEN
                                UPDATE angajat
                                SET salariu = k.salariu + (maxim * 0.5)
                                WHERE cod_angajat = k.cod_angajat;
                                contor := contor + 1;
                            END IF;
                        END LOOP;
                        v_flag := 1;
                    END IF;
            END LOOP;
        END IF;
        dbms_output.new_line();
        dbms_output.new_line();
        dbms_output.put_line('-----------Linii updatate: ' || contor || ' -----------');
    END modificare;
END pachet_proiect_ex14_rs;
/

EXECUTE pachet_proiect_ex14_rs.colectare_date;
EXECUTE pachet_proiect_ex14_rs.afisare;
EXECUTE pachet_proiect_ex14_rs.modificare;
SELECT * FROM angajat;

ROLLBACK;

DROP PACKAGE pachet_proiect_ex14_rs;