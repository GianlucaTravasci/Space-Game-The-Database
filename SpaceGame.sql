#-------------------------CREAZIONE TABELLE----------------
CREATE TABLE materie (
	id int (255) not null auto_increment,
	nome varchar (255) not null,
	descrizione varchar (255),
	primary key (id)
) ENGINE=InnoDB;
CREATE TABLE oggetti (
	id int (255) not null auto_increment,
	nome varchar (255) not null,
	tipo enum('armamento', 'generatore_deflettori', 'generatore_energia'),
	tipologia enum ('equipaggiamento', 'gemme', 'materie_prime') not null,
	id_materia int (255)  not null,
	salute int (255) not null default 0,
	spazio_occupato int (255) not null,
	prezzo int (255) not null,
	produzione int (255) not null default 0,
	consumo int (255) not null default 0,
	descrizione varchar (255) not null,
	montaggio int (255) not null default 300,
	attivo smallint (1) not null default 1,
	primary key (id),
	constraint oggetti_materia
		foreign key (id_materia)
		references materie (id)
		on update cascade
		on delete cascade
) ENGINE=InnoDB;
CREATE TABLE gilde (
	nome varchar (255) not null,
	punti int (255) not null,
	tag varchar (3) not null,
	id_fondatore int (20),
	primary key (nome, tag),
	unique (nome),
	unique (tag),
	key (id_fondatore)
) ENGINE=InnoDB;
CREATE TABLE utenti (
	id int (20) not null auto_increment,
	username varchar (255) not null,
	passward varchar (255) not null,
	email varchar (255) not null,
	ruolo enum ('dirigente', 'partecipante'),
	tag_gilda varchar (3),
	soldi int (255) not null default 6000,
	token varchar (255) not null,
	valido smallint (1) not null default 1, 
	primary key (id),
	unique (username),
	constraint utente_gilda
		foreign key (tag_gilda)
		references gilde (tag) 
		on delete set null
		on update cascade
) ENGINE=InnoDB;
ALTER TABLE gilde 
ADD CONSTRAINT `fondatore_utentes`
	FOREIGN KEY (`id_fondatore`)
	REFERENCES `utenti`(`id`)
	ON DELETE SET NULL
	ON UPDATE CASCADE;
CREATE TABLE missioni (
	id int (255) not null auto_increment,
	nome varchar (255) not null,
	descrizione varchar (255) not null,
	tipo enum ('multiplayer', 'sigleplayer') not null,
	punti_reputazione int (255) not null,
	soldi int (255) not null,
	primary key (id)
) ENGINE=InnoDB;
CREATE TABLE missioni_obbiettivi (
	id_missione int (255) not null,
	id_oggetto int (255) not null,
	quantita int (255) not null,
	primary key (id_missione, id_oggetto),
	constraint missioni 
		foreign key (id_missione)
		references missioni (id)
		on delete cascade
		on update cascade,
	constraint oggetto
		foreign key (id_oggetto)
		references oggetti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE missioni_storico (
	id_missione int (255) not null,
	id_giocatore int (255),
	tag_gilda varchar (3),
	data_completamento datetime not null,
	primary key (id_missione, id_giocatore, tag_gilda),
	constraint missioni_storico
		foreign key (id_missione)
		references missioni (id)
		on delete cascade
		on update cascade,
	constraint giocatore_storico
		foreign key (id_giocatore)
		references utenti (id)
		on delete cascade
		on update cascade,
	constraint gilda_storico
		foreign key (tag_gilda)
		references gilde (tag)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE gilda_deposito (
	tag_gilda varchar (3) not null,
	id_oggetto int (255) not null,
	quantita int (255) not null,
	primary key (tag_gilda, id_oggetto),
	constraint gilda_deposito_gilda 
		foreign key (tag_gilda)
		references gilde (tag)
		on delete cascade
		on update cascade,
	constraint gilda_deposito_oggetto
		foreign key (id_oggetto)
		references oggetti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE modelli (
	id int (20) not null auto_increment,
	nome varchar (255) not null,
	hp int (255) not null,
	tipo enum ('mercantile', 'militare', 'esplorazione') not null,
	specialisti int (255) not null default 2,
	prezzo int (255) not null,
	serbatoio int (50) not null,
	slot_armamenti int (5) not null default 0	,
	slot_stiva int (5) not null default 0,
	slot_generatori int (5) not null default 0,
	attivo smallint (1) not null default 1,
	primary key (id)
) ENGINE=InnoDB;
CREATE TABLE comandanti (
	id int (100) not null auto_increment,
	nome varchar (255) not null,
	esplorazione smallint (10) not null default 0,
	meccanica smallint (10) not null default 0,
	militare smallint (10) not null default 0,
	prezzo int (255) not null,
	primary key (id)
) ENGINE=InnoDB;
CREATE TABLE astronavi (
	id int (250) not null auto_increment,
	id_utente int (100) not null,
	id_modello int (100) not null,
	id_comandante int (100),
	nome varchar (255) not null,
	salute int (100) not null,
	partenza varchar (255) default null,
	destinazione varchar (255) default null,
	stato enum('ferma', 'riparazione', 'aggiornamento_slot', 'in_viaggio', 'distrutta') not null,
	slot_generatori_liberi int (50) not null default 0,
	slot_stiva_liberi int (50) not null default 0,
	slot_armamenti_liberi int (50) not null default 0,
		primary key (id),
	constraint utente
		foreign key (id_utente)
		references utenti (id)
		on delete cascade
		on update cascade,
	constraint modello
		foreign key (id_modello)
		references modelli (id)
		on delete cascade
		on update cascade,
	constraint comandante
		foreign key (id_comandante)	
		references comandanti (id)
		on delete set null
		on update set null
) ENGINE=InnoDB;
CREATE TABLE specialisti (
	id int (100) not null auto_increment,
	costo int (255) not null,
	id_materia int (255) not null,
	nome varchar (255) not null,
	descrizione varchar (255) not null,
	primary key (id),
	constraint specialisti_materia
		foreign key (id_materia)
		references materie (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE equipaggio (
	id int (255) not null auto_increment,
	id_astronave int (255) not null,
	id_specialista int (100) not null,
	quantita int (200) not null,
	primary key (id),
	constraint astronave
		foreign key (id_astronave)
		references astronavi (id)
		on delete cascade
		on update cascade,
	constraint Specialista
		foreign key (id_specialista)
		references specialisti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE stiva (
	id int (255) not null auto_increment,
	id_astronave int (255) not null,
	id_oggetto int (255) not null,
	quantita int (255) not null,
	primary key (id),
	constraint stiva_astronave
		foreign key (id_astronave)
		references astronavi (id)
		on delete cascade
		on update cascade,
	constraint stiva_oggetto
		foreign key (id_oggetto)
		references oggetti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE pezzi_montati (
	id int (255) not null auto_increment,
	id_astronave int (255) not null,
	id_oggetto int (100) not null,
	danni int (100) not null,
	data int (35),
	primary key (id),
	constraint pezzi_montati_astronave
		foreign key (id_astronave)
		references astronavi (id)
		on update cascade
		on delete cascade,
	constraint pezzi_montati_oggetto 
		foreign key (id_oggetto)
		references oggetti (id)
		on update cascade
		on delete cascade
) ENGINE=InnoDB;
CREATE TABLE pianeti (
	id int (255) not null auto_increment,
	nome varchar (255) not null,
	x int (255) not null,
	y int (255) not null,
	descrizione varchar (255) not null,
	abitato smallint (1) not null default 0,
	inesplorato smallint (1) not null default 1,
	primary key (id),
	unique (nome)
) ENGINE=InnoDB;
CREATE TABLE negozi_pianeti (
	id int (255) not null auto_increment,
	nome varchar (255) not null,
	id_pianeta int (255) not null,
	descrizione varchar (255) not null,
	primary key (id),
	constraint pianeta
		foreign key (id_pianeta)
		references pianeti (id)
		on update cascade
		on delete cascade
) ENGINE=InnoDB;
CREATE TABLE hangar (
	id int (255) not null auto_increment,
	id_utente int(255) not null,
	id_pianeta int (255) not null,
	primary key (id),
	constraint hangar_utente
		foreign key (id_utente)
		references utenti (id)
		on delete cascade
		on update cascade,
	constraint hangar_pianeta
		foreign key (id_pianeta)
		references pianeti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE oggetti_hangar (
	id int (255) not null auto_increment,
	id_oggetto int (255) not null,
	id_hangar int (255) not null,
	quantita int (255)  not null,
	primary key (id),
	constraint oggetti_hangar_oggetto 
		foreign key (id_oggetto)
		references oggetti (id)
		on delete cascade
		on update cascade,
	constraint oggetti_hangar_hangar
		foreign key (id_hangar)
		references oggetti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE oggetti_pianeti (
	id int (255) not null auto_increment,
	id_oggetto int (255) not null,
	id_pianeta int (255) not null,
	quantita int (255)  not null,
	stato enum ('trovato', 'non_trovato') not null,
	primary key (id),
	constraint pianeta_oggetto 
		foreign key (id_oggetto)
		references oggetti (id)
		on delete cascade
		on update cascade,
	constraint oggetti_pianeti_pianeta
		foreign key (id_pianeta)
		references pianeti (id)
		on delete cascade 
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE oggetti_negozio (
	id int (255) not null auto_increment,
	id_oggetto int (255) not null,
	id_negozio int (255) not null,
	quantita int (255)  not null,
	primary key (id),
	constraint oggetti_negozio_oggetto 
		foreign key (id_oggetto)
		references oggetti (id)
		on delete cascade
		on update cascade,
	constraint oggetti_negozio_negozio
		foreign key (id_negozio)
		references negozi_pianeti (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE percorso (
	id_astronave int (255) not null,
	step_percorso int (255) not null,
	data_arrivo datetime not null,
	x int (255) not null,
	y int (255) not null,
	primary key (id_astronave, step_percorso),
	constraint percorso_astronave
		foreign key (id_astronave)
		references astronavi (id)
		on delete cascade
		on update cascade
) ENGINE=InnoDB;
CREATE TABLE tipo_nemici (
	id int (255) not null auto_increment,
	nome varchar (255) not null,
	descrizione varchar(255) not null, 
	salute int (100) not null,
	danni_attacchi int (100) not null,
	grado_sfida int (255) not null,
	tipo enum ('mostro_spaziale', 'pirata_spaziale') not null,
	primary key (id) 
) ENGINE=InnoDB;
CREATE TABLE nemici (
	id int (255) not null auto_increment,
	id_tipo_nemici int (255) not null,
	danni_subiti int (100) not null default 0,
	x int (255) not null,
	y int (255) not null,
	primary key (id),
	constraint tipo_nemico
		foreign key (id_tipo_nemici)
		references tipo_nemici (id)
		on update cascade
		on delete cascade
) ENGINE=InnoDB;
CREATE TABLE ricompensa (
	id_missione int (255),
	id_tipo_nemico int (255),
	id_oggetto int (255) not null,
	quantita int (255) not null,
	primary key (id_tipo_nemico, id_oggetto),
	constraint ricompensa_nemico 
		foreign key (id_tipo_nemico)
		references tipo_nemici (id)
		on update cascade
		on delete cascade,
	constraint riconpensa_oggetto
		foreign key (id_oggetto)
		references oggetti (id)
		on update cascade
		on delete cascade,
	constraint ricompensa_missione 
		foreign key (id_missione)
		references missioni (id)
		on delete cascade
		on update cascade 
) ENGINE=InnoDB;
	#------------------------------CREAZIONE TRIGGER--------------------------



#-- Questro trigger aggiorna la ridondanza degli slot liberi nelle astroavi
DROP TRIGGER IF EXISTS ridondanzaSlotAstronavi ;
delimiter $$
CREATE TRIGGER ridondanzaSlotAstronavi
after insert on pezzi_montati
for each row
BEGIN
	declare tipo_slot char(30);
	declare slot_occupati integer;
	declare slot_massimi_generatori integer;
	declare slot_massimi_armamenti integer;
	declare msg char(60);

	#-- Prende il tipo di slot dell'oggetto che sta per essere inserito
	select o.tipo into tipo_slot 
	from oggetti as o 
	where o.id = NEW.id_oggetto;

	#-- Conta quanti slot di quel tipo sono già occupati
	select sum(o.spazio_occupato) into slot_occupati 
	from pezzi_montati as pm
	left join oggetti as o on o.id =pm.id_oggetto
	where pm.id_astronave = NEW.id_astronave and o.tipo = tipo_slot;

	#-- Preleva il numero massimo di slot del tipo richiesto di cui la nave dispone
	select m.slot_armamenti, m.slot_generatori
	into slot_massimi_armamenti, slot_massimi_generatori
	from astronavi as a 
	left join modelli as m on m.id = a.id_modello
	where a.id = NEW.id_astronave;

	IF (tipo_slot = 'generatore_deflettori' OR tipo_slot = 'generatore_energia') THEN
		UPDATE astronavi SET slot_generatori_liberi = (slot_massimi_generatori - slot_occupati) WHERE id = NEW.id_astronave;
	END IF;

	IF (tipo_slot = 'armamento') THEN
		UPDATE astronavi SET slot_armamenti_liberi = (slot_massimi_armamenti - slot_occupati) WHERE id = NEW.id_astronave;
	END IF;
END $$
delimiter ;

#-- Questro trigger aggiorna la ridondanza degli slot liberi nelle astroavi
DROP TRIGGER IF EXISTS ridondanzaStivaAstronavi ;
delimiter $$
CREATE TRIGGER ridondanzaStivaAstronavi
after insert on stiva
for each row
BEGIN
	declare slot_occupati integer;
	declare slot_massimi_stiva integer;
	declare msg char(60);

	#-- Conta quanti slot di quel tipo sono già occupati
	select sum(o.spazio_occupato * s.quantita) into slot_occupati 
	from stiva as s
	left join oggetti as o on o.id =s.id_oggetto
	where s.id_astronave = NEW.id_astronave;

	#-- Preleva il numero massimo di slot del tipo richiesto di cui la nave dispone
	select m.slot_stiva
	into slot_massimi_stiva
	from astronavi as a 
	left join modelli as m on m.id = a.id_modello
	where a.id = NEW.id_astronave;

	UPDATE astronavi SET slot_stiva_liberi = (slot_massimi_stiva - slot_occupati) WHERE id = NEW.id_astronave;
END $$
delimiter ;




#-- Questro trigger controlla quando provo a montare qualcosa in uno slot astronave che ci sia lo spazio disponibile, altrimenti annulla l'inserimento
DROP TRIGGER IF EXISTS spazioPienoSlot ;
delimiter $$
CREATE TRIGGER spazioPienoSlot
before insert on pezzi_montati
for each row
begin
	declare tipo_slot char(30);
	declare slot_occupati integer;
	declare slot_massimi_generatori integer;
	declare slot_massimi_stiva integer;
	declare slot_massimi_armamenti integer;
	declare msg char(60);

	#-- Prende il tipo di slot dell'oggetto che sta per essere inserito
	select o.tipo into tipo_slot 
	from oggetti as o 
	where o.id = NEW.id_oggetto;

	#-- Conta quanti slot di quel tipo sono già occupati
	select sum(o.spazio_occupato) into slot_occupati 
	from pezzi_montati as pm
	left join oggetti as o on o.id =pm.id_oggetto
	where pm.id_astronave = NEW.id_astronave and o.tipo = tipo_slot;

	#-- Preleva il numero massimo di slot del tipo richiesto di cui la nave dispone
	select m.slot_armamenti, m.slot_stiva, m.slot_generatori
	into slot_massimi_armamenti, slot_massimi_stiva, slot_massimi_generatori
	from astronavi as a 
	left join modelli as m on m.id = a.id_modello
	where a.id = NEW.id_astronave;

	#-- Inserisce nella tabella di debug i dati utilizzati dal trigger
	#-- insert into debug values (tipo_slot, slot_occupati, slot_massimi_generatori, slot_massimi_stiva, slot_massimi_armamenti);

	if ((tipo_slot = 'generatore' and slot_massimi_generatori <= slot_occupati) or 
		(tipo_slot = 'stiva' and slot_massimi_stiva <= slot_occupati) or 
		(tipo_slot = 'armamento' and slot_massimi_armamenti <= slot_occupati)) then
			set msg = "Slot pieno, impossibile montare equipaggiamento...";
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
		end if ;
	end$$
delimiter ;

#-- Questro trigger controlla quando provo a inserire qualcosa nella stiva dell'astronave che ci sia lo spazio disponibile, altrimenti annulla l'inserimento
DROP TRIGGER IF EXISTS spazioPienoStiva ;
delimiter $$ 
CREATE TRIGGER spazioPienoStiva 
before insert on stiva
for each row
begin
	declare slot_occupati integer;
	declare slot_liberi integer;
	declare msg char (60);
	/*seleziono quanto spazio c'è sulla stiva di una singola astronave di un giocatore*/
	select m.slot_stiva into slot_liberi
	from astronavi as a 
	left join modelli as m on m.id = a.id_modello 
	where a.id=NEW.id_astronave;
	/*seleziona lo spazio occupato dagli oggetti contenuti nella stiva di un'astronave*/
	select sum(o.spazio_occupato * s.quantita) into slot_occupati
	from stiva as s 
	left join oggetti as o on o.id = s.id_oggetto
	where s.id_astronave=NEW.id_astronave;
	/*messaggio d'errore se lo spazio slot liberi è minore gli slot occupati daglio oggetti */
	if (slot_liberi<=slot_occupati)
		then 
			set msg = "Stiva piena";
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
		end if ;
	end$$
delimiter ;
--controlla e mi da errore se provo a montare su un'astronave un oggetto che non sia di tipologia equipaggiamento*/
-- per evitare conflitti ignoriamo questo trigger e non lo mettiamo nella relazione ----
DROP TRIGGER IF EXISTS astronaveEquip ;
delimiter $$ 
CREATE TRIGGER astronaveEquip
before insert on pezzi_montati 
for each row
begin
	tipo_oggetto integer;
	declare msg char (60);
	select tipologia into tipo_oggetto
	from oggetti as o 
	where o.id = NEW.id_oggetto

	if (tipo_oggetto <> 'equipaggiamento')
		then
			set msg = "impossibile mettere qui questo oggetto...";
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
		end if ;
	end$$
delimiter ;
DROP TRIGGER IF EXISTS controlloID_ricompensa ;
delimiter $$ 
CREATE TRIGGER controlloID_ricompensa
before insert on ricompensa
for each row
begin
	declare msg char (60);
	if not ((NEW.id_missione=NULL and NEW.id_tipo_nemico <> NULL) or (NEW.id_missione <> NULL and NEW.id_tipo_nemico = null)) then 
		set msg = "impossibile...";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;	
	end if ;
end $$
delimiter ; */

#---------------------DEBUGGGGGGGGG-----------------------
create table debug (
	tipo_slot varchar(20),
	slot_occupati int(10),
	slot_massimi_generatori int(10),
	slot_massimi_stiva int(10),
	slot_massimi_armamenti int(10),
)
