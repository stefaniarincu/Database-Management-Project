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