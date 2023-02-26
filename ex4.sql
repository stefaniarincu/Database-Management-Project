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