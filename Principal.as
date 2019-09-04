package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.sensors.Accelerometer;
	import fl.motion.easing.Back;
	import flash.media.*;
	
	public class Principal extends MovieClip {

		// PROPRIÉTÉS -------------------------------------------------------


		private var _tMap: Array; //le tableau de l'ensemble des tuiles
		// créer la MAP
		private const RANG: int = 20; // constance du nombre de ranger de la grille 
		private const COL: int = 20; // constance du nombre de collone de la grille
		private const TAILLE: int = 50; // constance du nombre de grosseur de tuile
		private var grille: MovieClip; // clip qui va contenir la map


		// gestion des levier
		private var posLever: Array; // tableau des levier 
		private var l: Levier; //  déclaration de la class Levier
		private var lDeux: LevierDeux; //  déclaration de la class Levier


		// gestion de trump
		private var _nouvTrump: MovieClip; //clip de trump
		private var t: Trump; //  déclaration de la class Trump
		// direction
		private var _droite: Boolean; // gestion de la direction
		private var _gauche: Boolean; // gestion de la direction
		private var _haut: Boolean; // gestion de la direction
		private var _bas: Boolean; // gestion de la direction

		//gestion puzzel 1
		private var _nouvLevierUn: MovieClip; // clip des levier
		private var _toutLevierUn: Array = new Array; // tableau qui contien tout les levier de lénigme 1
		private var _troisLevierUn: Array = new Array; // les 3 bon levier a utiliser
		private var _enigmeTextUn: Array = new Array; // tout les enigme
		private var _enigmeOfficielUn: Array = new Array; // selement les 3 enigme associer au levier
		private var _levierActuel: int; // compteur pour être en mesure de changer les effet grace au levier
		//gestion de la porte
		private var _nouvPorteUn: MovieClip; // clip de la porter
		private var p: Porte; //  déclaration de la class Porter
		// gestion des enigme1
		private var _infoUn: MovieClip; // clip du squelette (info) 
		private var i: Info; //  déclaration de la class Info


		// gestion puzzel 2
		private var _nouvLevierDeux: MovieClip; // clip des levier
		private var _toutLevierDeux: Array = new Array; // tableau qui contien tout les levier de lénigme 1
		private var _troisLevierDeux: Array = new Array; // les 3 bon levier a utiliser
		private var _enigmeTextDeux: Array = new Array; // tout les enigme
		private var _enigmeOfficielDeux: Array = new Array; // selement les 3 enigme associer au levier
		private var _levierActuelDeux: int = 0; // compteur pour être en mesure de changer les effet grace au levier
		//gestion de la porte
		private var _nouvPorteDeux: MovieClip; // clip de la porter
		private var pDeux: PorteDeux; //  déclaration de la class Porter


		private var _mapUn: Boolean = true; // sert a déterminer si l'utilisateur est dans la map 1 ou 2
		private var nomEcran: String = "principal";

		private var premierSpaw: Boolean = true; // éviter plusieur spawn
		private var premierMap: Boolean = true; // eviter plusieur map
		private var _paysActuel: String; // selectionner le payer actuel
		private var premierUSA: Boolean = true; // premier spawn USA
		private var premierFR: Boolean = true; // premier spawn FRANCE
		private var accesUn: Boolean;
		private var accesDeux: Boolean;
		private var channel:SoundChannel;
		private var win:Sound=new trumpWin;
		private var fond:Sound=new sonFond;
		
		// NAVIGATION ---------------------------------------------------------------		
		public function Principal() {
			trace(">>> écran", nomEcran, "créé");
			MovieClip(parent).addEventListener("reset", reset);
		}
		public function goFin(): void {
			MovieClip(parent).goto("fin", this);
		}
		private function goIntro(e: MouseEvent): void {
			MovieClip(parent).goto("intro", this);
		}

		public function activer(): void {
			trace("Écran", nomEcran, "activé");
			visible = true;
			init();

		}

		public function desactiver(): void {
			trace("Écran", nomEcran, "desactivé");

			// IMPORTANT: désactiver les écouteurs quand la page
			// est désactivée...

			removeEventListener(Event.ENTER_FRAME, loop);

			visible = false;
		} // MÉTHODES PRIVÉES ------------------------------------------------------------

		// initialisation du jeux 
		private function init(): void {
			var transform:SoundTransform = new SoundTransform(0.3, 0.3);

			
			channel=fond.play();
			channel.soundTransform = transform;
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
			
			
			_mapUn = true //réinitialise la variable a true
			premierUSA = true; //réinitialise la variable a true
			premierFR = true; //réinitialise la variable a true
			accesUn = true; //réinitialise la variable a true
			accesDeux = true; //réinitialise la variable a true
			_paysActuel == "USA"; // indicateur pour l'énigme
			_levierActuel = 0;
			_levierActuelDeux = 0;
			// tableau contenent tout les énigme de la premiere carte
			_enigmeTextUn = ["du mont Saint-Helen!", "du Devil Tower!", "de l'empire state building!", "du chimney rock!", "de la maison blanche!", "du signe Hollywood!", "du grand canyon!", "de Disney world!"];
			// tableau contenent tout les énigme de la seconde carte
			_enigmeTextDeux = ["de la tour eiffel", "du Barrage Vauban", "de Notre-Dame-en-Saint-Melaine", " de la basilique Notre-Dame de Fourvière", "du château des ducs de Bretagne", "du château de Nice", "de la place des Quinconces", "du château d'If"];
			//Mon premier se trouve au pied 
			// appelle de la fonction pour afficher le grille
			creerGrille();
			// appelle de la fonction pour afficher la porte
			creerPorte();
			//affiche les levier
			addChild(_nouvLevierUn);
			// spawn le joueur
			spawnTrump(480, 480);
			if (premierSpaw == true) {
				Trump(_nouvTrump.getChildAt(0)).trumpY = 10;
				Trump(_nouvTrump.getChildAt(0)).trumpX = 10;
				premierSpaw == false;
			}
			//-------------------------------PROG DE L'ÉGNIME NO 1 -----------------------------------------
			addEventListener(Event.ENTER_FRAME, loop);
		}
		// pour faire répéter lpe son de background
		function onSoundChannelSoundComplete(e:Event):void{
			var transform:SoundTransform = new SoundTransform(0.3, 0.3);
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
			channel = fond.play();
			channel.soundTransform = transform;
		}
		
		private function loop(e: Event): void {
			changerGrille();
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
			//ENIGME -----------------------------------
			// on permet d'afficher l'énigme qui convien au pays 
			if (_paysActuel == "USA") { 
				premierFR = true;
				if (premierUSA == true) {
					genereSkelette();
					addChild(_nouvTrump);
					premierUSA = false;
				}
				if (_levierActuel <= 2) { //on change la valeur des levier pour pouvoir avancer dans l'énigme
					_troisLevierUn[_levierActuel].levierActif = true; // on active le premier levier

				} else if (_levierActuel >= 3) { // si on atteind un certain de bon levier la porte s'ouvre 
					Porte(_nouvPorteUn.getChildAt(0)).ouvrire();
					for (var r: int = 0; r < RANG; r++) {
						for (var c: int = 0; c < COL; c++) {
							if (_tMap[r][c] == 100) { // on change la valeur de la map pour permtre au joueur de traverser
								_tMap[r][c] = 63;
							}
						}
					}
				}
			} else if (_paysActuel == "France") { // si le joueur est en france les même actions son effectuer 
				premierUSA = true;
				if (premierFR == true) {
					genereSkelette();
					addChild(_nouvTrump);
					premierFR = false;
				}
				if (_levierActuelDeux <= 2) { 
					LevierDeux(_troisLevierDeux[_levierActuelDeux]).levierActifDeux = true; // on active le premier levier
				} else {
					PorteDeux(_nouvPorteDeux.getChildAt(0)).ouvrire();
					for (var rD: int = 0; rD < RANG; rD++) {
						for (var cD: int = 0; cD < COL; cD++) { // on change la valeur de la map pour permtre au joueur de traverser
							if (_tMap[rD][cD] == 100) {
								_tMap[rD][cD] = 63;
							}
						}
					}
				}
				// fin de parti---------
				if (Trump(_nouvTrump.getChildAt(0)).posY == 2 && _paysActuel == "France") { // si le joueur a fini par traverser la seconde porte
					MovieClip(parent).fin_mc.gotoAndStop(1);
					win.play();
					finParti()
					goFin();
				}
			}


			// DIRECTION -------------------------------
			if (_droite == true) {
				t.allerDroite();
			}
			if (_gauche == true) {
				t.allerGauche();
			}
			if (_bas == true) {
				t.allerBas();

			}
			if (_haut == true) {
				t.allerHaut();
			}
		}
		// MAP1------------------------------------------------------------------------------------------------
		// crée la premiere car (USA) on réutilise cette fonction pour le changement de map 
		private function creerGrille(): void {

			_paysActuel = "USA"; // initialise le pays 
			// crée le tableau contenent la carte
			_tMap = [
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 100, 100, 100, 40, 40, 40, 40, 40, 40, 40, 40],
				[40, 40, 40, 04, 67, 48, 48, 48, 48, 46, 63, 55, 40, 40, 40, 40, 04, 03, 42, 40],
				[40, 40, 04, 67, 61, 67, 63, 63, 63, 63, 67, 50, 48, 48, 48, 48, 46, 67, 03, 40],
				[40, 04, 46, 63, 67, 63, 63, 63, 63, 67, 61, 67, 63, 63, 63, 63, 67, 61, 67, 40],
				[40, 51, 63, 63, 63, 63, 63, 63, 63, 63, 67, 63, 63, 63, 63, 63, 60, 67, 38, 40],
				[40, 51, 63, 63, 63, 63, 63, 63, 63, 63, 67, 63, 63, 63, 63, 67, 55, 38, 40, 40],
				[40, 51, 67, 63, 63, 63, 63, 63, 63, 67, 61, 67, 63, 63, 67, 61, 67, 40, 40, 40],
				[40, 67, 61, 67, 63, 63, 63, 63, 63, 63, 67, 63, 63, 63, 63, 67, 01, 40, 40, 40],
				[40, 43, 67, 56, 63, 63, 67, 63, 63, 63, 63, 63, 63, 63, 63, 55, 38, 40, 40, 40],
				[40, 40, 43, 02, 58, 67, 61, 67, 63, 63, 63, 63, 63, 63, 63, 55, 40, 40, 40, 40],
				[40, 40, 40, 43, 43, 02, 67, 56, 63, 63, 60, 58, 58, 56, 63, 55, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 43, 43, 02, 58, 58, 01, 43, 43, 02, 63, 67, 40, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 43, 43, 43, 43, 40, 40, 43, 67, 61, 67, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 43, 67, 01, 40, 40, 40],
				[40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 43, 43, 40, 40, 40]
			];// on évite de recrée plusieur carte une par dessu l'autre
			if (grille == null) {
				grille = new MovieClip();
			}
			addChild(grille);
			// on évite de recrée des élément 
			// s'active uniquement si le clip est vide
			if (_nouvLevierUn == null) {
				if (premierMap == true) _nouvLevierUn = new MovieClip();
				for (var r: int = 0; r < RANG; r++) {
					for (var c: int = 0; c < COL; c++) {
						var t: Tuile = new Tuile();
						grille.addChild(t);
						t.x = c * TAILLE;
						t.y = r * TAILLE;
						t.gotoAndStop(_tMap[r][c]);
						if (premierMap == true) {
							if (t.currentFrame == 61) {// chaque tuile que son numéro est 61 ajoute un levier
								if (_nouvLevierUn.numChildren <= 7) {//pour éviter d'avoir trop de levier
									l = new Levier();
									_nouvLevierUn.addChild(l);// ajouter le levier au clip
									_toutLevierUn.push(l); // ajoute toute les levier dans un array pour les enigmes
								}
								l.x = t.x;
								l.y = t.y;
							}
						}
					}
				}
			}
			grille.x = 0;
			grille.y = 0;
			// s'Active uniquement si le clip n'esp pas vide
			if (premierMap == false) {
				var changetuile: int = 0;// crée une variable qui va remplacer la valeur des tuile pour les actualiser
				for (var ran: int = 0; ran < RANG; ran++) { // parcout le trableau
					for (var col: int = 0; col < COL; col++) {
						Tuile(grille.getChildAt(changetuile)).gotoAndStop(_tMap[ran][col]); // on remplaceles clip de la tuile par leur position (changetuile) 
						changetuile++;// on augmente la valeur de la position
					}
				}
				// on ajoute les élément sur le stage dans l'ordre voulu 
				addChild(grille); 
				addChild(_nouvLevierUn);
				addChild(_nouvPorteUn);
				_nouvLevierUn.visible = true;
			}
			addChild(_nouvLevierUn);

		}
		// fonction sert a crée la premier porte (usa) 
		private function creerPorte(): void {
			if (_nouvPorteUn == null) {// si le clip est vide on peux effectuer ce code (ajouter la porte)
				_nouvPorteUn = new MovieClip();
				p = new Porte();
				_nouvPorteUn.addChild(p);
			}
			addChild(_nouvPorteUn); // ajouter la porte sur le stage
			// position de la porte
			p.y = 300;
			p.x = 450;
		}
		// fonction sert a crée la premier porte (France) 
		private function creerPorteDeux(): void {
			if (_nouvPorteDeux == null) {// si le clip est vide on peux effectuer ce code (ajouter la porte)
				_nouvPorteDeux = new MovieClip();
				pDeux = new PorteDeux();
				_nouvPorteDeux.addChild(pDeux);
			}
			addChild(_nouvPorteDeux);// ajouter la porte sur le stage
			// position de la porte
			pDeux.y = 200;
			pDeux.x = 400;
		}
		// on génère la premiere enigme
		private function genereEnigmeUn(): void {
			accesUn = false;
			var enigme: int;
			var noReapetEnigme: Array = new Array;
			noReapetEnigme.splice(0);
			_enigmeOfficielUn.splice(0);
			for (var i: int = 0; i <= 100; i++) {
				enigme = rand(0, _toutLevierUn.length - 1); // on va chercher un chiffre aléatoire pour les levier
				if (noReapetEnigme.indexOf(enigme, 0) == -1) { // on s'assure que le nombre utiliser ne sois pas répéter
					_troisLevierUn.push(_toutLevierUn[enigme]); // on retire les leviers pour les rajouter dans un autre tableau (celui des enigne)
					_enigmeOfficielUn.push(_enigmeTextUn[enigme]); // on va chercher les bon enigme relier au bon levier
					// un fois arriver a 3 élément différent on sort de la fonction
					noReapetEnigme.push(enigme); // on rajoute le  numéro de l'énigme pour éviter d'avoir des doublon
					if (_enigmeOfficielUn.length == 3) {
						return void;
					}
				}
			}

		}
		// enigme deux ---------------------------------------------------------------------
		// on génère la seconde enigme
		private function genereEnigmeDeux(): void {
			accesDeux = false;
			var enigme: int;
			_enigmeOfficielDeux = new Array;
			var noReapetEnigme: Array = new Array;
			noReapetEnigme.splice(0);
			for (var i: int = 0; i <= 100; i++) {
				enigme = rand(0, _toutLevierUn.length - 1); // on va chercher un chiffre aléatoire pour les levier
				if (noReapetEnigme.indexOf(enigme, 0) == -1) { // on s'assure que le nombre utiliser ne sois pas répéter
					_troisLevierDeux.push(_toutLevierDeux[enigme]); // on retire les leviers pour les rajouter dans un autre tableau (celui des enigne)
					_enigmeOfficielDeux.push(_enigmeTextDeux[enigme]); // on va chercher les bon enigme relier au bon levier

					noReapetEnigme.push(enigme); // on rajoute le  numéro de l'énigme pour éviter d'avoir des doublon
					if (_enigmeOfficielDeux.length == 3) {
						return void;
					}
				}
			}

		}
		// générer le skelette qui indique les enigmes
		private function genereSkelette(): void {
			// le skelette affiche les enigme en conséquence du pays
			if (_paysActuel == "USA") {
				if (accesUn == true) {
					genereEnigmeUn();
				}
			} else if (_paysActuel == "France") {
				if (accesDeux == true) {
					genereEnigmeDeux();
				}
			}
			if (_infoUn == null) { // si le clip est vide il effectu  le code si dessou 
				_infoUn = new MovieClip();// crée un clip
				i = new Info(); 
				addChild(_infoUn);
				_infoUn.addChild(i); // ajouter l'élément de la class dans le clip
				var squeletteUn = _infoUn.getChildAt(0);// assosie le skelette a la l'élément du clip
				squeletteUn.x = 400;
				squeletteUn.y = 500;
			} else {// si le clip n'est pas vide on reposition le skelette sur la carte
				addChild(_infoUn);
				//return void;
			}

		}
		// MAP2------------------------------------------------------------------------------------------------
		// function créant la seconde carte
		private function changerGrille(): void {
			if (Trump(_nouvTrump.getChildAt(0)).posY == 1) {// ce code seffection si le joueur est dans le haut de la carte
				_paysActuel = "France";// on informe le sketelle qu'on est en frace pour qu'il affiche les bon élément
				_mapUn = false;
				_tMap = [ // change la valeur du array pour la seconde carte
					[40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 100, 100, 100, 40, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 04, 48, 48, 63, 63, 63, 48, 03, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 04, 63, 63, 63, 63, 63, 63, 63, 50, 48, 48, 03, 40, 40, 40, 40],
					[40, 40, 40, 40, 51, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 50, 03, 40, 40, 40],
					[40, 40, 40, 40, 40, 63, 63, 63, 63, 63, 61, 63, 63, 63, 63, 61, 63, 67, 40, 40],
					[40, 40, 40, 40, 40, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 60, 01, 40, 40, 40],
					[40, 40, 40, 04, 48, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 55, 40, 40, 40, 40],
					[40, 04, 48, 63, 61, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 55, 40, 40, 40, 40],
					[40, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 61, 63, 50, 48, 40, 40, 40],
					[40, 40, 40, 40, 63, 63, 61, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 03, 40, 40],
					[40, 40, 40, 40, 40, 40, 02, 63, 63, 63, 63, 63, 61, 63, 63, 61, 60, 01, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 02, 63, 63, 63, 63, 60, 63, 63, 63, 63, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 02, 61, 63, 63, 01, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40],
					[40, 40, 40, 40, 40, 40, 40, 40, 40, 51, 63, 55, 40, 40, 40, 40, 40, 40, 40, 40]
				];
				// ajoute la grille sur la scene
				addChild(grille);
				// évite de recréer des élément
				if (premierMap == true) { // si la valeur est null 
					if (_nouvLevierDeux == null) {
						_nouvLevierDeux = new MovieClip;// crée le clip
					}
					creerPorteDeux(); // ajouter la seconde porte
					var changetuile: int = 0;   // crée une variable qui va remplacer la valeur des tuile pour les actualiser
					for (var r: int = 0; r < RANG; r++) {
						for (var c: int = 0; c < COL; c++) {
							Tuile(grille.getChildAt(changetuile)).gotoAndStop(_tMap[r][c]); // affiche la tuile selon sa position
							changetuile++; // augment la valeur pour la prochaine tuile 
							if (premierMap == true) {// pour éviter de recréer des levier
								if (_tMap[r][c] == 61) {// chaque tuile que son numéro est 61 ajoute un levier
									if (_nouvLevierDeux.numChildren <= 7) {// évite de ce retrouver avec trop de levier
										lDeux = new LevierDeux();
										addChild(_nouvLevierDeux);
										_nouvLevierDeux.addChild(lDeux);// ajouter le levier au clip
										_toutLevierDeux.push(lDeux); // ajoute toute les levier dans un array pour l'enigmes 2
									}// on position le les tuiles
									lDeux.x = Tuile(grille.getChildAt(changetuile)).x;
									lDeux.y = Tuile(grille.getChildAt(changetuile)).y;
								}
							}
						}
					}
				}
				premierMap = false;
				// positionne la grille
				grille.x = 0;
				grille.y = 0;
				if (premierMap == false) { // si la carte a déja été créer
					changetuile = 0;// réinitialise les tuile
					for (var ran: int = 0; ran < RANG; ran++) {
						for (var col: int = 0; col < COL; col++) {
							Tuile(grille.getChildAt(changetuile)).gotoAndStop(_tMap[ran][col]);// affiche la tuile selon sa position
							changetuile++;// augment la valeur pour la prochaine tuile 
						}
					}
					_nouvLevierUn.visible = false; // cache le premier levier 
					addChild(_nouvLevierDeux);
					addChild(_nouvPorteDeux);

				}

			} else if (Trump(_nouvTrump.getChildAt(0)).posY == 19) {// si trump est plus bas qu la derniere tuile on affiche la premiere map
				_mapUn = true;
				creerGrille();
				// on réaffiche les autre élment au dessu de la map
				addChild(_nouvLevierUn);
				addChild(_nouvPorteUn);
			}
			moveTrump(); // on déplace le joueur
		}
		// gestion trump------------------------------------------------------------------------------------------------
		// permet de déplacer le joueur selon sa sorti de carte
		private function moveTrump(): void {
			var posX: int = _nouvTrump.getChildAt(0).x;// on va chercher le X "joueur" ou le trump 
			if (Trump(_nouvTrump.getChildAt(0)).posY == 1) {
				spawnTrump(posX, 875); //  // on déplace sa position
				Trump(_nouvTrump.getChildAt(0)).trumpY = 18; // on change sa position dans le tableau
				Trump(_nouvTrump.getChildAt(0)).trumpX = Math.floor((posX / 50) + 1); // on le centre a une tuile
			} else if (Trump(_nouvTrump.getChildAt(0)).posY == 19) {
				spawnTrump(posX, 130);// on déplace sa position
				Trump(_nouvTrump.getChildAt(0)).trumpY = 3;// on change sa position dans le tableau
				Trump(_nouvTrump.getChildAt(0)).trumpX = Math.floor((posX / 50) + 1);// on le centre a une tuile
			}
		}
		//
		private function spawnTrump(posX: int, posY: int): void {
			if (_nouvTrump == null) { // si trump n'existe pas on le créer
				t = new Trump(); 
				_nouvTrump = new MovieClip();// créer le clip de trump
				addChild(_nouvTrump); // on ajoute ce clip a la scene
				_nouvTrump.addChild(t); // on ajouter un trump dans le clip
			}
			// on position trump
			t.x = posX;
			t.y = posY;
			// on ajoute des keyboard event a trump
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);

		}
		//----------------------------------- FIN PARTI + RESET---------------------------------
		// on réinitialise le jeux a la fin de la parti
		public function finParti(): void {
			
			channel.stop();
			_troisLevierUn.splice(0); // on remet les tableau a 0
			_troisLevierDeux.splice(0);// on remet les tableau a 0
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeEventListener(Event.ENTER_FRAME, loop);

		}
		public function reset(e: Event): void { // va permetre de redemarer une nouvelle parti
			//init();
		}
			// fonction va permettre une movement fluide de trump 
		private function keyDown(e: KeyboardEvent): void {
			if (e.keyCode == Keyboard.A) {
				_gauche = true;
			}
			if (e.keyCode == Keyboard.D) {
				_droite = true;
				//t.allerDroite();
			}
			if (e.keyCode == Keyboard.W) {
				_haut = true;
			}
			if (e.keyCode == Keyboard.S) {
				_bas = true;
			}
			if (e.keyCode == Keyboard.SPACE) {
				t.activer();
			}

		}// fonction va permetre d'arreter le mouvement de trump
		private function keyUp(e: KeyboardEvent): void {

			if (e.keyCode == Keyboard.A) {
				_gauche = false;
				t.arretGauche();
			}
			if (e.keyCode == Keyboard.D) {
				_droite = false;
				t.arretDroite();
			}
			if (e.keyCode == Keyboard.W) {
				_haut = false;
				t.arretHaut();
			}
			if (e.keyCode == Keyboard.S) {
				_bas = false
				t.arretBas();
			}

		}
		// ATTRIBUE PUBLIC
		//partager le pays
		public function get paysActuel(): String {
			return _paysActuel;
		}
		//partage la valeur booleen pour savoir s'il se situer bien dans la premiere map ou non
		public function get mapUn(): Boolean {
			return _mapUn;
		}
		// partage le array de la map (pour les limitation de mouvement)
		public function get tMap(): Array {
			return _tMap;
		}
		// partage les clip de levier
		public function get nouvLevier(): MovieClip {
			return _nouvLevierUn;
		}// partage les clip de levier
		public function get nouvLevierDeux(): MovieClip {
			return _nouvLevierDeux;
		}
		// getter pour trump
		public function get nouvTrump(): MovieClip {
			return _nouvTrump;
		}
		// partage les enigme pour le skelette
		public function get enigmeOfficielUn(): Array {
			return _enigmeOfficielUn;
		}// partage les enigme pour le skelette
		public function get enigmeOfficielDeux(): Array {
			return _enigmeOfficielDeux;
		}// foncition permet de faire avancer les enigme en changent la vleur du levier a activer 
		public function removeEnigmeUn(): void {
			if (_paysActuel == "USA") {
				if (_levierActuel <= _troisLevierUn.length) {
					_levierActuel++;
				} else {
					return void;
				}
			} else if (_paysActuel == "France") {
				if (_levierActuelDeux <= _troisLevierDeux.length) {
					_levierActuelDeux++;
				} else {
					return void;
				}
			}
		}
		private function rand(n1: int, n2: int): Number {
			return Math.floor(Math.random() * (n2 - n1 + 1) + n1);
		}
	} //classe
} //package